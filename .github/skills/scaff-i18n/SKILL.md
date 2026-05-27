---
name: scaff-i18n
description: NL/EN translation workflow for SCAFF APP using APEX text messages and the HD_I18N_INSTALL helper package. Use whenever the user wants to add, change, or translate user-visible labels, titles, subtitles, button captions, error messages, or notifications.
---

# SCAFF i18n Workflow

## Stack

- **Primary**: `nl` (Dutch)
- **Secondary**: `en` (English)
- **APIs**:
  - Runtime: `apex_lang.message('SCAFF.<DOMAIN>.<KEY>')`
  - Install: `HD_I18N_INSTALL.upsert_message(p_name, p_message, p_language)`

## Message Naming

```
SCAFF.<DOMAIN>.<SUBJECT>.<ROLE>
       │       │         └─ TITLE | SUBTITLE | LABEL | ERROR | CONFIRM
       │       └─ MATERIAAL | RETOUR | TRANSFER | LOGIN | TICKET
       └─ MENU | FORM | TOAST | NAV
```

Examples:
- `SCAFF.MENU.MATERIAAL.TITLE` → "Materiaal aanvraag" / "Material request"
- `SCAFF.FORM.RETOUR.SUBMIT.LABEL` → "Indienen" / "Submit"
- `SCAFF.TOAST.SAVED.SUCCESS` → "Opgeslagen" / "Saved"

## Adding a Translation

### Option A — via APEXlang (preferred, version-controlled)

1. Edit `apex_app/scaff-app/shared-components/messages.apx`
2. Add **two** `textMessage` blocks (NL + EN), e.g.:
   ```
   textMessage SCAFF.FORM.RETOUR.SUBMIT.LABEL (
       message { text: Indienen, language: nl }
   )
   textMessage SCAFF.FORM.RETOUR.SUBMIT.LABEL (
       message { text: Submit, language: en }
   )
   ```
3. `pwsh scripts/apex-validate.ps1`
4. `pwsh scripts/apex-import.ps1`

### Option B — via HD_I18N_INSTALL (for bulk seeding)

1. Append to `db/i18n/messages_nl.sql` and `messages_en.sql`:
   ```sql
   HD_I18N_INSTALL.upsert_message('SCAFF.FORM.RETOUR.SUBMIT.LABEL', 'Indienen', 'nl');
   ```
2. Run both files via APP_DATA connection.
3. Re-export with `apex-export.ps1` so `messages.apx` reflects DB state.

## Verifying

```sql
SELECT name, language_code, message_text
  FROM apex_application_translations
 WHERE application_id = 100
   AND name LIKE 'SCAFF.%'
 ORDER BY name, language_code;
```

## Rules

- Add messages **in pairs** (NL + EN). Never NL-only or EN-only.
- Reference messages in PL/SQL: `htp.p(apex_escape.html(apex_lang.message('SCAFF.…')))`.
- Reference messages in `.apx`: `title: &SCAFF.MENU.MATERIAAL.TITLE.` (APEX substitution string).
- Never hardcode user-visible Dutch/English in source code.
- Keep keys ALL_CAPS, dot-separated, ASCII only.
