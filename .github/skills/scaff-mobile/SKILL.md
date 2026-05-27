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
