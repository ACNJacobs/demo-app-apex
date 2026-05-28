---
name: apex-26-patterns
description: Battle-tested APEXlang patterns, gotchas, and parser quirks for Oracle APEX 26.1. Use whenever editing .apx files, writing PL/SQL that returns HTML for APEX, or debugging APEX runtime issues (substitution strings, validate errors, dynamic regions, classic reports, friendly URLs, ADMIN account expiry).
---

# APEX 26.1 Patterns & Gotchas (generic)

The hard-won lessons. Read this BEFORE editing `.apx` or writing PL/SQL HTML helpers — it saves an export/import round-trip.

## 1. `&APP_ID.` substitution does NOT happen in `dynamicContent` CLOB

APEX substitutes `&APP_ID.`, `&APP_SESSION.`, `&DEBUG.` in static region source and item defaults, but **not** in a CLOB returned from `plsqlFunctionBody`. Symptom: anchor `href="f?p=&APP_ID.:50:::&DEBUG.:::"` renders literally; user clicks → blue "Application not found".

**Fix — substitute in PL/SQL:**

```sql
l_link := replace(l_link, '&'||'APP_ID.',      to_char(apex_application.g_flow_id));
l_link := replace(l_link, '&'||'APP_SESSION.', to_char(apex_application.g_instance));
l_link := replace(l_link, '&'||'DEBUG.',       nvl(v('DEBUG'),'NO'));
```

Or build the URL native and skip the tokens entirely:

```sql
l_link := apex_util.prepare_url(
  'f?p='||apex_application.g_flow_id||':50:'||apex_application.g_instance);
```

> The `'&'||'APP_ID.'` concatenation prevents sqlplus/SQLcl from prompting for the substitution variable when the file is loaded.

## 2. APEXlang `classicReport` is STRICT

The parser rejects:
- ❌ `sqlQuery` (requires `source.tableName` + child `column { … }` blocks)
- ❌ `pagination { … }` sub-block (use `report.pagination: <enum>` scalar instead)
- ❌ ad-hoc joins / unions

**Workaround for ad-hoc lists**: use a `dynamicContent` region calling a PL/SQL function that returns an HTML `<table>` CLOB. Faster, no parser fights, full SQL flexibility. See `apex-26-mobile-cards` skill, "Data-list variant".

## 3. LF line endings only

APEXlang parser ACCEPTS ONLY LF. Files created on Windows via tools are CRLF and fail validate with confusing `MISSING_REQUIRED_PROPERTY` errors on properties that are clearly present.

**Fix after every `create_file` of a `.apx` on Windows:**

```powershell
$p='apex_app/<alias>/pages/pNNNNN.apx'
$c=[IO.File]::ReadAllText($p) -replace "`r`n","`n"
[IO.File]::WriteAllText($p,$c)
```

`scripts/apex-export.ps1` does this automatically after export.

## 4. Page-title `&MSG.X.TITLE.` cosmetic bug

APEX parses the first `.` in a substitution string as terminator, so `title: &APP.MENU.X.TITLE.` renders the browser tab as `MENU.X.TITLE.` literally. Cosmetic only (visible title region is fine).

**Workaround (TBD)**: PL/SQL expression for page title returning `apex_lang.message(…)`. Until then, accept it.

## 5. APEX 26.1 export bug: OLLAMA enum

`wwv_flow_genai_services` stores `provider=OLLAMA`, but APEXlang validator only accepts `cohere | genericOpenaiApiCompatible | googleGemini | ociGenAI | openai`. `scripts/apex-export.ps1` auto-patches this on export.

## 6. ADMIN account expiry silently locks you out

`apex_260100.wwv_flow_fnd_user.account_expiry` defaults to ~180 days. The day after expiry: "Invalid Login Credentials" (no expiry message). `apex_util.edit_user(p_account_lifetime_days=>...)` is a no-op for this column.

**SYS rescue:**

```sql
update apex_260100.wwv_flow_fnd_user
   set account_expiry = sysdate + 3650,
       failed_access_attempts = 0
 where user_name = 'ADMIN'
   and security_group_id = (select workspace_id from apex_workspaces
                              where workspace = 'APEX_DEV');
