# Altrad SCAFF APP — Copilot Instructions

> ⚠️ **ENVIRONMENT-SPECIFIC FILE — DO NOT COMMIT**
>
> This file contains connection details, container names, and local paths that differ per machine.
> **After cloning this repo, review and adapt this file to your local environment.**
> This file is listed in `.gitignore` to prevent accidental commits of local overrides.
> If you change the project structure or connection details, update this file locally only.

Project-wide rules. These apply to **every** Copilot Chat in this workspace.

## Project at a Glance

- **App**: SCAFF APP (id `100`, alias `SCAFF-APP`) — mobile-first APEX app for material/return/transfer requests.
- **APEX**: `26.1` (workspace `SECURE_AI_HUB` id `4396054143779997`, parsing schema `SAH`).
- **DB**: MaxApex_Live — Oracle 23ai Free, `secureaihub.maxapex.net:1521/XEPDB1`, schema `SAH` (parsing schema for APEX). Charset `AL32UTF8`.
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

- Region type conversion in dictionary needs `function_body_language='PLSQL'` for dynamic content, otherwise → `ORA-06592`. APEXlang avoids this entirely.
- "Hero" templates render `region_image` as a giant icon on the left. APEXlang shows you the property explicitly — clear it in the `.apx`.
- PowerShell here-strings: escape `$` as `` `$ `` to prevent expansion when piping into sqlplus/sql.

## Database Access — PREFER MCP

The Oracle SQL Developer VS Code extension exposes a working **SQLcl MCP server**. Use it as the default for ad-hoc queries.

### Active MCP connection (this environment)

| Name | User | Target | Status |
|---|---|---|---|
| `MaxApex_Live` | SAH | `secureaihub.maxapex.net:1521/XEPDB1` | ✅ **Primary** |

### Other saved connections (only if available)

| Name | User | Target | Note |
|---|---|---|---|
| `databeest` | APP_DATA | localhost:2521/freepdb1 | Only if local Docker is running |
| `apex_dev` | APP_DATA | localhost:2521/FREEPDB1 | Only if local Docker is running |
| `apex_sys` | system | localhost:2521/FREEPDB1 | Only if local Docker is running |

MCP tools available: `connections_list`, `connect`, `disconnect`, `sql_run`, `sqlcl_run`, `schema_information`.

### Fallback recipes

If MCP is unavailable, use locally installed SQLcl or sqlplus:
```powershell
# Connect to MaxApex_Live
sql -S SAH/<password>@secureaihub.maxapex.net:1521/XEPDB1
```

## What Copilot Should Do by Default

- When asked to change a page → edit the `.apx` file under `apex_app/scaff-app/pages/`, then run `apex import`.
- When asked to add a label → add NL + EN to `apex_app/scaff-app/shared-components/messages.apx`, then `apex import`.
- When asked to create a new page → use `apex generate` or copy an existing `.apx` as template.
- Always offer to `git commit` after a successful import.
- See `.github/skills/` for detailed playbooks and `.github/agents/apex-vibe.agent.md` for the orchestrator.

## Skills — Usage & Maintenance

### How to use skills
The `.github/skills/` directory contains domain-specific playbooks for Oracle APEX 26.1. **Always consult the relevant skill first** before improvising a solution.

| User asks for... | Use skill |
|---|---|
| Change button color / style / template | `apex-26-buttons` |
| Create or modify an Interactive Grid | `apex-26-interactive-grids` |
| Add a computation, validation, or formula | `apex-26-calculations` |
| Create a PL/SQL package, procedure, or view | `apex-26-plsql-packages` |
| Add or edit mobile card menus / dashboard tiles | `apex-26-mobile-cards` |
| Add or change translations (NL/EN) | `apex-26-i18n` |
| Export / edit / validate / import workflow | `apex-26-workflow` |
| Test the app / smoke test | `apex-26-testing` |
| Debug runtime issues | `apex-debugging-systematic` |
| Safe destructive operations checklist | `apex-destructive-ops-safe` |
| REST API integrations | `apex-rest-integrations-secure` |
| SQLcl MCP usage | `apex-mcp-sqlcl` |
| Bootstrap a brand-new APEX app | `apex-26-bootstrap-new-app` |
| Generic patterns, gotchas, parser quirks | `apex-26-patterns` |
| SCAFF APP specifics (id 100, alias scaff-app) | `scaff-overlay` |

### How to maintain skills
When working on a task, if you learn a new pattern, gotcha, or best practice that is not yet covered in the relevant skill:

1. **Update the skill** — append the new knowledge to the appropriate `.github/skills/<skill-name>/SKILL.md` file.
2. **Keep it concise** — bullet points, short examples, no prose.
3. **Version-specific** — always mention "Oracle APEX 26.1" in the context so future searches are accurate.
4. **Cross-reference** — if a pattern touches multiple skills (e.g. "button styling in IG toolbar"), add a short note in both skills pointing to each other.
5. **Do NOT commit skills lightly** — skills are shared across environments; only commit when the pattern is verified and reusable.

### When a skill does not exist
If the user's request does not match any existing skill:
1. Search the internet for "Oracle APEX 26.1 <topic>" to find current best practices.
2. Create a new skill file `.github/skills/apex-26-<topic>/SKILL.md` with the findings.
3. Add the new skill to the table above in this file.
4. Add a cross-reference in `apex-26-patterns` if it is a generic pattern.
