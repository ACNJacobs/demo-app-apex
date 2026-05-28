---
name: apex-26-bootstrap-new-app
description: End-to-end recipe to bootstrap a NEW Oracle APEX 26.1 application in this workspace — from "I want to build X" to a running app with mobile-card home, NL+EN i18n, parameterised export/import scripts, and a thin overlay skill. Use whenever the user wants to create a new APEX app (not edit an existing one).
---

# Bootstrap a new APEX 26.1 app

This skill is the ONE place that tells you how to add a brand-new app alongside an existing one (like SCAFF). Follow the 10 steps in order — every other skill (`apex-26-workflow`, `apex-26-mobile-cards`, `apex-26-i18n`, `apex-26-patterns`) is reusable as-is.

## Inputs needed from the user

Ask once:

| Question | Example | Used as |
|---|---|---|
| App name | `INSPECT APP` | `application.apx → name` |
| App alias | `INSPECT-APP` | Friendly URL segment, file folder |
| App id | `200` | Numeric id (not 100, not 4000-4999) |
| BEM/prefix | `inspect` | CSS prefix, package names, message keys |
| Primary colour | `#0066CC` | Card background, theme |
| Dark variant | `#004A99` | Hover/active states |
| Soft accent | `#E6F0F9` | Light backgrounds |
| Default language | `nl` | `globalization.primaryLanguage` |

## 10 steps

### 1. Create skeleton in APEX Builder

Open <http://localhost:8080/ords/f?p=4550>, login APEX_DEV / ADMIN / Anisa24v#.

App Builder → Create → New Application:
- Name = `<App name>`
- Application ID = `<id>` (Advanced section)
- Alias = `<ALIAS>`
- Schema = `APP_DATA`
- Theme = Universal Theme, minimal features

### 2. Export to repo

```powershell
pwsh scripts/apex-export.ps1 -AppId <id> -Alias <alias>
```

Creates `apex_app/<alias>/` with LF line endings, OLLAMA-patched.

### 3. Commit baseline

```powershell
git add apex_app/<alias>/
git commit -m "feat(<alias>): bootstrap baseline APEXlang export"
```

### 4. Create overlay skill

`.github/skills/<alias>-overlay/SKILL.md` — thin file mapping the generic skills to this app:

```markdown
---
name: <alias>-overlay
description: <App name> specifics — overlay for the generic apex-26-* skills. App id <id>, alias <alias>, BEM prefix <prefix>-*, palette <primary>/<dark>/<soft>, message prefix <APP>.*. Use whenever the user works on <App name>.
---

# <App name> overlay

| Generic placeholder | This app |
|---|---|
| `<id>` | `<id>` |
| `<alias>` | `<alias>` |
| `<prefix>` / `<PREFIX>` | `<prefix>` / `<PREFIX>` |
| `<APP>` (message prefix) | `<APP>` |
| `<primary>` | `<primary>` |
| `<dark>` | `<dark>` |
| `<soft>` | `<soft>` |

## Wrappers
pwsh scripts/apex-export.ps1   -AppId <id> -Alias <alias>
pwsh scripts/apex-validate.ps1 -Alias <alias>
pwsh scripts/apex-import.ps1   -Alias <alias>

## Files
- `db/views/v_<prefix>_menu.sql`
- `db/packages/pkg_<prefix>_ui.sql`
- `db/packages/hd_<prefix>_ui_pkg.sql`
- `db/i18n/messages_<prefix>_nl.sql`
- `db/i18n/messages_<prefix>_en.sql`
- `apex_app/<alias>/`

## URLs
- Friendly: http://localhost:8080/ords/r/apex_dev/<alias>/home
- Classic:  http://localhost:8080/ords/f?p=<id>:1
```

### 5. Scaffold the DB triplet (view + UI pkg + CSS helper)

Use the templates in `apex-26-mobile-cards` SKILL. Substitute `<prefix>`, `<APP>`, `<primary>`. Create:

- `db/views/v_<prefix>_menu.sql` — empty UNION ALL skeleton (one dummy row for now)
- `db/packages/pkg_<prefix>_ui.sql` — `get_menu` function
- `db/packages/hd_<prefix>_ui_pkg.sql` — `get_css` function with palette

Compile via docker exec sqlplus (see `apex-mcp-sqlcl` skill fallback).

### 6. Seed initial messages

`db/i18n/messages_<prefix>_nl.sql` and `_en.sql` — at least the home title and one menu card:

```sql
exec HD_I18N_INSTALL.upsert_message('<APP>.MENU.HOME.TITLE','Home','nl');
exec HD_I18N_INSTALL.upsert_message('<APP>.MENU.HOME.SUBTITLE','Welkom','nl');
```

Pair in `_en.sql`. Run both via APP_DATA connection.

### 7. Wire the home page

Edit `apex_app/<alias>/pages/p00001-home.apx`: replace default region with:

```
region home (
    template: @/blank-with-attributes-no-grid
    type: dynamicContent
    source { plsqlFunctionBody: return PKG_<PREFIX>_UI.get_menu; }
)
```

LF-normalise the file:

```powershell
$p='apex_app/<alias>/pages/p00001-home.apx'
$c=[IO.File]::ReadAllText($p) -replace "`r`n","`n"
[IO.File]::WriteAllText($p,$c)
```

### 8. Validate + import

```powershell
pwsh scripts/apex-validate.ps1 -Alias <alias>
pwsh scripts/apex-import.ps1   -Alias <alias>
```

### 9. Smoke test

Open <http://localhost:8080/ords/r/apex_dev/<alias>/home> — should show one card.

### 10. Commit + push

```powershell
git add -A
git commit -m "feat(<alias>): mobile home + i18n + overlay skill"
git push
```

## What you do NOT need to write per app

Because the generic skills (`apex-26-workflow`, `apex-26-mobile-cards`, `apex-26-i18n`, `apex-26-patterns`, `apex-mcp-sqlcl`) cover the actual how-to, your per-app overlay is **~30 lines of placeholder mapping**, nothing more.

## Subsequent edits to the new app

Use the generic skills directly. Any prompt like "add a card to INSPECT for X" will:

1. Match `apex-26-mobile-cards` (pattern)
2. Pick up `inspect-overlay` (values)
3. Apply via `apex-26-workflow` (loop)

No further bootstrapping needed.
