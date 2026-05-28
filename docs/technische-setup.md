# Onze APEX 26.1 Vibe-Coding Setup

Technische beschrijving van het volledige platform dat we gebruiken om Oracle APEX-applicaties te bouwen met AI-ondersteuning. Geschreven voor ontwikkelaars en architecten die willen begrijpen wat er onder de motorkap zit — en wat er nog moet komen.

---

## 1. Architectuur in één oogopslag

```
┌─────────────────────────────────────────────────────────────────┐
│  VS Code  +  GitHub Copilot                                     │
│  ├─ copilot-instructions.md          (project-wide regels)      │
│  ├─ .github/instructions/*.md        (per-file regels)          │
│  ├─ .github/skills/*/SKILL.md        (herbruikbare playbooks)   │
│  └─ .github/agents/apex-vibe.agent.md (orkestrator)             │
└──────────────────────────────┬──────────────────────────────────┘
                               │  tools: file edit, terminal,
                               │         SQLcl MCP, browser
                               ▼
┌─────────────────────────────────────────────────────────────────┐
│  Git repo  (single source of truth)                             │
│  ├─ apex_app/<app>/        .apx APEXlang bestanden              │
│  ├─ db/packages/           PL/SQL packages                      │
│  ├─ db/views/              Views (driver-views voor UI)         │
│  ├─ db/i18n/               messages_nl.sql / messages_en.sql    │
│  └─ scripts/               apex-export/import/validate.ps1      │
└──────────────────────────────┬──────────────────────────────────┘
                               │  export ↔ import via SQLcl 26.1
                               ▼
┌─────────────────────────────────────────────────────────────────┐
│  Docker stack  (docker-compose.yml)                             │
│  ├─ apex_db    Oracle 23ai Free + APEX 26.1   (port 2521)       │
│  └─ apex_ords  ORDS + SQLcl 26.1.2            (port 8080)       │
└─────────────────────────────────────────────────────────────────┘
```

---

## 1b. Waarom APEX 26.1?

APEX 26.1 is de **enabler** van deze hele opzet, niet zomaar de nieuwste versie. Het verschil zit in **APEXlang**: vanaf 26.1 exporteert SQLcl de app-metadata als leesbare `.apx`-bestanden (één per page), in plaats van één monolitisch `f100.sql` van 50.000+ regels `wwv_flow_api`-calls. Daardoor zijn pages voor het eerst diff-baar, review-baar en AI-bewerkbaar. Zonder 26.1 zou Copilot alleen PL/SQL, CSS en JS kunnen aanraken — alle page-wijzigingen zouden handmatig in de Builder moeten.

| Capability | APEX ≤ 23.x | APEX 26.1 |
|---|---|---|
| Docker dev-stack | ✅ | ✅ |
| Git voor PL/SQL, views, CSS | ✅ | ✅ |
| i18n via `apex_lang.message` | ✅ | ✅ |
| AI-editing van packages/views | ✅ | ✅ |
| **AI-editing van APEX pages** | ❌ (monoliet) | ✅ (`.apx`) |
| **Diff-baar op page-niveau** | ❌ | ✅ |
| **`apex validate` vóór import** | ❌ | ✅ |
| **Page-level granulaire export** | ❌ | ✅ |

Met oudere versies hadden we ~30% van deze waarde kunnen realiseren (de DB-laag). De vibe-coding loop voor APEX-pages staat of valt met 26.1.

---

## 1c. Waarom heeft niet iedereen dit al?

Goede vraag — en eerlijk antwoord: deze opzet bestaat publiek nergens in deze complete vorm (gecheckt 28 mei 2026). Dat heeft drie heel concrete redenen.

### Reden 1 — APEX 26.1 is twee weken oud

APEX 26.1 is **GA sinds 14 mei 2026**. APEXlang (het `.apx`-formaat dat de hele AI-edit-loop mogelijk maakt) bestaat dus letterlijk twee weken. De typische APEX-developer draait nog 23.2 of 24.2 in productie en heeft 26.1 nog niet eens lokaal geïnstalleerd. De publieke kennis op internet (StackOverflow, blogs, GitHub) is bijna volledig pre-APEXlang.

