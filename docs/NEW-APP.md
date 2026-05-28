# Nieuwe APEX-app aanmaken in deze workspace

Praktische handleiding voor het maken van een **tweede** APEX-app naast `SCAFF APP` (id 100). De infrastructuur (Docker, ORDS, SQLcl, APEX 26.1, MCP, scripts) hergebruiken we 1-op-1.

> **Voorwaarde**: de containers `apex_db` en `apex_ords` draaien, APEX_DEV workspace bestaat, schema `APP_DATA` is parsing schema. Zie hoofd-[README.md](../README.md).

---

## 0. Beslis vóór je begint

| Vraag | Voorbeeld | Waarom |
|---|---|---|
| App-naam + alias | `INSPECT APP` / `INSPECT-APP` | Alias = URL-segment in `/ords/r/apex_dev/<alias>/…` |
| App-id | `200` | Niet-100, niet 4000-4999 (APEX intern) |
| Parsing schema | `APP_DATA` (her-gebruik) of nieuw schema | Apart schema = harde isolatie van tabellen |
| Eigen tabellen? | Ja → eigen schema | Anders mix je tabellen met SCAFF |
| Authenticatie | APEX accounts (workspace users) | Zelfde als SCAFF |
| Talen | NL + EN | Zelfde messages-pattern |
| Branding | Altrad rood of anders | Zelfde palette → her-gebruik CSS |

---

## 1. App maken in APEX Builder (éénmalig)

We gebruiken **Builder** om de skeleton aan te maken, daarna pakt APEXlang het over.

1. Open Builder: <http://localhost:8080/ords/f?p=4550>
2. Login workspace **APEX_DEV** / user **ADMIN** / pwd **Anisa24v#**
3. **App Builder → Create → New Application**
4. Vul in:
   - **Name**: `INSPECT APP` (vrij)
   - **Application ID**: `200` (handmatig invullen via *Advanced*)
   - **Alias**: `INSPECT-APP`
   - **Schema**: `APP_DATA` (of nieuw schema)
   - **Theme**: Universal Theme (zoals SCAFF)
   - **Features**: minimaal, voeg later toe via APEXlang
5. Klik **Create Application**.

> ⚠️ Let op: `account_expiry` van ADMIN loopt elk jaar af. Als login faalt zonder reden: zie [gotchas in repo-memory](../.github/copilot-instructions.md).

---

## 2. App exporteren naar de repo

We pakken het exact als SCAFF aan: APEXlang-export onder `apex_app/<alias-lowercase>/`.

```powershell
# kopie van apex-export.ps1 maken voor de nieuwe app
Copy-Item scripts/apex-export.ps1 scripts/inspect-export.ps1
```

Open [scripts/inspect-export.ps1](../scripts/inspect-export.ps1) en pas alleen aan:

```powershell
param(
    [int]$AppId = 200,                  # was 100
    ...
    [string]$LocalDir = (Join-Path $PSScriptRoot "..\apex_app")
)
```

Doe hetzelfde voor `apex-import.ps1` → `inspect-import.ps1` en pas `$LocalDir` aan naar `..\apex_app\inspect-app`.

Run de export:

```powershell
pwsh scripts/inspect-export.ps1
```

Resultaat: `apex_app/inspect-app/` met `application.apx`, `pages/`, `shared-components/`, enz. — LF-normalised, provider-patched.

---

## 3. Workflow voor wijzigingen (identiek aan SCAFF)

```text
1. pwsh scripts/inspect-export.ps1          (snapshot huidige state in APEX)
2. git add/commit                           (rollback point)
3. edit .apx files lokaal                   (Copilot helpt)
4. pwsh scripts/apex-validate.ps1           (LF + syntax check — werkt voor elke app)
5. pwsh scripts/inspect-import.ps1          (deploy naar APEX)
6. test in browser
7. git commit                               (lock-in)
```

> `apex-validate.ps1` valideert **alle** `.apx` onder `apex_app/`. Geen wijziging nodig.

---

## 4. Conventies die je MOET volgen

Voor deze repo zijn er drie harde regels (zie [.github/copilot-instructions.md](../.github/copilot-instructions.md)):

1. **Nooit direct in `wwv_flow_*` schrijven** → altijd APEXlang edit → import.
2. **Alle user-zichtbare tekst via `apex_lang.message('<APP>.<DOMAIN>.<SUBJECT>.<ROLE>')`**, NL + EN gepaard. Voor INSPECT bv. prefix `INSPECT.MENU.…`, `INSPECT.PAGE.…`.
3. **BEM CSS prefix per app** — bv. `inspect-*` voor INSPECT, NIET `scaff-*` her-gebruiken (anders raakt branding gemixed).

---

## 5. PL/SQL backing (optioneel)

