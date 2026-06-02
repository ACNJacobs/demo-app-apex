# SCAFF APP — Multi-language (i18n) setup

Hoe de meertalige SCAFF APP (NL/EN/FR/DE/PL/RU/AR/TR) werkt, **per laag**, met daarna een aparte sectie voor **APEX 24** (waar één onderdeel net iets anders heet).

> **Verifieerd**: APEX 26.1 (live in deze repo, app `100`, workspace `APEX_DEV`, schema `APP_DATA`).
> **APEX 24-sectie**: alle API-signatures gecheckt tegen de officiële Oracle docs voor 24.1 én 24.2 (links onderaan §10). UI-screenshots zijn niet hertest — beschrijvingen volgen Oracle's *App Builder User's Guide* hoofdstuk 22.

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

De **architectuur is identiek** in APEX 24.1 en 24.2. Alle PL/SQL- en JavaScript-API's die wij gebruiken hebben dezelfde signature, geverifieerd tegen de officiële Oracle docs (zie §10 voor links). Alleen wat namen in de Builder en het ontbreken van APEXlang zijn anders.

| Onderwerp | APEX 26.1 | APEX 24.x | Status |
|---|---|---|---|
| Application setting | `globalization.languageDerivedFrom: appPreference` (APEXlang) | Builder: *Shared Components → Globalization Attributes → Application Language Derived From* = **Application Preference**. | UI gecheckt in Oracle docs ch.22 |
| `apex_util.set_session_lang(p_lang)` | Bestaat | **Identiek** — Oracle docs 24.1 §58.130 / 24.2 §59.134 | Geverifieerd |
| `apex_lang.create_message(p_application_id, p_name, p_language, p_message_text, p_used_in_javascript)` | Bestaat | **Identiek**, ook 5 parameters. `p_used_in_javascript => true` zet de message in de auto-loaded JS-cache (dan hoef je `addMessages` niet zelf te doen!). | Geverifieerd Oracle docs 24.1 §39.3 |
| `apex_lang.update_message(p_id, p_message_text)` | Bestaat | **Identiek**, 2 parameters. | Geverifieerd Oracle docs 24.1 §39.14 |
| `apex.lang.addMessages` / `getMessage` / `formatMessage` (JS) | Bestaat | **Identiek** in 24.1 + 24.2. | Geverifieerd JS API ref |
| `apex_application_translations` view | Onze helper filtert op kolom `static_id` | **Mogelijk verschillend** — Oracle's eigen 24.1-voorbeeld bij `update_message` filtert op kolom `translatable_message`. **Verifieer vóór gebruik**: `select column_name from all_tab_cols where table_name='APEX_APPLICATION_TRANSLATIONS'`. | Aandacht vereist |
| AJAX callback proces | APEXlang `point: ajaxCallback` | Builder: maak een **Process** met *Process Point = "Ajax Callback"* (sinds APEX 23). | Identieke runtime |
| APEXlang | Default flow voor 26.1 in onze repo | **Niet** voor APEX 24 — APEXlang ondersteunt 26.1+. Voor APEX 24 gebruik klassieke export: `apex_export.get_application(...)` of de Builder export (Shared Components → Export). | Ander tooling |

### Concreet stappenplan op APEX 24 (zonder APEXlang)

1. **Application Preference instellen** (eenmalig):
   - Builder → Shared Components → **Globalization Attributes**
   - *Application Language Derived From* = **Application Preference**
   - Save.

2. **Helper-package installeren** — `db/i18n/_install_helper.sql` werkt **bijna ongewijzigd** op 24.x. Eén check vooraf:

   ```sql
   select column_name
     from all_tab_cols
    where table_name = 'APEX_APPLICATION_TRANSLATIONS'
      and column_name in ('STATIC_ID','TRANSLATABLE_MESSAGE','NAME')
    order by column_name;
   ```

   Als `STATIC_ID` ontbreekt en alleen `TRANSLATABLE_MESSAGE` aanwezig is, vervang in `_install_helper.sql` deze regel:

   ```sql
   -- Origineel (26.1):
   where application_id = c_app_id and static_id = p_name and language_code = p_lang;
   -- Aanpassing voor APEX 24 (indien static_id niet bestaat):
   where application_id = c_app_id and translatable_message = p_name and language_code = p_lang;
   ```

   Verder ongewijzigd: `apex_lang.create_message` / `update_message` werken hetzelfde.

