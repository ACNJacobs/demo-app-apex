---
name: apex-26-workflow
description: Core export → edit → validate → import loop for ANY Oracle APEX 26.1 application in this workspace, using APEXlang + SQLcl 26.1.2 inside Docker (apex_db + apex_ords). Use whenever the user wants to change ANY APEX page, region, item, button, list, LOV, breadcrumb, authentication, authorization, theme, or any other APEX metadata for any app. App-specific details (id, alias, schema, branding) come from the app's overlay skill.
---

# APEX 26.1 Workflow (generic, multi-app)

## When to invoke

User says any of:
- "verander de page / region / button / list / LOV / theme …"
- "voeg een page toe"
- "fix de layout"
- "export de app"
- "rollback / 2 stappen terug"
- "wat is er sinds gisteren veranderd in APEX?"
- ANY change to APEX metadata for ANY app in this workspace

## The Loop

```
1. apex export   →  apex_app/<alias>/    (snapshot current state)
2. git commit                              (rollback point)
3. edit .apx / .sql files                  (Copilot helps here)
4. apex validate                           (LF + syntax)
5. apex import                             (deploy to APEX)
6. browser smoke test (mobile viewport!)
7. git commit                              (record the change)
```

**NEVER skip validate. NEVER skip a commit before destructive edits.**

## Wrappers (parameterised — work for any app)

```powershell
pwsh scripts/apex-export.ps1   -AppId 100 -Alias scaff-app
pwsh scripts/apex-validate.ps1 -Alias scaff-app
pwsh scripts/apex-import.ps1   -Alias scaff-app

# defaults to AppId=100 / Alias=scaff-app for backward compat
pwsh scripts/apex-export.ps1
```

All wrappers run inside container `apex_ords` (SQLcl 26.1.2) and `docker cp` the results to `apex_app/<alias>/`.

## Looking up app metadata

If user says "edit app X" but doesn't give the id/alias:

```sql
-- via MCP sql_run on connection 'databeest'
select application_id, alias, application_name
  from apex_applications
 where workspace = 'APEX_DEV'
 order by application_id;
```

## File Map (template — same for every app)

```
apex_app/<alias>/
├── application.apx                ← global app settings (auth, name, alias)
├── page-groups.apx                ← page categorisation
├── deployments/default.json       ← target app id
├── pages/
│   ├── p00000-global-page.apx     ← global page 0 (runs on every page)
│   ├── p00001-home.apx            ← home page (entry point)
│   └── p0NNNN-<slug>.apx          ← one file per page, zero-padded id
├── shared-components/
│   ├── messages.apx               ← all NL/EN translations (one app prefix)
│   ├── authentications.apx
│   ├── authorizations.apx
│   ├── lists.apx
│   ├── lovs.apx
│   ├── static-files.apx
│   └── themes/universal-theme/theme.apx
└── workspace-components/          ← credentials, GenAI services (workspace-scope!)
```

## Rollback

```powershell
git log --oneline apex_app/<alias>/         # find the good commit
git checkout <sha> -- apex_app/<alias>/     # restore files
pwsh scripts/apex-import.ps1 -Alias <alias> # push to APEX
```

## Hard Rules

- ❌ NEVER `UPDATE apex_260100.wwv_flow_*` directly. Only exception: SYS rescue (e.g. ADMIN expiry), with explicit user request.
- ❌ NEVER edit in Builder + forget to re-export — git goes stale.
- ❌ NEVER commit `apex_app/<alias>/` after a Builder edit without first running `apex export`.
- ❌ NEVER use `apex export -exptype SQL` — we standardise on APEXlang.
- ✅ ALWAYS validate before import.
- ✅ ALWAYS LF line endings on `.apx` (export script auto-fixes; manual edits via `[IO.File]::WriteAllText` after `-replace "`r`n","`n"`).

## After import — verify

```sql
select page_id, page_alias
  from apex_application_pages
 where application_id = <id>
 order by page_id;
```

## Common Tasks → file map

| Task | Edit file |
|---|---|
| Change a label | `apex_app/<alias>/shared-components/messages.apx` (NL + EN) |
| Add new page | new file `pages/p0NNNN-<slug>.apx`, then `apex import` |
| Change auth | `application.apx` → `authentication.scheme` |
| Add list / LOV | `shared-components/lists.apx` or `lovs.apx` |
| Change theme attrs | `shared-components/themes/<theme>/theme.apx` |
| Change card layout | use the `apex-26-mobile-cards` skill |
| Add translations | use the `apex-26-i18n` skill |

## Authoritative Sources

- Blog: https://blogs.oracle.com/apex/post/apexlang-in-practice-export-edit-validate-and-import-oracle-apex-applications
- Oracle skills repo: https://github.com/oracle/skills/tree/main/apex
- SQLcl docs: https://docs.oracle.com/en/database/oracle/sql-developer-command-line/26.1/sqcug/apexlang.html
