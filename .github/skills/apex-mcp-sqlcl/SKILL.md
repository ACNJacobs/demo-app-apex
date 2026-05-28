---
name: apex-mcp-sqlcl
description: How to use the SQLcl MCP server (Oracle SQL Developer VS Code extension) for fast, reliable DB queries against the local Oracle 23ai / APEX 26.1 stack. Covers when to use sql_run vs sqlcl_run vs docker exec sqlplus, and the known freeze/substitution traps. Use whenever you need to query or update Oracle DB or APEX dictionary objects.
---

# SQLcl MCP — usage rules

Saved MCP connections in this workspace (case-sensitive):

| Name | User | Target | Use for |
|---|---|---|---|
| `databeest` | APP_DATA | localhost:2521/freepdb1 | App schema queries (default) |
| `apex_dev` | APP_DATA | localhost:2521/FREEPDB1 | Alias for same |
| `apex_sys` | system | localhost:2521/FREEPDB1 | SYS-level rescue (ADMIN expiry, ACL, schema create) |

Tools exposed by the MCP server: `connections_list`, `connect`, `disconnect`, `sql_run`, `sqlcl_run`, `schema_information`, `request_status`, `skills_sync`. All statements audited to `APP_DATA.DBTOOLS$MCP_LOG`.

## Decision matrix

| Task | Use |
|---|---|
| `SELECT … FROM table` (no `&`) | ✅ `mcp_sqlcl_-_sql_d_sql_run` on `databeest` |
| `SELECT … WHERE col = 'X'` (no PL/SQL block) | ✅ `sql_run` |
| `DESC <object>` / schema lookup | ✅ `mcp_sqlcl_-_sql_d_schema_information` |
| Single DDL with no `/` and no `&` (e.g. `create or replace view … as select …;`) | ✅ `sql_run` |
| **PL/SQL block ending in `/`** (package body, anonymous block) | ⚠️ `sqlcl_run` BUT often freezes — see below |
| **SQL containing `&` substitution chars** (e.g. `'f?p=&APP_ID.'`) | ❌ MCP triggers sqlplus-style prompt and CANCELS the call — use docker exec sqlplus with `set define off` |
| Multi-statement install script | ❌ Use docker exec sqlplus piping a file |
| SYS rescue | ❌ Use docker exec sqlplus as sysdba |

## The freeze trap

`sqlcl_run` with multi-statement input ending in `/` (typical for package bodies) can freeze the MCP session. Symptom: subsequent `sql_run` returns `(empty)` regardless of query. Recovery: `mcp_sqlcl_-_sql_d_disconnect` then `mcp_sqlcl_-_sql_d_connect` with `connectionName: databeest`. If still stuck, fall back to docker exec for that statement.

## Fallback recipes (when MCP cannot be used)

### App schema (APP_DATA)

```powershell
$sql = @"
set define off
set serveroutput on size unlimited
-- your SQL/PLSQL here
"@
$sql | docker exec -i apex_db sqlplus -L -S 'APP_DATA/Welkom_APEX_2026!@localhost:1521/FREEPDB1'
```

### SYS rescue (ADMIN expiry, ACL, schema create)

```powershell
$sql = @"
set define off
-- update apex_260100.wwv_flow_fnd_user set account_expiry = sysdate+3650 where …;
-- commit;
"@
$sql | docker exec -i apex_db sqlplus -L -S 'SYS/Welkom_APEX_2026!@localhost:1521/FREEPDB1 as sysdba'
```

### Compile a package file

```powershell
Get-Content db/packages/pkg_<prefix>_ui.sql `
  | docker exec -i apex_db sqlplus -L -S 'APP_DATA/Welkom_APEX_2026!@localhost:1521/FREEPDB1'
```

### SQLcl (for `apex export/import/validate`)

Wrappers in `scripts/` use this internally; don't call manually unless debugging:

```powershell
docker exec -i apex_ords sql -S APP_DATA/Welkom_APEX_2026!@apex_db:1521/FREEPDB1
```

## Useful one-liners

```sql
-- list apps in workspace
select application_id, alias, application_name
  from apex_applications where workspace = 'APEX_DEV' order by application_id;

-- list pages in app X
select page_id, page_alias, page_name
  from apex_application_pages where application_id = <id> order by page_id;

-- compile errors in current schema
select name, line, position, text from user_errors order by name, line;

-- check translations for app X
select translatable_message, language_code, message_text
  from apex_application_translations
 where application_id = <id> order by 1, 2;

-- workspace id for APEX_DEV
select workspace_id from apex_workspaces where workspace = 'APEX_DEV';
```

## Hard rules

- ✅ PREFER MCP for plain selects — no PowerShell escaping, no `set define off` noise.
- ❌ NEVER paste `&NAME.` substitution chars into MCP — call gets cancelled.
- ❌ NEVER chain multiple `/`-terminated blocks in `sqlcl_run` — freeze risk.
- ❌ NEVER store credentials anywhere else than this workspace's dev recipes (the dev pwd `Welkom_APEX_2026!` is OK in scripts; user APEX pwd `Anisa24v#` only in private notes).

## SQL vs SQLcl command classification

Not everything that runs in a SQLcl session is plain SQL. Pick the right MCP tool:

| Command | Type | Use |
|---|---|---|
| `select` / `insert` / `update` / `delete` / `merge` | **SQL** | `sql_run` |
| `create or replace package …` ending in `/` | **PL/SQL** | `sqlcl_run` (freeze risk) or docker exec |
| `begin … end;` anonymous block ending in `/` | **PL/SQL** | same |
| `show errors` | **SQLcl-only** | `sqlcl_run` — fails in `sql_run` |
| `desc <object>` | **SQLcl-only** | prefer `schema_information` |
| `apex export`, `apex export -list`, `apex import` | **SQLcl-only** | NEVER via MCP — use `scripts/apex-*.ps1` wrappers |
| `info`, `ddl`, `oerr`, `codescan`, `tnsping` | **SQLcl-only** | `sqlcl_run` |
| `set define off`, `set serveroutput on` | **SQLcl session settings** | only meaningful in docker exec session, ignored by MCP |

## Post-PL/SQL-compile checks (always run after package edit)

```sql
select object_name, object_type, status
  from user_objects
 where object_name in ('PKG_X','PKG_Y');
-- expect STATUS = VALID

select name, type, line, position, text
  from user_errors
 where name in ('PKG_X','PKG_Y')
 order by name, type, sequence;
-- expect 0 rows
```

If `sqlcl_run` returned no error but `user_errors` has rows: the compile failed silently. Read errors, fix, recompile, re-check.
