---
name: scaff-overlay
description: SCAFF APP (id 100, alias scaff-app) specifics — overlay for the generic apex-26-* skills. Maps generic placeholders to SCAFF values (BEM prefix scaff-*, Altrad red palette, message prefix SCAFF.*, package PKG_SCAFF_UI, view V_MOBILE_MENU). Use whenever the user works on SCAFF APP.
---

# SCAFF APP overlay

Mapping for the generic `apex-26-*` skills.

| Generic placeholder | SCAFF value |
|---|---|
| `<id>` | `100` |
| `<alias>` | `scaff-app` |
| `<prefix>` | `scaff` |
| `<PREFIX>` | `SCAFF` |
| `<APP>` (message prefix) | `SCAFF` |
| `<primary>` | `#E2001A` |
| `<dark>` | `#B30015` |
| `<soft>` | `#FCE6E9` |
| Default language | `nl` |
| Workspace | `APEX_DEV` |
| Parsing schema | `APP_DATA` |

## Wrappers (defaults are SCAFF, so plain run works)

```powershell
pwsh scripts/apex-export.ps1                              # = -AppId 100 -Alias scaff-app
pwsh scripts/apex-validate.ps1                            # = -Alias scaff-app
pwsh scripts/apex-import.ps1                              # = -Alias scaff-app
```

## Files

- View: `db/views/v_mobile_menu.sql` (legacy name — kept; serves as `V_<PREFIX>_MENU`)
- UI package: `db/packages/pkg_scaff_ui.sql`
  - `get_mobile_menu` — home cards
  - `get_placeholder` — empty page helper for pages 10/20/30/40
  - `get_my_requests` — page 50 ticket list with status pills
- CSS helper: `db/packages/hd_mobile_ui_pkg.sql` (legacy name) — returns CSS via `get_menu_css` and `get_css`
- Messages NL: `db/i18n/messages_nl.sql`
- Messages EN: `db/i18n/messages_en.sql`
- APEXlang: `apex_app/scaff-app/`

## Status pill variants in use

- `scaff-pill--open` — red `#E2001A`
- `scaff-pill--in_progress` — amber
- `scaff-pill--waiting` — soft pink `#FCE6E9`
- `scaff-pill--closed` — green

## URLs

- Friendly: <http://localhost:8080/ords/r/apex_dev/scaff-app/home>
- Classic:  <http://localhost:8080/ords/f?p=100:1>
- Builder:  <http://localhost:8080/ords/f?p=4550>

## Pages in use

| ID | Alias | Purpose |
|---|---|---|
| 1 | HOME | Mobile menu (5 cards) |
| 10 | MATERIAAL-AANVRAAG | Material request (placeholder) |
| 20 | RETOUR-AANVRAAG | Return request (placeholder) |
| 30 | TRANSFER-AANVRAAG | Transfer request (placeholder) |
| 40 | INSPECTIE | Inspection (placeholder) |
| 50 | MIJN-AANVRAGEN | My tickets data-list (page-of-rows pattern) |
| 9999 | LOGIN | Standard APEX login |

## SCAFF-specific gotchas

- View `V_MOBILE_MENU` uses `card_class = 'mobile-card mobile-card--X'`; `PKG_SCAFF_UI.get_mobile_menu` rewrites `mobile-card` → `scaff-card` at render time. Don't break this contract.
- Adding a card: see step 5 in `apex-26-mobile-cards`. Always increment `display_sequence` by 10.
