---
name: scaff-mobile
description: Mobile-first card layout pattern for the SCAFF APP using BEM class prefix scaff-*, Altrad red palette, and the PKG_SCAFF_UI + V_MOBILE_MENU pair. Use when adding/editing menu cards, action buttons, or any mobile dashboard tile.
---

# SCAFF Mobile Card Pattern

## Building Blocks

| Layer | Artifact |
|---|---|
| Data | view `V_MOBILE_MENU` (`db/views/v_mobile_menu.sql`) — one row per card |
| HTML | function `PKG_SCAFF_UI.get_mobile_menu` (`db/packages/pkg_scaff_ui.sql`) — anchors + inline `<style>` |
| CSS | function `HD_MOBILE_UI_PKG.get_css` (`db/packages/hd_mobile_ui_pkg.sql`) — `.scaff-*` rules |
| Text | messages `SCAFF.MENU.*.TITLE` / `.SUBTITLE` (NL + EN) |
| Region | `region scaff-app` in `pages/p00001-home.apx`, type `dynamicContent`, template `@/blank-with-attributes-no-grid` |

## BEM Class Contract

```
scaff-menu                       ← container, flex column, max-width 480px, centered
scaff-card                       ← single tile, red bg, white text, 96px min-height, radius 14px
scaff-card--materiaal            ← variant for material request
scaff-card--retour               ← variant, gradient 135deg #E2001A → #C8001A
scaff-card--transfer             ← variant, gradient 135deg #E2001A → #A6001A
scaff-card__icon                 ← 56×56 white circle with FontAwesome glyph
scaff-card__body                 ← title + desc wrapper
scaff-card__title                ← 1.2rem bold white
scaff-card__desc                 ← 0.85rem opacity 0.85
```

All rules use `!important` to override APEX Universal Theme defaults.

## Adding a New Card

1. **Insert row in `V_MOBILE_MENU`** with new `code`, `seq`, message keys, FA icon, target page, BEM class.
2. **Seed messages** (NL + EN) via `db/i18n/messages_nl.sql` + `messages_en.sql`, run `HD_I18N_INSTALL.seed_…`.
3. **Add CSS variant** in `HD_MOBILE_UI_PKG.get_css` if it needs unique styling.
4. **Re-compile** packages (see `db/packages/*.sql` headers).
5. **No APEX edit needed** — the dynamic region re-renders on next page load.
6. **Hard refresh** (Ctrl+Shift+R) in mobile viewport to verify.

## Visual Spec

| Property | Value |
|---|---|
| Primary | `#E2001A` |
| Dark | `#B30015` |
| Soft | `#FCE6E9` |
| Card radius | `14px` |
| Card min-height | `96px` |
| Icon circle | `56×56`, `rgba(255,255,255,0.18)` bg |
| Menu max-width | `480px` (mobile-first, centered on tablet/desktop) |
| Font | inherited Universal Theme |
| Tap target | full card is `<a>` — entire surface clickable |

## Forbidden in This Pattern

- Generic class names like `.card`, `.menu`, `.button` — they collide with Universal Theme.
- Inline color codes in PL/SQL — colors only live in `HD_MOBILE_UI_PKG.get_css`.
- Hardcoded card labels — always `apex_lang.message('SCAFF.MENU.<CODE>.TITLE')`.
- Hero template / `region_image` attribute — caused the "rocket icon" bug.
- Raw `&APP_ID.` / `&APP_SESSION.` / `&DEBUG.` in CLOB returned from a `dynamicContent` region — APEX does NOT substitute these in PL/SQL output. Always substitute IN PL/SQL before `apex_util.prepare_url`:
  ```sql
  l_link := replace(r.card_link, '&'||'APP_ID.',      to_char(apex_application.g_flow_id));
  l_link := replace(l_link,      '&'||'APP_SESSION.', to_char(apex_application.g_instance));
  l_link := replace(l_link,      '&'||'DEBUG.',       nvl(v('DEBUG'),'NO'));
  ```
  Symptom of forgetting: clicking the card opens `f?p=&APP_ID.:50:::&DEBUG.:::` and APEX shows the "Application not found" blue dialog.

## Data-list Region Variant (page 50 pattern)

For showing a list of rows (e.g. `HD_TICKETS`), DO NOT use APEXlang `classicReport` — it is strict (rejects `sqlQuery`, requires `tableName` + `column` children + `template`). Instead reuse the dynamicContent + PL/SQL CLOB pattern:

```sql
function get_my_requests return clob is
  l_out clob;
  -- substitute tokens for back link
  l_home_url varchar2(4000) := apex_util.prepare_url(
    'f?p='||apex_application.g_flow_id||':1:'||apex_application.g_instance);
begin
  ...
  for r in ( select ... from hd_tickets t left join hd_users u on u.id=t.created_by
              where lower(coalesce(u.username,'x')) = lower(v('APP_USER'))
                 or v('APP_USER') in ('ADMIN','APP_DATA','nobody','APEX_PUBLIC_USER')
              order by t.created_at desc fetch first 50 rows only ) loop
     -- render <tr> with <span class="scaff-pill scaff-pill--<status>">
  end loop;
end;
```

Status pill BEM contract:
```
scaff-requests                ← <table> wrapper, red header, white body
scaff-requests__row           ← <tr>, optional --<status> modifier
scaff-pill                    ← <span> badge
scaff-pill--open              ← red bg, white text
scaff-pill--in_progress       ← amber bg
scaff-pill--waiting           ← soft pink
scaff-pill--closed            ← green
```