3. **Tip** — voeg `p_used_in_javascript => true` toe aan `create_message` voor labels die je in JavaScript wilt gebruiken (`apex.lang.getMessage`). APEX laadt die dan automatisch op pagina-load; je hebt dan onze `_scaffMsgData`-region niet nodig:

   ```sql
   apex_lang.create_message(
     p_application_id     => c_app_id,
     p_name               => p_name,
     p_language           => p_lang,
     p_message_text       => p_text,
     p_used_in_javascript => true   -- <-- belangrijk voor JS-gebruik
   );
   ```

4. **Messages laden** — exact dezelfde `messages_*.sql` bestanden zijn herbruikbaar. Pas alleen `c_app_id` en `c_workspace` boven in `_install_helper.sql` aan voor jouw 24-installatie.

5. **Language-switcher op page 1**:
   - Item `P1_LANG` (Select List, LOV met taalcodes).
   - Process **Before Header** (PL/SQL): browser-detect + lees preference (zelfde body als boven).
   - Process **Ajax Callback** (heet in Builder zo): naam `SET_LANGUAGE`, body identiek aan onze AJAX-callback.
   - Dynamic Action **Change** op `P1_LANG`: *Execute JavaScript Code* →
     ```js
     apex.server.process('SET_LANGUAGE', { x01: $v('P1_LANG') }, {
       success: () => location.reload()
     });
     ```

6. **Form-page label refresh** — twee opties:
   - **Optie A (aanbevolen op 24)**: messages aanmaken met `p_used_in_javascript => true`. APEX laadt ze automatisch; gebruik direct `apex.lang.getMessage('SCAFF.X.Y.Z')` zonder helper-region.
   - **Optie B (als 26.1)**: PL/SQL Dynamic Content region die `<script>window._scaffMsgData={...}</script>` rendert + `executeWhenPageLoads` JS met `apex.lang.addMessages` + label-binding. Werkt ook op 24.

7. **Whitelist** — dezelfde twee plekken (homepage processen + UI package), versie-onafhankelijk.

### Waar moet je extra opletten op APEX 24
- **Theme**: Universal Theme 24 heeft licht andere CSS hooks dan UT 26. Onze `scaff-*` BEM-laag is theme-agnostisch en blijft werken.
- **Translation Repository**: APEX heeft daarnaast de traditionele *Seed → Translate → Publish* workflow voor pagina-tekst die niet via Text Messages loopt. Wij **gebruiken die niet** voor SCAFF — alle teksten zitten in Text Messages, simpeler en in 24.x net zo goed werkend. Meng de twee niet.
- **Karakterset**: zorg dat de DB `AL32UTF8` is (op 24.x meestal default). Anders mojibake bij AR/RU/PL — zelfde issue als bij ons in `docs/teken-encoding-herstel.md`.
- **`update_message` op subscribed messages**: Oracle 24.1 docs waarschuwen expliciet dat `update_message` faalt op een subscribed text message. Eerst ontkoppelen via Builder.

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

## 11. Officiële Oracle docs (voor de APEX 24-claims)

Geverifieerd op 02-Jun-2026:

- APEX 24.1 — App Builder User's Guide, hoofdstuk 22 *Managing Application Globalization*: <https://docs.oracle.com/en/database/oracle/apex/24.1/htmdb/managing-application-globalization.html>
- APEX 24.2 — *Managing Application Globalization*: <https://docs.oracle.com/en/database/oracle/apex/24.2/htmdb/managing-application-globalization.html>
- APEX 24.1 — *Translating Messages*: <https://docs.oracle.com/en/database/oracle/apex/24.1/htmdb/translating-messages.html>
- APEX 24.1 API — `APEX_UTIL.SET_SESSION_LANG`: <https://docs.oracle.com/en/database/oracle/apex/24.1/aeapi/SET_SESSION_LANG-Procedure.html>
- APEX 24.2 API — `APEX_UTIL.SET_SESSION_LANG`: <https://docs.oracle.com/en/database/oracle/apex/24.2/aeapi/SET_SESSION_LANG-Procedure.html>
- APEX 24.1 API — `APEX_LANG.CREATE_MESSAGE` (signature met `p_used_in_javascript`): <https://docs.oracle.com/en/database/oracle/apex/24.1/aeapi/CREATE_MESSAGE-Procedure.html>
- APEX 24.1 API — `APEX_LANG.UPDATE_MESSAGE`: <https://docs.oracle.com/en/database/oracle/apex/24.1/aeapi/UPDATE_MESSAGE-Procedure.html>
- APEX 24.1 JS API — `apex.lang` namespace: <https://docs.oracle.com/en/database/oracle/apex/24.1/aexjs/apex.lang.html>
- APEX 24.2 JS API — `apex.lang` namespace: <https://docs.oracle.com/en/database/oracle/apex/24.2/aexjs/apex.lang.html>
