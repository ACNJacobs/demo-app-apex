# SCAFF APP — Multi-language (i18n) setup

Hoe de meertalige SCAFF APP (NL/EN/FR/DE/PL/RU/AR/TR) werkt, **per laag**, met daarna een aparte sectie voor **APEX 24** (waar één onderdeel net iets anders heet).

> Verifieerd: APEX 26.1, app `100`, workspace `APEX_DEV`, schema `APP_DATA`, parsing taal `nl`.

---

## 1. De vier puzzelstukken

```
+--------------------------+   +-----------------------------+
| 1. Application setting   |   | 2. Text Messages            |
|    languageDerivedFrom   |   |    (apex_application_       |
|    = appPreference       |   |     translations)           |
+------------+-------------+   +--------------+--------------+
             |                                |
             v                                v
+--------------------------+   +-----------------------------+
| 3. Language switcher     |   | 4. Client-side label        |
|    (P1_LANG + AJAX call  |   |    refresh op form-pagina's |
|    set_session_lang)     |   |    (apex.lang.addMessages + |
|                          |   |     apex.lang.getMessage)   |
+--------------------------+   +-----------------------------+
```

Zonder **alle vier** rendert APEX altijd de primary language. Het stuk dat het vaakst vergeten wordt is `languageDerivedFrom: appPreference` — zonder dit negeert APEX `apex_util.set_session_lang` volledig.

---

## 2. Stuk 1 — Application setting

`apex_app/scaff-app/application.apx`:

```yaml
globalization {
    primaryLanguage: nl
    languageDerivedFrom: appPreference   # <-- KRITIEK
    ...
}
```

Na import: in `apex_applications.language_derived_from` staat dan `FLOW_PREFERENCE`. APEX leest dan elke request de preference `FSP_LANGUAGE_PREFERENCE` uit en kiest de juiste taal.

> APEXlang enum is **camelCase** (`appPreference`), in de Builder-UI heet het "Application Preference".

---

## 3. Stuk 2 — Text Messages (de teksten zelf)

Alle UI-tekst staat als **Text Message** met sleutel `SCAFF.<MODULE>.<ELEMENT>.<KIND>`.

### Storage
- `apex_application_translations` (system view: `apex_application_messages`)
- Per app, per language code, per static_id

### Onze install-flow
- Helper-package: `db/i18n/_install_helper.sql` → `HD_I18N_INSTALL.upsert(name, lang, text)`
  - Gebruikt `apex_lang.create_message` / `apex_lang.update_message` (officiële API; geen DML op dictionary).
- Per taal één SQL-bestand: `db/i18n/messages_{nl,en,fr,de,pl,ru,ar,tr}.sql`
- Voorbeeld:
  ```sql
  HD_I18N_INSTALL.upsert('SCAFF.MENU.MATERIAAL.TITLE', 'nl', 'Materiaal aanvraag');
  HD_I18N_INSTALL.upsert('SCAFF.MENU.MATERIAAL.TITLE', 'en', 'Material request');
  ```

### Belangrijke regel
> `apex import` **overschrijft** shared-components/messages uit de `messages.apx`-export. Wijzigingen die alleen via `messages_*.sql` zijn ingevoerd worden bij volgende import gewist. **Altijd direct na een `messages_*.sql` run** opnieuw `pwsh scripts/apex-export.ps1` zodat `messages.apx` weer in sync is en git de waarheid weergeeft.

### Lezen in PL/SQL
```sql
htp.p(apex_lang.message('SCAFF.MENU.MATERIAAL.TITLE'));
```
> Buiten een APEX-sessie geeft `apex_lang.message` de sleutel zelf terug. Test altijd binnen `apex_session.create_session(...)` + `apex_util.set_session_lang(...)`.

---

## 4. Stuk 3 — Language switcher (page 1)

Op `p00001-home.apx` staat:

| Component | Doel |
|---|---|
| `P1_LANG` (selectList NL/EN/FR/...) | UI-keuze + bewaart taalcode |
| `before-header` proces `Detect language` | Leest browser `Accept-Language` + bestaande preference |
| AJAX-callback `SET_LANGUAGE` | Wordt vanuit JS aangeroepen bij keuze |
| `after-submit` proces `Set language preference` | Voor non-AJAX fallback |

Kern PL/SQL (de AJAX-callback):

```sql
declare
  l_lang varchar2(10) := apex_application.g_x01;
begin
  if l_lang in ('nl','en','fr','de','pl','ru','ar','tr') then
    apex_util.set_preference('FSP_LANGUAGE_PREFERENCE', l_lang);  -- voor volgende sessies
    apex_util.set_session_lang(l_lang);                            -- voor huidige sessie
  end if;
  apex_json.open_object;
  apex_json.write('status','success');
  apex_json.close_object;
end;
```