Volg het SCAFF-pattern: aparte UI-package per app.

```
db/packages/pkg_inspect_ui.sql        ← CREATE OR REPLACE PACKAGE PKG_INSPECT_UI
db/packages/hd_inspect_ui_pkg.sql     ← CSS helper (eigen palette/branding)
db/views/v_inspect_menu.sql           ← driver view voor home menu
db/i18n/messages_inspect_nl.sql       ← NL messages via HD_I18N_INSTALL
db/i18n/messages_inspect_en.sql       ← EN messages
```

Voeg toe aan installer (`build_helpdesk.sql` of nieuwe `build_inspect.sql`):

```sql
prompt === INSPECT views ===
@@db/views/v_inspect_menu.sql

prompt === INSPECT i18n ===
@@db/i18n/messages_inspect_nl.sql
@@db/i18n/messages_inspect_en.sql
exec HD_I18N_INSTALL.seed_inspect;

prompt === INSPECT UI packages ===
@@db/packages/hd_inspect_ui_pkg.sql
@@db/packages/pkg_inspect_ui.sql
```

---

## 6. Eerste pagina (mobile-first card menu zoals SCAFF)

Reuse-pad: kopieer het pattern uit [.github/skills/scaff-mobile/SKILL.md](../.github/skills/scaff-mobile/SKILL.md). Kernpunten:

- Home (page 1) = single `dynamicContent` region met `plsqlFunctionBody: return PKG_INSPECT_UI.get_menu;`
- `V_INSPECT_MENU` levert rijen (`card_id`, `display_sequence`, `card_title_key`, `card_icon`, `card_link`, `card_class`).
- In PL/SQL altijd `&APP_ID.` / `&APP_SESSION.` / `&DEBUG.` substitueren VOOR `apex_util.prepare_url` (zie [.github/instructions/plsql.instructions.md](../.github/instructions/plsql.instructions.md)).
- Card-link patroon: `'f?p=&APP_ID.:10:&APP_SESSION.::&DEBUG.:::'`.

---

## 7. URL's voor de nieuwe app

| Type | URL |
|---|---|
| Friendly | <http://localhost:8080/ords/r/apex_dev/inspect-app/home> |
| Classic | <http://localhost:8080/ords/f?p=200:1> |
| Builder | <http://localhost:8080/ords/f?p=4550> → App 200 |

> Workspace-segment `apex_dev/` in friendly URL is **verplicht** — anders krijg je "Application not found".

---

## 8. Optioneel: één commit, één PR

```powershell
git checkout -b feat/inspect-app-bootstrap
# … doe stappen 1-6 …
git add -A
git commit -m "feat(inspect): bootstrap INSPECT APP (id 200, alias inspect-app)"
git push -u origin feat/inspect-app-bootstrap
gh pr create --fill
```

---

## 9. Checklist vóór merge

- [ ] App geëxporteerd onder `apex_app/<alias>/` met LF line endings
- [ ] `pwsh scripts/apex-validate.ps1` exit 0
- [ ] Eigen BEM-prefix CSS (geen `scaff-*` her-gebruik)
- [ ] Alle user-zichtbare strings via `apex_lang.message(...)` met NL + EN
- [ ] Eigen `pkg_<app>_ui` / `v_<app>_menu` / `messages_<app>_*` toegevoegd
- [ ] `build_*.sql` installer geüpdatet of nieuwe gemaakt
- [ ] Friendly URL handmatig getest
- [ ] `cookies.txt` of andere sessie-artefacten NIET gecommit (zie [.gitignore](../.gitignore))

---

## Veelvoorkomende fouten (geleerd in SCAFF)

| Symptoom | Oorzaak | Fix |
|---|---|---|
| "Application not found" bij card-klik | `&APP_ID.` niet gesubstitueerd in dynamicContent CLOB | `replace(l_link,'&'\|\|'APP_ID.', to_char(apex_application.g_flow_id))` |
| `MISSING_REQUIRED_PROPERTY` op alles | CRLF line endings in `.apx` | `[IO.File]::ReadAllText($p) -replace "`r`n","`n"` |
| MCP `sql_run` returns `(empty)` | Vorige `sqlcl_run` met `/` heeft sessie bevroren | disconnect + reconnect, of docker exec sqlplus |
| "Invalid Login Credentials" voor ADMIN zonder reden | `account_expiry` verlopen | SYS rescue update (zie copilot-instructions) |
| Page tab toont `MENU.X.TITLE.` letterlijk | APEX parseert eerste `.` als terminator in `&MSG.` syntax | Cosmetisch; voorlopig accepteren |
| `classicReport` valideert niet | APEXlang strikt | Gebruik `dynamicContent` + PL/SQL CLOB pattern |
