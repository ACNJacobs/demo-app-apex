---
name: apex-26-i18n
description: Generic NL/EN (or any language pair) translation workflow for Oracle APEX 26.1 apps in this workspace, using APEX text messages and the HD_I18N_INSTALL helper package. Use whenever the user wants to add, change, or translate user-visible labels, titles, subtitles, button captions, error messages, or notifications in any app. App-specific message prefix comes from the app's overlay skill.
---

# APEX 26.1 i18n Workflow (app-agnostic)

Same workflow works for SCAFF (`SCAFF.*`), INSPECT (`INSPECT.*`), or any future app. Replace `<APP>` with the app's message prefix from its overlay skill.

## Stack

- **Primary language**: `nl` (Dutch) — change per app if needed
- **Secondary**: `en` (English)
- **Runtime API**: `apex_lang.message('<APP>.<DOMAIN>.<SUBJECT>.<ROLE>')`
- **Install helper**: `HD_I18N_INSTALL.upsert_message(p_name, p_message, p_language)` (defined in `db/i18n/_install_helper.sql`)

## Naming convention

```
<APP>.<DOMAIN>.<SUBJECT>.<ROLE>
       │       │         └─ TITLE | SUBTITLE | LABEL | PLACEHOLDER | ERROR | CONFIRM | EMPTY
       │       └─ HOME | LOGIN | <DOMAIN-WORD>
       └─ MENU | FORM | TOAST | NAV | PAGE | COL
```

Examples:
- `SCAFF.MENU.MATERIAAL.TITLE` → "Materiaal aanvraag" / "Material request"
- `INSPECT.FORM.SUBMIT.LABEL`  → "Indienen" / "Submit"
- `<APP>.TOAST.SAVED.SUCCESS`  → "Opgeslagen" / "Saved"
- `<APP>.PAGE.LIST.COL.STATUS` → "Status" / "Status"

Keys are ALL_CAPS, dot-separated, ASCII only.

## Adding a translation — Option A (APEXlang, preferred)

1. Edit `apex_app/<alias>/shared-components/messages.apx`
2. Add **two** `textMessage` blocks (NL + EN). They share the same key:
   ```
   textMessage <APP>.FORM.SUBMIT.LABEL (
       message { text: Indienen, language: nl }
   )
   textMessage <APP>.FORM.SUBMIT.LABEL (
       message { text: Submit, language: en }
   )
   ```
3. `pwsh scripts/apex-validate.ps1 -Alias <alias>`
4. `pwsh scripts/apex-import.ps1   -Alias <alias>`

Version-controlled, round-trippable.

## Adding a translation — Option B (HD_I18N_INSTALL, bulk seed)

When you need to load 50+ messages at once:

1. Append to `db/i18n/messages_<app>_nl.sql` and `messages_<app>_en.sql`:
   ```sql
   HD_I18N_INSTALL.upsert_message('<APP>.FORM.SUBMIT.LABEL', 'Indienen', 'nl');
   ```
2. Wrap in `apex_util.set_security_group_id(<workspace_id>);` if running cross-workspace.
3. Run both files via APP_DATA connection.
4. Re-export: `pwsh scripts/apex-export.ps1 -Alias <alias>` so `messages.apx` reflects DB state.

## Referencing

- **PL/SQL**: `htp.p(apex_escape.html(apex_lang.message('<APP>.…')))`
- **APEXlang property (title, label, button text)**: `&<APP>.MENU.MATERIAAL.TITLE.`
  > ⚠️ Cosmetic bug: in page-title, APEX stops at first `.` — see `apex-26-patterns` gotcha #4.
- **JavaScript** (rare): use the `apex.lang.getMessage('<APP>.…')` after registering the messages.

## Verification

```sql
select translatable_message, language_code, message_text
  from apex_application_translations
 where application_id = <id>
   and translatable_message like '<APP>.%'
 order by translatable_message, language_code;
```

> Correct column is `translatable_message` (NOT `message_name` / `static_id`).
> Outside an APEX session, `apex_lang.message('<KEY>')` returns the KEY itself — verify via the table above.

## Rules

- ✅ Add messages **in pairs** (NL + EN). Never NL-only or EN-only.
- ✅ Escape with `apex_escape.html(...)` when injecting into HTML.
- ✅ Keep prefix one-app-wide (no cross-app sharing — different prefix per app).
- ❌ Never hardcode user-visible Dutch/English in PL/SQL, .apx, or JavaScript.
- ❌ Never reuse another app's prefix (e.g. don't use `SCAFF.*` in INSPECT).

## Adding a third language (optional)

Three steps:
1. Add the language to the app's `application.apx` → `globalization.applicationTranslations`.
2. Add a third `textMessage` block per key, with `language: <code>`.
3. Add `messages_<app>_<code>.sql` and seed via `HD_I18N_INSTALL.upsert_message`.
