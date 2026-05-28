---
name: apex-rest-integrations-secure
description: Patterns for calling REST APIs from Oracle APEX / PL/SQL safely — apex_web_service usage, secrets handling, OAuth, multipart uploads, webhook signature validation, response classification, logging without leaks. Use whenever the user adds, debugs, or audits a REST integration (outbound or inbound). Distilled from oracle-apex-ai-skills.
---

# REST Integrations — Secure Patterns

REST integrations are the #1 vector for credential leaks in APEX apps. Always treat tokens/keys as toxic data — never log, never echo, never put in URL.

## 1. Outbound call — canonical pattern

```sql
declare
  l_response clob;
  l_status   pls_integer;
begin
  apex_web_service.g_request_headers.delete;
  apex_web_service.g_request_headers(1).name  := 'Content-Type';
  apex_web_service.g_request_headers(1).value := 'application/json';
  apex_web_service.g_request_headers(2).name  := 'Authorization';
  apex_web_service.g_request_headers(2).value := 'Bearer '||get_token_from_credential_store;

  l_response := apex_web_service.make_rest_request(
                   p_url         => 'https://api.example.com/v1/resource',
                   p_http_method => 'POST',
                   p_body        => json_object('key' value 'value'));

  l_status := apex_web_service.g_status_code;

  -- classify before doing anything with the body
  case
    when l_status between 200 and 299 then handle_success(l_response);
    when l_status = 401             then handle_auth_failure;     -- token expired / wrong
    when l_status = 429             then handle_rate_limit;        -- backoff + retry
    when l_status between 400 and 499 then handle_client_error(l_status, l_response);
    when l_status between 500 and 599 then handle_server_error(l_status, l_response);
    else handle_unexpected(l_status, l_response);
  end case;
end;
```

## 2. Secrets handling — hard rules

- ✅ Store credentials in **APEX Workspace → Web Credentials** (`apex_credentials`). Reference by static_id, never by literal.
- ✅ For DB-side jobs (no APEX session), use a separate credential package backed by `dbms_vault` or an encrypted table with restricted GRANT.
- ❌ NEVER store API keys / passwords / tokens in source files, .apx, git, or as plain table columns.
- ❌ NEVER pass secrets in URL query strings — they hit web server logs, browser history, proxies.
- ❌ NEVER log raw values of: `Authorization`, `access_token`, `refresh_token`, `api_key`, `x-api-key`, `password`, `cookie`, `wallet`, `client_secret`.

## 3. Safe logging template

```sql
procedure log_call (
  p_op          varchar2,
  p_url_kind    varchar2,    -- e.g. 'orders/create', NOT the full URL with tokens
  p_method      varchar2,
  p_status      number,
  p_duration_ms number,
  p_attempt     number,
  p_error_brief varchar2     -- redacted summary, NO body
) is begin
  insert into rest_call_log(ts, op, url_kind, method, status, duration_ms, attempt, error_brief)
  values (systimestamp, p_op, p_url_kind, p_method, p_status, p_duration_ms, p_attempt, p_error_brief);
  commit;
end;
```

Never log: full request body if it could contain PII; full response if it could echo a token; full URL if it has query-string secrets.

## 4. OAuth 2.0 client credentials flow

```sql
function get_token return varchar2 is
  l_resp clob;
begin
  -- check cache first (token table with expiry)
  if cached_token_still_valid then return cached_token; end if;

  l_resp := apex_web_service.make_rest_request(
              p_url => 'https://issuer.example.com/oauth/token',
              p_http_method => 'POST',
              p_parm_name => apex_string.string_to_table('grant_type:client_id:client_secret'),
              p_parm_value => apex_string.string_to_table('client_credentials:'||v_client_id||':'||v_client_secret));

  if apex_web_service.g_status_code <> 200 then
    raise_application_error(-20100, 'Token endpoint failed: '||apex_web_service.g_status_code);
  end if;

  cache_token(json_value(l_resp, '$.access_token'), json_value(l_resp, '$.expires_in'));
  return cached_token;
end;
```

Always cache tokens with expiry. Refresh only when expired or 401 received. NEVER request a new token per call.

## 5. Webhook receiver — signature validation

Inbound REST handlers (ORDS) must validate signatures BEFORE trusting payload:

```sql
-- HMAC-SHA256 example
function valid_signature(p_body clob, p_signature_header varchar2) return boolean is
  l_expected varchar2(64);
begin
  l_expected := lower(rawtohex(dbms_crypto.mac(
                  src => utl_raw.cast_to_raw(p_body),
                  typ => dbms_crypto.hmac_sh256,
                  key => utl_raw.cast_to_raw(get_webhook_secret))));
  return l_expected = lower(p_signature_header);
end;
```

Reject with 401 if signature mismatch. NEVER log the signature value.

## 6. Multipart / file upload

Use `apex_web_service.make_rest_request_b` for binary. Stream from BLOB, don't materialise full file in PL/SQL string:

```sql
l_resp := apex_web_service.make_rest_request_b(
            p_url => '…',
            p_http_method => 'POST',
            p_body_blob => l_file_blob,
            p_parm_name => apex_string.string_to_table('Content-Type:Authorization'),
            p_parm_value => apex_string.string_to_table('application/octet-stream:Bearer '||get_token));
```

For multipart (mixed fields + files), build the boundary manually or use `apex_web_service.append_to_request` available in 22.1+.

## 7. Network ACL (Oracle 23ai)

ORA-24247 "network access denied" means the DB has no ACL for the target host. Fix as SYS:

```sql
begin
  dbms_network_acl_admin.append_host_ace(
    host => 'api.example.com',
    ace  => xs$ace_type(
              privilege_list => xs$name_list('http','connect','resolve'),
              principal_name => 'APP_DATA',
              principal_type => xs_acl.ptype_db));
end;
/
```

For HTTPS also configure the wallet (`utl_http.set_wallet`) or use `set_wallet_location` per call.

## 8. Retry / backoff

For 429 / 5xx: exponential backoff with jitter, MAX 3 attempts. Never retry 4xx that isn't 408/429 (won't fix itself).

```sql
for i in 1 .. 3 loop
  l_status := call_api;
  exit when l_status between 200 and 399;
  exit when l_status between 400 and 499 and l_status not in (408, 429);
  dbms_session.sleep(power(2, i) + dbms_random.value(0, 1));   -- 2s, 4s, 8s + jitter
end loop;
```

## 9. Audit / observability — minimum

For each integration, you should be able to answer:
- How many calls in the last hour / day? (per operation)
- What's the 95p latency?
- What's the error rate? (4xx vs 5xx)
- When did we last get a 401? (token rotation due?)

Build a small `REST_CALL_LOG` table and a daily summary view (`V_REST_HEALTH`).

## 10. Hard rules

- ❌ NEVER hard-code API keys.
- ❌ NEVER log raw `Authorization` headers or token values.
- ❌ NEVER trust webhook payload without signature validation.
- ❌ NEVER retry non-idempotent calls (POST/PUT that creates) without an idempotency key.
- ✅ ALWAYS classify status code before parsing body.
- ✅ ALWAYS cache OAuth tokens until expiry.
- ✅ ALWAYS configure ACL + wallet before first call.
- ✅ ALWAYS log sanitized metadata (op, status, duration), never secrets/PII.
