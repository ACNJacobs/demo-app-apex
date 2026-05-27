---
name: apexlang-workflow
description: Export → edit → validate → import loop for Oracle APEX 26.1 using APEXlang and SQLcl 26.1.2. Use whenever the user wants to change ANY APEX page, region, item, button, list, LOV, breadcrumb, authentication, authorization, theme, or any other APEX metadata. Replaces direct dictionary updates and Builder-only workflows.
---

# APEXlang Workflow Skill

## When to invoke

User says any of:
- "verander de page / region / button …"
- "voeg een page toe"
- "fix de layout"
- "export de app"
- "rollback / 2 stappen terug"
- "wat is er sinds gisteren veranderd in APEX?"
- anything that previously would have meant clicking in Page Designer

## The Loop

```
┌──────────┐   1.export   ┌────────────┐   2.commit   ┌───────────┐
│  APEX    │ ───────────▶ │ apex_app/  │ ───────────▶ │   git     │
│ Builder  │              │ *.apx      │              │ snapshot  │
└──────────┘              └─────┬──────┘              └───────────┘
     ▲                          │ 3.edit                     │
     │                          ▼                            │
     │ 5.import          ┌─────────────┐                     │
     └────────────────── │ Copilot +   │  4.validate         │
                        │ developer    │  ──────┐            │
                        └─────────────┘        ▼            │
                                          ┌──────────┐      │
                                          │ apex     │      │
                                          │ validate │      │
                                          └──────────┘      │
                              7.commit                       │
                              ─────────────────────────────▶│
```

## Commands (use the wrappers)

| Step | PowerShell | Underlying SQLcl |
|---|---|---|
| Export app 100 | `pwsh scripts/apex-export.ps1` | `apex export -applicationid 100 -dir /tmp/apex_app -exptype APEXLANG` |
| Validate | `pwsh scripts/apex-validate.ps1` | `apex validate -input /tmp/apex_app/scaff-app` |
| Import | `pwsh scripts/apex-import.ps1` | `apex import -input /tmp/apex_app/scaff-app` |
| Generate new app | `pwsh scripts/apex-generate.ps1 -alias DEMO -name 'Demo App'` | `apex generate -workspaceid … -alias DEMO -name 'Demo App' -dir /tmp/apex_new` |

All wrappers run inside container `apex_ords` (SQLcl 26.1.2) and `docker cp` results back to `d:\oracle apex\apex_app\`.

## Rollback ("ga 2 stappen terug")

```powershell
git log --oneline apex_app/                # find the good commit
git checkout <sha> -- apex_app/scaff-app/  # restore files
pwsh scripts/apex-import.ps1               # push to APEX
```

## File Map (for app 100)

```
apex_app/scaff-app/
├── application.apx                ← global app settings (auth, name, alias)
├── page-groups.apx                ← page categorisation
├── deployments/default.json       ← target app id
├── pages/
│   ├── p00000-global-page.apx     ← global page 0 (runs on every page)
│   ├── p00001-home.apx            ← the mobile menu (our 3 cards)
│   ├── p00002-…apx                ← tickets overzicht
│   └── p09999-login.apx           ← login page
├── shared-components/
│   ├── messages.apx               ← NL/EN translations (SCAFF.*)
│   ├── authentications.apx
│   ├── authorizations.apx
│   ├── lists.apx
│   ├── lovs.apx
│   ├── static-files.apx
│   ├── static-files/icons/        ← app-icon PNGs
│   └── themes/universal-theme/theme.apx
└── workspace-components/          ← credentials, GenAI services
```

## Common Tasks Mapped to Files

| Task | Edit file |
|---|---|
| Change card label "Materiaal Aanvraag" | `shared-components/messages.apx` → `SCAFF.MENU.MATERIAAL.TITLE` (both NL + EN) |
| Add a 4th card | `db/views/v_mobile_menu.sql` (add row) + import |
| Change card target page | `db/packages/pkg_scaff_ui.sql` (anchor href) |
| Add new APEX page | new file `pages/p00010-….apx`, then `apex import` |
| Change Primary Language to NL | `application.apx` → `globalization { primaryLanguage: nl }` |
| Remove "New" placeholder region | edit the relevant `pages/pNNNNN.apx`, delete the `region (…)` block |

## Validation Errors

`apex validate` prints `file:line` for each issue. Copilot should:
1. Run validate before import — never push broken APEXlang.
2. If validate fails: open the file at the reported line, fix, re-validate.
3. Only invoke `apex import` after a clean validate.

## Anti-Patterns (DON'T)

- ❌ `UPDATE apex_260100.wwv_flow_page_plugs SET …` — bypasses git, bypasses validation, can leave orphan attributes.
- ❌ Editing the Builder + forgetting to re-export — git history goes stale.
- ❌ Committing `apex_app/` after a Builder edit without first running `apex export`.
- ❌ Using `apex export -exptype SQL` (legacy) — we standardize on APEXlang.

## Authoritative Sources

- Blog: https://blogs.oracle.com/apex/post/apexlang-in-practice-export-edit-validate-and-import-oracle-apex-applications
- AskMax part 1: https://askmax.blog/2026/05/25/apexlang-part-1-getting-started/
- Oracle skills repo: https://github.com/oracle/skills/tree/main/apex
- SQLcl docs: https://docs.oracle.com/en/database/oracle/sql-developer-command-line/26.1/sqcug/apexlang.html