> **Hardgecodeerde whitelist op twee plekken** — dit is de struikelblok bij het toevoegen van een nieuwe taal:
> 1. `p00001-home.apx` (twee keer: detect-process + AJAX-process)
> 2. `pkg_scaff_ui.get_mobile_menu` rond regel 61 (`if l_lang not in ('nl','en','fr',...) then l_lang := 'en'`)
>
> Vergeet je #2, dan wisselt de LOV wel maar tegels blijven Engels.

---

## 5. Stuk 4 — Client-side label refresh op form-pagina's

Op pagina's met dynamische items (p11 / p21 / p31) wordt label-tekst **niet** opnieuw uit `apex_lang.message` gehaald als de taal wisselt zonder pagina-refresh. Daarvoor is per pagina een `i18n-labels` regio:

1. **Region (sequence 1, body, template `@/blank-with-attributes-no-grid`, type `dynamicContent`)** levert PL/SQL die een `<script>` blokje rendert:
   ```sql
   return '<script>window._scaffMsgData={'||
     '"SCAFF.MR.FORM.QTY":"'||apex_lang.message('SCAFF.MR.FORM.QTY')||'",'||
     ...
     '}</script>';
   ```
2. **`executeWhenPageLoads` JS** (taal: `javascript-browser`):
   ```js
   if (window._scaffMsgData) { apex.lang.addMessages(window._scaffMsgData); }
   $('#P11_QTY_LABEL').text(apex.lang.getMessage('SCAFF.MR.FORM.QTY'));
   // ... per label
   ```

Waarom een **region** + niet direct in `executeWhenPageLoads`? Omdat de region eerder rendert: tegen de tijd dat APEX `apex.lang` initieert, staat onze data al in `window._scaffMsgData`.

---

## 6. Stappenplan: nieuw label toevoegen

1. Bedenk sleutel — `SCAFF.<MODULE>.<ELEMENT>.<KIND>`.
2. Eén regel per taal in **alle** `db/i18n/messages_*.sql` bestanden.
3. Run helper:
   ```pwsh
   docker cp "db/i18n/messages_nl.sql" apex_ords:/tmp/m_nl.sql
   docker exec -i apex_ords sql -S "APP_DATA/Welkom_APEX_2026!@apex_db:1521/FREEPDB1" "@/tmp/m_nl.sql" "exit"
   # idem per taal
   ```
4. **Direct daarna** `pwsh scripts/apex-export.ps1` zodat `messages.apx` synchroon is.
5. Gebruik in code: `apex_lang.message('SCAFF.X.Y.Z')` (PL/SQL) of `apex.lang.getMessage('SCAFF.X.Y.Z')` (JS, na addMessages).
6. `git add db/i18n/messages_*.sql apex_app/scaff-app/shared-components/messages.apx ; git commit ; git push`.

## 7. Stappenplan: nieuwe taal toevoegen (bv. Spaans `es`)

1. **Application install setting** — In Builder of `application.apx` onder `globalization → translatedApplications`: voeg `es` toe (mapping naar app id 100).
2. **Bestand** `db/i18n/messages_es.sql` aanmaken (kopie van `messages_en.sql`, vertaal teksten).
3. **Whitelist updaten op de twee plekken**:
   - `apex_app/scaff-app/pages/p00001-home.apx` (detect + ajax-callback): `('nl','en',...,'es')`
   - `db/packages/pkg_scaff_ui.sql` `get_mobile_menu`: zelfde lijst.
4. **LOV `LOV_SCAFF_LANG`** uitbreiden met `Español / es`.
5. Helper draaien (zie 6.3) en re-export.
6. APEX vereist nog een **Seed → Translate → Publish** cyclus per pagina-tekst die niet via Text Messages loopt (knoppen, regio-titels die rechtstreeks in `.apx` staan). Voor SCAFF APP loopt vrijwel alles via messages, dus dit is meestal niet nodig.

---

## 8. APEX 24 — wat is er anders?

De **architectuur is identiek** in APEX 24.x. Alleen wat namen en kleine details verschillen. Het patroon (preference + text messages + session_lang + addMessages) werkt 1-op-1.

| Onderwerp | APEX 26.1 | APEX 24.x |
|---|---|---|
| Application setting | `globalization.languageDerivedFrom: appPreference` (APEXlang) | Builder: *Shared Components → Globalization Attributes → Application Language Derived From* = **Application Preference**. In `f100/application/create_application.sql` heet de parameter `p_flow_language_derived_from => '4'` (waarde **4** = preference). |
| Text Messages dictionary | `apex_application_translations.static_id` | Pre-24.1 heette dit veld in sommige views `name` ipv `static_id`. Voor 24.1+ ook `static_id`. Onze helper gebruikt `apex_lang.create_message/update_message` API → **versie-onafhankelijk**, geen aanpassing nodig. |
| Preference set | `apex_util.set_preference('FSP_LANGUAGE_PREFERENCE', l_lang)` | Identiek. Bestaat sinds APEX 5. |
| Session language switch | `apex_util.set_session_lang(l_lang)` | Identiek. |
| `apex.lang.addMessages` (JS) | Aanwezig | Aanwezig sinds APEX 19.2. |
| AJAX callback proces | APEXlang `point: ajaxCallback` | Builder: *Process → On Demand* (zelfde mechanisme, andere UI). Aanroep blijft `apex.server.process('SET_LANGUAGE', {x01: lang})`. |
| Friendly URLs (`/r/...`) | Default aan | In 24.x ook aan. Geen impact op i18n. |
| APEXlang | Ja, jouw export-import flow | **Niet** voor APEX 24 — APEXlang ondersteunt 26.1+ (en in beperkte mate 23.2). Voor APEX 24 gebruik je in plaats daarvan de klassieke export: `apex_export.get_application(...)` of de Builder export naar één SQL-bestand. |

