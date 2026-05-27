---
applyTo: "db/**/*.{sql,pks,pkb}"
description: "PL/SQL package + view conventions for SCAFF APP"
---

# PL/SQL Conventions

## Naming

| Kind | Prefix | Example |
|---|---|---|
| Package (UI helper) | `PKG_SCAFF_*` or `HD_*_PKG` | `PKG_SCAFF_UI`, `HD_MOBILE_UI_PKG` |
| Driver view | `V_*` | `V_MOBILE_MENU` |
| Install helper | `HD_*_INSTALL` | `HD_I18N_INSTALL` |

## Package Style

- Spec + body in **one file** for small packages (`db/packages/<name>.sql`), separate `.pks`/`.pkb` only if > 300 lines.
- Always `CREATE OR REPLACE` — idempotent install.
- End every package with a re-compile check comment showing how to verify:
  ```sql
  -- verify: SELECT object_name, status FROM user_objects WHERE object_name = 'PKG_SCAFF_UI';
  ```
- Return `CLOB` (not `VARCHAR2`) for HTML/CSS generators — content easily exceeds 32 KB.
- Use `apex_escape.html(...)` for any user-supplied or label text inserted into HTML.
- Use `apex_util.prepare_url(...)` for hrefs that include APEX session state.
- Use `apex_lang.message('SCAFF.…')` for any user-visible text.

## Forbidden

- `DBMS_OUTPUT.PUT_LINE` for runtime logging — use `apex_debug.message` instead.
- Hard-coded schema names (use synonyms or current_schema).
- `EXECUTE IMMEDIATE` on user input without bind variables.

## Install Order

`build_helpdesk.sql` (root) drives installation. New packages must be appended in dependency order:

1. Views (`db/views/*.sql`)
2. Install helpers (`db/i18n/_install_helper.sql`)
3. Messages (`db/i18n/messages_*.sql`)
4. UI packages (`db/packages/hd_*.sql`, `db/packages/pkg_scaff_*.sql`)

## Connection for Compile

```powershell
Get-Content db/packages/pkg_scaff_ui.sql | `
  docker exec -i apex_db sqlplus -L -S "APP_DATA/Welkom_APEX_2026!@localhost:1521/FREEPDB1"
```