### Reden 2 — De zeldzame kruising van drie werelden

Om dit te bouwen moet je tegelijk thuis zijn in drie disciplines die zelden in één persoon samenkomen:

| Wereld | Wat je nodig hebt | Hoe vaak zie je dit |
|---|---|---|
| **Oracle APEX dev** | PL/SQL, dictionary, APEX workflow, SQLcl | Veel — maar typisch "Builder-only" werkers, geen git-native |
| **DevOps / containers** | Docker, volumes, networking, persistent state | Veel — maar zelden in de Oracle/APEX-hoek |
| **AI tooling 2026** | Copilot instructions, skills, agents, MCP, applyTo-patterns | Weinig — pas sinds Q1 2026 echt mainstream |

De Venn-doorsnede van *"kan APEX vibe-coden + Docker draaien + Copilot skills configureren"* is anno mei 2026 nog erg klein. De typische APEX-shop heeft DBA's die geen git gebruiken; de typische DevOps-engineer raakt Oracle niet aan; de typische AI-tooler bouwt React, geen low-code op een 30-jaar-oude database.

### Reden 3 — De publieke "voorbeelden" doen iets fundamenteel anders

De bekendste publieke referentie is [oracle-samples/oracle-apex-ai-skills](https://github.com/oracle-samples/oracle-apex-ai-skills) (staat ook in onze workspace). Die target expliciet **APEX 24.2** en kan daarom géén `.apx`-edits doen. De aanpak daar is: *"geef de AI genoeg context zodat hij JOU door Page Designer kan begeleiden."* Onze setup zet die stap voorbij: **de AI bewerkt de page direct als tekst**, valideert, importeert. Page Designer wordt optioneel.

| Aspect | `oracle-apex-ai-skills` (publiek) | Onze SCAFF setup |
|---|---|---|
| APEX-versie | 24.2 | 26.1 |
| AI bewerkt pages | ❌ (begeleidt mens in Builder) | ✅ (direct `.apx`-edits) |
| Source-of-truth | Builder, met readable exports als context | Git, met Builder als runtime |
| Skills-structuur | Eén set per repo | Generiek + thin overlay per app |
| Docker dev-stack | Niet inbegrepen | Volledig inbegrepen |
| Validate vóór import | n.v.t. (geen import-loop) | `apex validate` als gate |
| Custom agent-mode | Nee | Ja (`apex-vibe`) |

### Reden 4 — De overlay-pattern is een eigen uitvinding

De meeste Copilot-projecten kopiëren een skill-set per repo en passen die ter plekke aan. Dat schaalt niet: 10 apps = 10 keer dezelfde regels onderhouden. Onze splitsing in **generieke `apex-26-*` skills** (die elke APEX 26.1 app kan hergebruiken) plus een **dunne `scaff-overlay`** die alleen placeholders mapt, is iets dat ik in geen enkele publieke repo heb teruggevonden. Het is een directe leen uit het multi-tenant pattern (één codebase, per-klant config) toegepast op AI-instructies.

### Reden 5 — Het kost moeite om er te komen

Eerlijk gezegd: deze opzet is niet voortgekomen uit één weekend hacken. Wat de drempel verklaart:

- **Trial-and-error met APEXlang parser-quirks** — zit nu vastgelegd in `apex-26-patterns`, maar dat zijn lessen die elke nieuwe gebruiker zelf gaat ontdekken.
- **De "hard rules" in `copilot-instructions.md`** (geen directe `wwv_flow_*` writes, NL+EN verplicht, BEM-prefix) zijn pas geformuleerd nádat we mis zijn gegaan zonder.
- **De MCP-fallback regels** (`apex-mcp-sqlcl` skill) bestaan omdat we het écht hebben zien vastlopen op substitution-strings.
- **De destructive-ops checklist** is geboren uit een echte "oeps, dat was niet de bedoeling"-moment.

Wie nu vanaf scratch begint, mist al die littekens.

### Eerlijke nuance — wat is *niet* uniek

Om geen overstatement te doen:

- **Docker + Oracle 23ai Free** — vrij gangbaar sinds 2024.
- **PL/SQL in git** — basishygiëne, decennia oud.
- **`apex_lang.message` voor i18n** — sinds APEX 4.x (rond 2010).
- **BEM-CSS + mobile-first** — pure frontend-conventie.
- **SQLcl MCP server** — bestaat sinds de Oracle SQL Developer VS Code-extension van 2026, snel groeiend gebruik.
- **`copilot-instructions.md`** — duizenden repo's hebben er één.

De uniciteit zit niet in de losse bouwstenen, maar in de **complete, werkende combinatie** — op een versie die nog amper bestaat — met een overlay-pattern dat hergebruik over meerdere apps mogelijk maakt — geleid door een custom agent-mode die de project-conventies afdwingt.

### Samengevat

We doen dit eerder dan anderen, niet omdat we slimmer zijn, maar omdat:
1. We APEX 26.1 op dag één hebben opgepakt;
2. We toevallig én APEX én Docker én Copilot-customisatie beheersen;
3. We bewust het overlay-pattern hebben ontworpen voor hergebruik;
4. We pijn hebben gevoeld en die hebben vastgelegd als skills/rules.

Over zes maanden zal dit minder uniek voelen — APEXlang adopteert snel, en Oracle zal eigen referentie-implementaties uitbrengen. Ons voordeel is **time-to-pattern**: we hebben een werkend playbook terwijl de rest nog leest wat APEXlang is.

---

## 2. Lokale dev-stack — Docker

| Container | Image basis | Inhoud | Poort host → container |
|---|---|---|---|
| `apex_db` | Oracle 23ai Free | DB + APEX 26.1 runtime, PDB `FREEPDB1`, charset `AL32UTF8`, parsing schema `APP_DATA` | 2521 → 1521 |
| `apex_ords` | ORDS official | ORDS web tier + SQLcl 26.1.2 CLI | 8080 → 8080 |

**App-URL**: `http://localhost:8080/ords/r/apex_dev/scaff-app/`
**Workspace**: `APEX_DEV` (id `5800403880636291`)
**App**: SCAFF APP (id `100`, alias `scaff-app`)

**Persistentie**: `oracle_oradata/` (DB-files) en `ords_config/` (ORDS config) — beide in `.gitignore` zodat data niet wordt mee-gecommit.

**Bootstrap**: `install_apex.ps1` (eenmalig per machine) + `docker compose up -d`. Een nieuwe developer is binnen ~30 min operationeel.

---

## 3. Source-of-truth model

### `apex_app/<app>/` — APEX metadata
- Volledige app-export in **APEXlang** (`.apx`-bestanden) — door SQLcl 26.1 gegenereerd
- Eén bestand per page, region, list, theme, message-set
- Direct leesbaar/aanpasbaar als tekst → review, diff, rollback via git

### `db/packages/` — PL/SQL
| Bestand | Doel |
|---|---|
| `pkg_scaff_ui.sql` | UI-helpers (mobile menu HTML generator) |
| `hd_mobile_ui_pkg.sql` | CSS-helper, retourneert `<style>` blok als CLOB |

### `db/views/` — driver-views
| Bestand | Doel |
|---|---|
| `v_mobile_menu.sql` | Voedt de homepage-cards (label, icon, BEM-class, link, sort) |

### `db/i18n/` — meertaligheid
| Bestand | Doel |
|---|---|
| `_install_helper.sql` | `HD_I18N_INSTALL` package — schrijft `apex_lang_messages` weg |
| `messages_nl.sql` | NL-strings met prefix `SCAFF.*` |
| `messages_en.sql` | EN-strings (zelfde keys) |

**Regel**: geen hardcoded UI-tekst in PL/SQL of HTML — alles via `apex_lang.message('SCAFF.…')`.

### `scripts/` — workflow-wrappers
| Script | Functie |
|---|---|
| `apex-export.ps1` | Roept `sql -S apex export …` aan, schrijft naar `apex_app/scaff-app/` |
| `apex-import.ps1` | Importeert .apx-bestanden terug in de DB |
| `apex-validate.ps1` | Syntax-check vóór import |
| `check_login.sql` / `check_roles.sql` | Diagnostiek voor auth-issues |

---

## 4. AI-laag — instructions, skills, agent

Drie niveaus van Copilot-customisatie, met elk hun eigen rol:

### 4.1 `copilot-instructions.md` — projectbreed
Bevat de **harde regels** die voor élke conversatie gelden:
- Geen directe writes naar `apex_260100.wwv_flow_*`
- BEM `scaff-*` prefix, Altrad palette
- NL + EN verplicht
- Re-export na elke Builder-wijziging
- Pad-conventies, DB-credentials voor dev

### 4.2 `.github/instructions/*.md` — per-file
Met `applyTo`-glob, automatisch geladen als Copilot een matching file bewerkt:

| File | applyTo | Inhoud |
|---|---|---|
| `apexlang.instructions.md` | `apex_app/**/*.apx` | APEXlang syntax, parser-quirks, edit-regels |
| `plsql.instructions.md` | `db/**/*.{sql,pks,pkb}` | PL/SQL conventies, package-structuur, naming |

### 4.3 `.github/skills/` — herbruikbare playbooks
Elke skill = `SKILL.md` met YAML-frontmatter (naam + WHEN-beschrijving). Copilot kiest zelf welke skill relevant is op basis van de vraag.

| Skill | Wanneer gebruikt |
|---|---|
| `apex-26-workflow` | Export → edit → validate → import loop |
| `apex-26-bootstrap-new-app` | Nieuwe APEX app from scratch |
| `apex-26-mobile-cards` | Card-menu / dashboard-tegels |
| `apex-26-i18n` | Labels/teksten toevoegen of vertalen |
| `apex-26-patterns` | APEXlang gotchas, parser-quirks |
| `apex-debugging-systematic` | "Page werkt niet / DA faalt / upload broken" |
| `apex-destructive-ops-safe` | DROP / DELETE / TRUNCATE checklist |
| `apex-mcp-sqlcl` | Wanneer welke SQL-tool gebruiken |
| `apex-rest-integrations-secure` | REST calls vanuit PL/SQL veilig opzetten |
| `scaff-overlay` | SCAFF-specifieke mapping (prefix, palette, package-namen) |

**Overlay-pattern**: de `apex-26-*` skills zijn **generiek**. Per app is er één dunne overlay-skill die alleen placeholders mapt (BEM-prefix, palette, message-prefix, package-namen). Nieuwe app starten = nieuwe overlay schrijven, generieke skills ongewijzigd hergebruiken.

### 4.4 `.github/agents/apex-vibe.agent.md` — orkestrator
Custom agent-mode voor SCAFF APP. Roept de juiste skills aan in de juiste volgorde, dwingt project-conventies af, en weet wanneer de export → import loop moet draaien.

---

## 5. Tooling-integraties

| Tool | Doel |
|---|---|
| **SQLcl 26.1.2** (in `apex_ords` container) | `apex export/import/validate` commando's, plus generieke SQL CLI |
| **SQLcl MCP server** (Oracle SQL Developer VS Code extension) | Directe DB-queries vanuit chat — `sql_run`, `sqlcl_run`, `schema_information`. Saved connections: `apex_dev` (APP_DATA), `apex_sys` (SYS) |
| **VS Code Browser tools** | Live smoke-test in dezelfde sessie als de code-edits |
| **GitKraken MCP** | Git operaties (status, commit, push, diff) zonder terminal-context-switch |
| **PowerShell wrappers** | `scripts/apex-*.ps1` voor reproducibele export/import |

---

## 6. De golden loop

```
1. apex export       →  apex_app/scaff-app/         snapshot
2. git commit                                       rollback-punt
3. edit .apx / .sql / packages                     Copilot helpt
4. apex validate                                    syntax check
5. apex import                                      deploy naar DB
6. browser smoke-test                               mobile viewport
7. git commit + push                                record
```

Elke stap heeft een script of tool — geen handmatige Builder-clicks als waarheid.

---

## 7. Wat we nog moeten implementeren

Het fundament staat, maar voor een echt productie-platform missen we nog dit:

### 7.1 Geautomatiseerde tests
- **utPLSQL** in de DB voor package-tests
- **Playwright** tegen `localhost:8080/ords/r/apex_dev/scaff-app/` voor UI-smoketests
- VS Code task `test:all` die beide draait
- Voorwaarde voor veilige refactors op grotere schaal

### 7.2 CI/CD-pipeline
- **GitHub Actions workflow** die bij elke push naar `main`:
  1. een tijdelijke Oracle 23ai + APEX 26.1 container start
  2. `db/install/` draait (packages, views, i18n)
  3. `apex import` doet
  4. utPLSQL + Playwright suites uitvoert
  5. bij succes optioneel naar TEST-omgeving deployt
- Secrets in GitHub Secrets, niet in repo

### 7.3 Multi-environment support
- Drie targets: `dev` (local Docker), `test`, `prod`
- Environment-config in `scripts/env.<name>.ps1` of `.env.<name>`
- `apex-import.ps1 -Env test` parameter
- Aparte workspace-IDs en parsing schemas per omgeving

### 7.4 Centrale skill-registry
- Bij >1 repo: skills naar een gedeelde npm/git submodule of een dedicated `oracle-apex-skills` repo
- Per project alleen de overlay-skill lokaal
- Versionering zodat skill-updates niet onverwacht bestaande projecten breken

### 7.5 Observability
- APEX debug logs → centrale tabel + dashboard
- `apex_activity_log` views in een rapport
- Error notification (mail/Teams) bij `ORA-` errors in productie

### 7.6 Database-migraties als versies
- Nu: één `db/install/install_all.sql`
- Beter: **Liquibase** of **Flyway** met versioned changelogs (`V001__init.sql`, `V002__add_table_x.sql`)
- Audit-trail van schema-wijzigingen

### 7.7 Secret management
- Nu: dev-wachtwoord staat in `copilot-instructions.md`
- Beter: Oracle Wallet of OS-keystore voor prod-credentials
- APEX REST-credentials via `apex_credentials` API met externe secret store

### 7.8 Documentatie-generatie
- Skills + agents als basis nemen om **per app** automatisch een `docs/architecture.md` te genereren
- Pages-overzicht, dependency-graph (page → package → view → table)
- Visueel via Mermaid

### 7.9 Authenticatie-uitbreidingen
- Nu: APEX-account auth voor dev
- Productie: SSO via Microsoft Entra / OAuth2 + role-mapping naar APEX authorization schemes
- Apart skill: `apex-auth-entra.md`

### 7.10 Onboarding-wizard
- `scripts/bootstrap.ps1` die alles in één run doet:
  1. Docker check
  2. `docker compose up -d`
  3. APEX install
  4. SQLcl MCP connection toevoegen aan VS Code
  5. Smoke-test draaien
- Doel: van `git clone` tot werkende app < 15 minuten

---

## 8. Samenvatting

Wat we **hebben**:
- Reproduceerbare lokale stack in Docker
- Volledige APEX-metadata als tekst in git
- Drie-laags Copilot-customisatie (instructions + skills + agent)
- Werkende export ↔ import loop via SQLcl 26.1
- NL/EN i18n via APEX messages
- Mobile-first card-pattern als herbruikbare skill
- MCP-integratie voor directe DB-queries
- Veiligheidsregels tegen destructieve operaties

Wat we **nog moeten doen**:
- Tests (utPLSQL + Playwright)
- CI/CD pipeline
- Multi-environment workflow
- Versioned DB-migraties
- SSO / Entra-integratie
- Observability + alerting
- Bootstrap-wizard voor nieuwe developers

Het verschil tussen "leuke proof-of-concept" en "platform voor enterprise APEX-development" zit in punt 7. Het fundament onder die punten — versioned metadata, AI-aware tooling, repeatable workflow — staat er al.