### Concreet stappenplan op APEX 24 (zonder APEXlang)

1. **Application Preference instellen** (eenmalig):
   - Builder → Shared Components → Globalization Attributes
   - *Application Language Derived From* = **Application Preference**
   - Save.

2. **Helper-package installeren** — `db/i18n/_install_helper.sql` werkt **ongewijzigd** op 24.x (gebruikt alleen `apex_util.*` + `apex_lang.create_message/update_message` + `apex_application_install` — alles sinds 19.x stabiel).

3. **Messages laden** — exact dezelfde `messages_*.sql` bestanden zijn herbruikbaar. Pas alleen `c_app_id` en `c_workspace` boven in `_install_helper.sql` aan voor jouw 24-installatie.

4. **Language-switcher op page 1**:
   - Item `P1_LANG` (Select List, LOV met taalcodes).
   - Process **Before Header** (PL/SQL): browser-detect + lees preference (zelfde body als boven).
   - Process **On Demand** (heet hier zo, geen `ajaxCallback`): naam `SET_LANGUAGE`, body identiek aan onze AJAX-callback.
   - Dynamic Action **Change** op `P1_LANG`: *Execute JavaScript Code* →
     ```js
     apex.server.process('SET_LANGUAGE', { x01: $v('P1_LANG') }, {
       success: () => location.reload()
     });
     ```

5. **Form-page label refresh**:
   - Region type **PL/SQL Dynamic Content** (24.x equivalent van `dynamicContent`) → genereert `<script>window._scaffMsgData={...}</script>`.
   - Page Attributes → *Execute when Page Loads* → identieke JS (`addMessages` + `getMessage` per label).

6. **Whitelist** — dezelfde twee plekken (homepage processen + UI package), die concepten zijn versie-onafhankelijk.

### Waar moet je extra opletten op APEX 24
- **Theme**: Universal Theme 24 heeft licht andere CSS hooks dan UT 26. Onze `scaff-*` BEM-laag is theme-agnostisch en blijft werken.
- **Translation Repository**: APEX heeft ook een traditionele *Translation Repository* (Seed → Translate → Publish). Wij **gebruiken die niet** voor SCAFF — alle teksten zitten in Text Messages, wat eenvoudiger is en in 24.x net zo goed werkt. Zorg alleen dat je geen mengvorm krijgt.
- **`apex_lang.update_message` vs `apex_lang.create_message`**: in oudere 24.0 patches gaf `update_message` soms `ORA-20987` als `static_id` ontbrak. Helper vangt dit door eerst te selecteren op `translation_entry_id` — dat hebben alle 24.x versies.
- **Karakterset**: zorg dat de DB `AL32UTF8` is (op 24.x meestal default). Anders mojibake bij AR/RU/PL — zelfde issue als bij ons in `docs/teken-encoding-herstel.md`.

---

## 9. Smoke-test checklist (beide versies)

1. Login → home laadt in primary language.
2. Wissel taal in `P1_LANG` LOV → cards renderen in nieuwe taal **zonder** handmatig refreshen.
3. F12 console: `apex_util.get_preference('FSP_LANGUAGE_PREFERENCE')` returnt geselecteerde code.
4. SQL-check:
   ```sql
   select count(*) from apex_application_translations
    where application_id = 100 and language_code = 'tr';
   ```
   Moet > 0 zijn voor elke geconfigureerde taal.
5. Open form-pagina (p11 / p21 / p31) → labels in juiste taal, ook bij wissel-zonder-reload (alleen op 26.1 met onze region; op 24.x werkt het na `location.reload()` uit stap 4).

---

## 10. Bronnen in deze repo
- `apex_app/scaff-app/application.apx` — globalization block
- `db/i18n/_install_helper.sql` — `HD_I18N_INSTALL` package
- `db/i18n/messages_*.sql` — teksten per taal
- `apex_app/scaff-app/pages/p00001-home.apx` — switcher + whitelist (1/2)
- `db/packages/pkg_scaff_ui.sql` (`get_mobile_menu`) — whitelist (2/2)
- `apex_app/scaff-app/pages/p000{11,21,31}-*.apx` — `i18n-labels` regions + JS
- `.github/skills/apex-26-i18n/SKILL.md` — generieke skill (door dit document gespiegeld)
