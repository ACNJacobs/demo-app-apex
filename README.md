# Altrad SCAFF APP — Team Onboarding

Welcome. This workspace is set up for **AI-assisted Oracle APEX 26.1 development** using **APEXlang** (the new file-based representation introduced in May 2026).

## Quick Start

```powershell
# 1. Start the stack
docker compose up -d

# 2. Snapshot the APEX app to disk
pwsh scripts/apex-export.ps1

# 3. Open VS Code in this folder and let Copilot guide you
code .
```

## What's Set Up

| Layer | Where | Purpose |
|---|---|---|
| Stack | `docker-compose.yml` | Oracle 23ai Free + ORDS + APEX 26.1 |
| APEX source (versioned) | `apex_app/scaff-app/` | APEXlang `.apx` files |
| PL/SQL source | `db/packages/`, `db/views/`, `db/i18n/` | Versioned DB code |
| Wrappers | `scripts/apex-*.ps1` | Export / Validate / Import |
| Copilot rules | `.github/copilot-instructions.md` | Project-wide conventions |
| Skills | `.github/skills/` | Domain playbooks Copilot reads on demand |
| Agent | `.github/agents/apex-vibe.agent.md` | Specialist agent for this app |
| Reference skills (oracle/skills) | `oracle-apex-ai-skills/` | Upstream Oracle skill library (APEX 24.2) |

## The Golden Loop

```
apex-export.ps1   →   edit .apx / .sql   →   apex-validate.ps1   →   apex-import.ps1   →   git commit
```

**Never** `UPDATE apex_260100.wwv_flow_*` directly. That's how we lost the cards last week.

## Available Copilot Skills

| Skill | When |
|---|---|
| `apexlang-workflow` | Any APEX page/region/item/button/list change |
| `scaff-mobile` | Mobile cards, Altrad palette, scaff-* BEM |
| `scaff-i18n` | NL/EN translations, messages |

To invoke the dedicated agent: `@workspace use the apex-vibe agent for this task`.

## Convention Cheat Sheet

- **Branding**: red `#E2001A`, dark `#B30015`, soft `#FCE6E9`
- **CSS prefix**: `scaff-` (BEM: `scaff-card--retour`, `scaff-card__title`)
- **Labels**: always via `apex_lang.message('SCAFF.…')` in **both** NL + EN
- **Packages**: `PKG_SCAFF_*` / `HD_*_PKG`, `CREATE OR REPLACE`, return `CLOB`
- **App id**: `100` (alias `SCAFF-APP`)
- **Workspace**: `APEX_DEV` (id `5800403880636291`), schema `APP_DATA`

## Connection Recipes

```powershell
# APP_DATA (everyday)
docker exec -i apex_db sqlplus -L -S "APP_DATA/Welkom_APEX_2026!@localhost:1521/FREEPDB1"

# SQLcl 26.1.2 (for apex commands)
docker exec -it apex_ords sql APP_DATA/Welkom_APEX_2026!@apex_db:1521/FREEPDB1
```

## Rollback

```powershell
git log --oneline apex_app/                # find good commit
git checkout <sha> -- apex_app/scaff-app/  # restore
pwsh scripts/apex-import.ps1               # push to APEX
```

## Read More

- [APEXlang in Practice (Oracle blog)](https://blogs.oracle.com/apex/post/apexlang-in-practice-export-edit-validate-and-import-oracle-apex-applications)
- [APEXLang Part 1 — Getting Started (askMax)](https://askmax.blog/2026/05/25/apexlang-part-1-getting-started/)
- [Oracle Skills repo](https://github.com/oracle/skills/tree/main/apex)
- [APEX AI Application Generator](https://www.oracle.com/apex/ai-application-generator/)
