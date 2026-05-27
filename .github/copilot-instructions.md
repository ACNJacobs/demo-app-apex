# Altrad SCAFF APP — Copilot Instructions

Project-wide rules. These apply to **every** Copilot Chat in this workspace.

## Project at a Glance

- **App**: SCAFF APP (id `100`, alias `SCAFF-APP`) — mobile-first APEX app for material/return/transfer requests.
- **APEX**: `26.1` (workspace `APEX_DEV` id `5800403880636291`, parsing schema `APP_DATA`).
- **DB**: Oracle 23ai Free in Docker container `apex_db`, PDB `FREEPDB1`, host port `2521` → container `1521`. Charset `AL32UTF8`.
- **ORDS / SQLcl 26.1.2**: container `apex_ords`, base URL `http://localhost:8080/ords/`.
- **Branding**: Altrad — primary `#E2001A`, dark `#B30015`, soft `#FCE6E9`.
- **Languages**: NL (primary) + EN, via APEX text messages (`apex_lang.message`).

## Source of Truth (Versioned)

| Concern | Location |
|---|---|
| APEX app metadata (APEXlang) | `apex_app/scaff-app/` (re-export with `scripts/apex-export.ps1`) |
| PL/SQL packages | `db/packages/` |
| Views | `db/views/` |
| i18n messages | `db/i18n/` |
| Skills & agents | `.github/skills/`, `.github/agents/` |
| Workflow rules | `.github/instructions/` |

## Golden Workflow (APEX 26.1 + APEXlang)

> Always prefer this loop over direct dictionary writes.

```
1. apex export   →  apex_app/scaff-app/         (snapshot current state)
2. git add/commit                                (rollback point)
3. edit .apx / .sql files locally               (Copilot helps here)
4. apex validate                                (syntax check)
5. apex import                                  (deploy to APEX)
6. runtime check in browser                     (mobile viewport!)
7. git commit                                   (record the change)
```

Wrappers: `scripts/apex-export.ps1`, `scripts/apex-import.ps1`, `scripts/apex-validate.ps1`.

## Hard Rules

- **NEVER** `UPDATE apex_260100.wwv_flow_*` tables directly. Use APEXlang edit → import. The only exception is one-off SYS rescue, and only when the user explicitly asks.
- **NEVER** commit `apex/`, `oracle_oradata/`, `ords_config/`, `META-INF/`, `apex-latest.zip` — all excluded via `.gitignore`.
- **NEVER** put credentials in files. Dev password is `Welkom_APEX_2026!` — known and OK to reference in commands, not to store as secret.
- **ALWAYS** re-export after a Builder change so git stays in sync. Builder edits without re-export = lost history.
- **ALWAYS** use BEM `scaff-*` CSS class prefix for our custom UI (`scaff-menu`, `scaff-card`, `scaff-card--retour`, …).
- **ALWAYS** add user-visible text via APEX messages (NL + EN), referenced with `apex_lang.message('SCAFF.…')`. Never hardcode Dutch or English in PL/SQL or HTML.

## Known Pitfalls (Learned the Hard Way)

- SQLcl MCP server `databeest` is **broken** — returns empty output for every query. Use `docker exec -i apex_ords sql ...` instead.
- Region type conversion in dictionary needs `function_body_language='PLSQL'` for dynamic content, otherwise → `ORA-06592`. APEXlang avoids this entirely.
- "Hero" templates render `region_image` as a giant icon on the left. APEXlang shows you the property explicitly — clear it in the `.apx`.
- PowerShell here-strings: escape `$` as `` `$ `` to prevent expansion when piping into sqlplus/sql.

## Connection Recipes

```powershell
# As APP_DATA (app schema)
docker exec -i apex_db sqlplus -L -S "APP_DATA/Welkom_APEX_2026!@localhost:1521/FREEPDB1"

# As SYS (emergency only)
docker exec -i apex_db sqlplus -L -S "SYS/Welkom_APEX_2026!@localhost:1521/FREEPDB1 as sysdba"

# SQLcl 26.1.2 (for apex export/import/validate)
docker exec -i apex_ords sql -S APP_DATA/Welkom_APEX_2026!@apex_db:1521/FREEPDB1
```

## What Copilot Should Do by Default

- When asked to change a page → edit the `.apx` file under `apex_app/scaff-app/pages/`, then run `apex import`.
- When asked to add a label → add NL + EN to `apex_app/scaff-app/shared-components/messages.apx`, then `apex import`.
- When asked to create a new page → use `apex generate` or copy an existing `.apx` as template.
- Always offer to `git commit` after a successful import.
- See `.github/skills/` for detailed playbooks and `.github/agents/apex-vibe.agent.md` for the orchestrator.
