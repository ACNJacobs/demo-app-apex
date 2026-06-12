---
name: apex-26-bootstrap-new-app
description: End-to-end recipe to bootstrap a NEW Oracle APEX 26.1 application in this workspace using the starter app template. Use whenever the user wants to create a new APEX app (not edit an existing one).
---

# Bootstrap a new APEX 26.1 app

## The Working Workflow (2026-06-12)

We now have a **code-first** approach using a stripped starter app template:

```
1. Run Python import script with your app parameters
2. App is created in APEX automatically
3. Export via SQLcl: apex export -applicationid <id> -exptype APEXLANG
4. Edit exported files in VS Code (Copilot helps here)
5. Import back via SQLcl: apex import -input <dir>
6. Commit to GitHub
```

## Prerequisites

| Check | How |
|---|---|
| Python + oracledb | `pip install oracledb` |
| Starter template | `templates/starter-app.sql` exists |
| Database connection | `MaxApex_Live` (SAH@secureaihub.maxapex.net:1521/XEPDB1) |
| APEX Builder access | Environment-specific URL (for verification) |
| GitHub access | Token or CLI for repo creation |

## Step 1: Create app via Python script (RECOMMENDED)

The `scripts/import_starter_app.py` script **generates** and imports a minimal runnable app in seconds:

```powershell
# Create a new app with ID 200
python scripts/import_starter_app.py --id 200 --name "MY APP" --alias "MY-APP"

# Create another app with ID 300
python scripts/import_starter_app.py --id 300 --name "INSPECT APP" --alias "INSPECT-APP"
```

### What the script does:
1. Reads `templates/starter-app.sql`
2. Remaps all hardcoded IDs to unique values (avoids conflicts with existing apps)
3. Replaces substitution variables (`&APP_ID.`, `&APP_NAME.`, etc.)
4. Merges everything into **one PL/SQL block** (preserves `wwv_flow_imp` package state)
5. Executes against the database
6. Verifies the app was created

### Output:
```
✅ VERIFIED: App 200 - MY APP (alias: MY-APP)
🎉 App 'MY APP' (ID 200) is ready!
   URL: https://secureaihub.maxapex.net/ords/f?p=200:1
```

## Alternative: Create app in APEX Builder

If the Python script fails or you prefer the UI:

1. Open APEX Builder (environment-specific URL)
2. App Builder → Create → New Application
3. Set:
   - Name = `<App name>`
   - Application ID = `<id>` (Advanced section)
   - Alias = `<ALIAS>`
   - Schema = `SAH`
   - Theme = Universal Theme
4. Create minimal app (1 blank page is enough)

## Step 2: Export via SQLcl

```sql
-- Connect via SQLcl
sql -S SAH/<password>@secureaihub.maxapex.net:1521/XEPDB1

-- Export as APEXlang
apex export -applicationid <id> -exptype APEXLANG -dir /tmp/export_<alias>

-- Or export as SQL (legacy)
apex export -applicationid <id> -exptype SQL -dir /tmp/export_<alias>
```

## Step 3: Copy to repo

```powershell
# Copy exported files to repo
Copy-Item -Recurse /tmp/export_<alias>/* apex_app/<alias>/

# LF-normalise
Get-ChildItem apex_app/<alias> -Recurse -Filter *.apx | ForEach-Object {
    $c = [IO.File]::ReadAllText($_.FullName) -replace "`r`n", "`n"
    [IO.File]::WriteAllText($_.FullName, $c)
}
```

## Step 4: Create overlay skill

`.github/skills/<alias>-overlay/SKILL.md`:

```markdown
---
name: <alias>-overlay
description: <App name> specifics — overlay for generic apex-26-* skills.
---

# <App name> overlay

| Generic | This app |
|---|---|
| `<id>` | `<id>` |
| `<alias>` | `<alias>` |
| `<prefix>` | `<prefix>` |
| `<APP>` | `<APP>` |
| `<primary>` | `<primary>` |

## Wrappers
pwsh scripts/apex-export.ps1 -AppId <id> -Alias <alias>
pwsh scripts/apex-validate.ps1 -Alias <alias>
pwsh scripts/apex-import.ps1 -Alias <alias>
```

## Step 5: Create GitHub repo

```powershell
# Via GitHub CLI
gh repo create <repo-name> --public --description "Oracle APEX 26.1 app: <App name>"

# Or via API
curl -X POST -H "Authorization: Bearer <token>" \
  -H "Accept: application/vnd.github+json" \
  https://api.github.com/user/repos \
  -d '{"name":"<repo-name>","description":"APEX 26.1 app","private":false}'
```

## Step 6: Commit and push

```powershell
git add apex_app/<alias>/ .github/skills/<alias>-overlay/
git commit -m "feat(<alias>): bootstrap new APEX app"
git push -u origin main
```

## How the starter template works

The template (`templates/starter-app.sql`) is a stripped version of SCAFF APP:

| Component | Included |
|---|---|
| App definition | ✅ |
| Global page (page 0) | ✅ |
| Home page (page 1) | ✅ |
| Login page (page 9999) | ✅ |
| Universal Theme 42 | ✅ |
| Navigation lists | ✅ |
| Authentication scheme | ✅ |
| All business pages | ❌ (stripped) |
| All LOVs | ❌ (stripped) |
| All messages | ❌ (stripped) |
| Custom CSS/JS | ❌ (stripped) |

## Why this works (technical)

Oracle APEX stores apps in ~50+ internal dictionary tables with:
- Auto-generated numeric IDs (not sequential)
- Cross-table foreign key relationships
- Theme/template dependencies
- Security scheme bindings

The `wwv_flow_imp` package only works within an **official export-import session** where:
1. `import_begin()` sets internal package variables (`g_flow_id`, `g_security_group_id`)
2. All subsequent calls use those variables
3. `import_end()` commits the transaction

**Critical**: The entire import must execute in **one database call** because:
- Python `oracledb` thin mode resets package state between `execute()` calls
- SQLcl preserves state between statements in a session
- The Python script works around this by merging all PL/SQL into one block

## Troubleshooting

| Problem | Fix |
|---|---|
| "unique constraint violated" | IDs already exist — the Python script auto-remaps IDs |
| "Package variable g_security_group_id must be set" | Import split across multiple DB calls — use the Python script |
| "integrity constraint violated - parent key not found" | Missing global page — template includes it |
| Import script fails | Check `pip install oracledb` and database connectivity |
| Can't connect to Builder | Check environment-specific URL |
| GitHub push fails | `git remote add origin <url>` |