commit;
```

Also missing developer roles → "Restricted End User Access". Fix with:

```sql
apex_util.set_security_group_id(<workspace_id>);
apex_util.edit_user(
  p_user_name                 => 'ADMIN',
  p_developer_roles           => 'ADMIN:DEVELOPER',
  p_default_schema            => 'APP_DATA',
  p_allow_access_to_schemas   => 'APP_DATA');
```

Param is `p_developer_roles` (colon list), NOT `p_developer_privs`.

## 7. Friendly URL requires workspace prefix

URL pattern: `http://localhost:8080/ords/r/<workspace-alias>/<app-alias>/<page-alias>`

- ✅ `http://localhost:8080/ords/r/apex_dev/scaff-app/home`
- ❌ `http://localhost:8080/ords/r/scaff-app/home` → blue "Application not found" dialog

Classic URL always works: `http://localhost:8080/ords/f?p=<id>:<page>`.

## 8. Workspace messages — correct query

```sql
-- correct column is translatable_message (NOT message_name / static_id)
select translatable_message, language_code, message_text
  from apex_application_translations
 where application_id = <id>
 order by translatable_message, language_code;
```

Outside an APEX session, `apex_lang.message(<key>)` returns the KEY itself — verify translations via the table above.

## 9. PL/SQL HTML CLOB helper — canonical template

```sql
create or replace function get_my_region return clob is
  l_out clob;
  l_home varchar2(4000) := apex_util.prepare_url(
    'f?p='||apex_application.g_flow_id||':1:'||apex_application.g_instance);
begin
  dbms_lob.createtemporary(l_out, true);

  apex_string.push(l_out, '<style>');
  apex_string.push(l_out, HD_MOBILE_UI_PKG.get_menu_css);  -- or your CSS helper
  apex_string.push(l_out, '</style>');

  apex_string.push(l_out, '<div class="myapp-list">');
  for r in ( select id, title, status from my_table
              where lower(coalesce(owner,'x')) = lower(v('APP_USER'))
              order by created_at desc fetch first 50 rows only ) loop
    apex_string.push(l_out, '<div class="myapp-list__row">'
       || '<span class="myapp-pill myapp-pill--'|| apex_escape.html(r.status) ||'">'
       || apex_escape.html(r.status) ||'</span> '
       || apex_escape.html(r.title) ||'</div>');
  end loop;
  apex_string.push(l_out, '</div>');

  apex_string.push(l_out, '<a class="myapp-back" href="'|| l_home ||'">&larr; Home</a>');
  return l_out;
end;
/
```

Pair with a region:

```
region <code> (
    template: @/blank-with-attributes-no-grid
    type: dynamicContent
    source {
        plsqlFunctionBody: return PKG_MYAPP_UI.get_my_region;
    }
)
```

## 10. APEXlang property cheats

| Property | Common values |
|---|---|
| `region.type` | `staticContent`, `dynamicContent`, `classicReport`, `interactiveReport`, `interactiveGrid`, `form`, `chart`, `tree`, `breadcrumb`, `list` |
| `region.template` | `@/standard`, `@/blank-with-attributes`, `@/blank-with-attributes-no-grid`, `@/hero`, `@/content-block` |
| `page.pageMode` | `normal`, `modalDialog`, `nonModalDialog`, `drawer` |
| `item.type` | `text`, `textarea`, `selectList`, `popupLov`, `checkbox`, `radioGroup`, `datePicker`, `hidden`, `display` |
| `button.action` | `submitPage`, `redirect`, `defined-by-dynamic-action` |

When unsure of an exact value, grep an existing exported app:

```powershell
Select-String -Pattern 'type:' -Path apex_app/scaff-app/pages/*.apx | Select-Object -First 20
```

## 11. Substitution in PL/SQL output — always escape

```sql
htp.p(apex_escape.html(apex_lang.message('MYAPP.PAGE.X.TITLE')));
```

Never `htp.p('<div>'||v('P1_INPUT')||'</div>')` — XSS.

## 12. Region rendering — when in doubt

Use template `@/blank-with-attributes-no-grid` for full-bleed mobile cards. Use `@/standard` for normal desktop regions. Avoid `@/hero` — its `region_image` slot renders a giant left-side icon you usually don't want.
