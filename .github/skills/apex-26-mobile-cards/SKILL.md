---
name: apex-26-mobile-cards
description: Generic mobile-first card menu pattern for any Oracle APEX 26.1 app — driver-view + UI package + CSS helper + messages triplet. Use when adding/editing menu cards, dashboard tiles, or list-of-actions pages in any app. App-specific BEM prefix, palette, and key prefix come from the app's overlay skill.
---

# Mobile Card Menu Pattern (app-agnostic)

## When to use

User wants:
- a home/dashboard page with tappable tiles
- a "5e card" / "extra menu item"
- a list of actions on mobile (full-bleed coloured cards)
- a list-of-rows page (status pills, table) — see "Data-list variant"

This pattern works in **any** APEX app. Substitute placeholders `<APP>`, `<app>`, `<prefix>`, `<PREFIX>` per the app's overlay skill (e.g. SCAFF → `scaff`/`SCAFF`).

## Four-layer architecture

| Layer | Artifact | Purpose |
|---|---|---|
| **Data** | View `V_<PREFIX>_MENU` (`db/views/v_<prefix>_menu.sql`) | One row per card. Columns: `card_id`, `display_sequence`, `card_title_key`, `card_subtitle_key`, `card_icon`, `card_link`, `card_class` |
| **HTML** | `PKG_<PREFIX>_UI.get_menu` (`db/packages/pkg_<prefix>_ui.sql`) | Loops view → renders anchors with `apex_lang.message` titles, FA icons, sub-stituted hrefs |
| **CSS**  | `HD_<PREFIX>_UI_PKG.get_css` (`db/packages/hd_<prefix>_ui_pkg.sql`) | All `.<prefix>-*` rules, returned as one CLOB and inlined in `<style>` |
| **Text** | `<APP>.MENU.<CODE>.TITLE` / `.SUBTITLE` (NL + EN) in `messages.apx` | All labels translated |

Region in `pages/p00001-home.apx`:

```
region <code> (
    template: @/blank-with-attributes-no-grid
    type: dynamicContent
    source {
        plsqlFunctionBody: return PKG_<PREFIX>_UI.get_menu;
    }
)
```

## BEM class contract (rename `<prefix>` per app)

```
<prefix>-menu                  ← container, flex column, max-width 480px, centered
<prefix>-card                  ← single tile, themed bg, white text, 96px min-height, radius 14px
<prefix>-card--<variant>       ← variant per card (own gradient/colour)
<prefix>-card__icon            ← 56×56 white circle with FontAwesome glyph
<prefix>-card__body            ← title + desc wrapper
<prefix>-card__title           ← 1.2rem bold
<prefix>-card__desc            ← 0.85rem opacity 0.85
```

All rules use `!important` to override Universal Theme defaults.

## Driver view template

```sql
create or replace view v_<prefix>_menu as
  select 1 as card_id, 10 as display_sequence,
         '<APP>.MENU.HOME.TITLE'      as card_title_key,
         '<APP>.MENU.HOME.SUBTITLE'   as card_subtitle_key,
         'fa-home'                    as card_icon,
         'f?p=&APP_ID.:10:&APP_SESSION.::&DEBUG.:::' as card_link,
         'mobile-card mobile-card--home' as card_class
    from dual
union all
  select 2, 20, '<APP>.MENU.NEW.TITLE', '<APP>.MENU.NEW.SUBTITLE',
         'fa-plus', 'f?p=&APP_ID.:20:&APP_SESSION.::&DEBUG.:::',
         'mobile-card mobile-card--new' from dual
-- … add more rows ascending by display_sequence
;
```

> Note `card_class` uses generic `mobile-card mobile-card--X`. The UI package rewrites that to `<prefix>-card <prefix>-card--X` at render time so the view is reusable.

## UI package template

```sql
create or replace package body pkg_<prefix>_ui as
  function get_menu return clob is
    l_out  clob;
    l_link varchar2(4000);
    l_cls  varchar2(4000);
  begin
    dbms_lob.createtemporary(l_out, true);
    apex_string.push(l_out, '<style>'||hd_<prefix>_ui_pkg.get_css||'</style>');
    apex_string.push(l_out, '<div class="<prefix>-menu">');

    for r in (select * from v_<prefix>_menu order by display_sequence) loop
      -- CRITICAL: substitute &APP_ID. / &APP_SESSION. / &DEBUG. IN PL/SQL
      l_link := r.card_link;
      l_link := replace(l_link, '&'||'APP_ID.',      to_char(apex_application.g_flow_id));
      l_link := replace(l_link, '&'||'APP_SESSION.', to_char(apex_application.g_instance));
      l_link := replace(l_link, '&'||'DEBUG.',       nvl(v('DEBUG'),'NO'));
      l_link := apex_util.prepare_url(l_link);

      l_cls := replace(r.card_class, 'mobile-card', '<prefix>-card');

      apex_string.push(l_out,
        '<a class="'|| l_cls ||'" href="'|| l_link ||'">'
        || '<div class="<prefix>-card__icon"><i class="fa '|| apex_escape.html(r.card_icon) ||'"></i></div>'
        || '<div class="<prefix>-card__body">'
        || '<div class="<prefix>-card__title">'|| apex_escape.html(apex_lang.message(r.card_title_key))    ||'</div>'
        || '<div class="<prefix>-card__desc">' || apex_escape.html(apex_lang.message(r.card_subtitle_key)) ||'</div>'
        || '</div></a>');
    end loop;

    apex_string.push(l_out, '</div>');
    return l_out;
  end;
end;
/
```

## CSS helper template (sketch)

```sql
create or replace package body hd_<prefix>_ui_pkg as
  function get_css return clob is begin return q'[
    .<prefix>-menu  { display:flex; flex-direction:column; gap:12px;
                       max-width:480px; margin:16px auto; padding:0 16px; }
    .<prefix>-card  { display:flex; align-items:center; gap:14px;
                       min-height:96px; padding:14px 18px;
                       border-radius:14px !important;
                       background:<primary> !important;
                       color:#fff !important; text-decoration:none !important; }
    .<prefix>-card__icon { width:56px; height:56px; border-radius:50%;
                            background:rgba(255,255,255,0.18); display:grid; place-items:center; }
    .<prefix>-card__title { font-size:1.2rem; font-weight:700; }
    .<prefix>-card__desc  { font-size:0.85rem; opacity:0.85; }
  ]'; end;
end;
/
```

Replace `<primary>` with the app's palette (overlay skill).

## Add a new card — 5 steps

1. **Insert row in `V_<PREFIX>_MENU`** (new `card_id`, `display_sequence`, message keys, icon, link, class variant).
2. **Add 2 messages** to `messages.apx` (NL + EN) for `.TITLE` and `.SUBTITLE`.
3. **Add CSS variant** in `HD_<PREFIX>_UI_PKG.get_css` if the card needs unique colour.
4. **Re-compile** view + packages.
5. **No APEX change needed** — `dynamicContent` re-renders on next page load. Hard-refresh mobile viewport.

## Data-list variant (page-of-rows pattern)

For "Mijn aanvragen / My tickets" style list pages — DO NOT use APEXlang `classicReport` (parser is strict). Use the same dynamicContent + PL/SQL CLOB pattern, but render a `<table>` with status pills:

```sql
function get_my_requests return clob is
  l_out clob;
  l_home varchar2(4000) := apex_util.prepare_url(
     'f?p='||apex_application.g_flow_id||':1:'||apex_application.g_instance);
begin
  dbms_lob.createtemporary(l_out, true);
  apex_string.push(l_out, '<style>'||hd_<prefix>_ui_pkg.get_css||'</style>');
  apex_string.push(l_out, '<table class="<prefix>-requests"><thead><tr>'
    || '<th>'|| apex_escape.html(apex_lang.message('<APP>.PAGE.LIST.COL.ID')) ||'</th>'
    || '<th>'|| apex_escape.html(apex_lang.message('<APP>.PAGE.LIST.COL.TITLE')) ||'</th>'
    || '<th>'|| apex_escape.html(apex_lang.message('<APP>.PAGE.LIST.COL.STATUS')) ||'</th>'
    || '</tr></thead><tbody>');

  for r in ( select id, title, status from <table>
              where lower(coalesce(owner_username,'x')) = lower(v('APP_USER'))
                 or v('APP_USER') in ('ADMIN','APP_DATA','nobody','APEX_PUBLIC_USER')
              order by created_at desc fetch first 50 rows only ) loop
    apex_string.push(l_out, '<tr><td>'|| r.id ||'</td>'
      || '<td>'|| apex_escape.html(r.title) ||'</td>'
      || '<td><span class="<prefix>-pill <prefix>-pill--'|| apex_escape.html(r.status) ||'">'
      || apex_escape.html(r.status) ||'</span></td></tr>');
  end loop;

  apex_string.push(l_out, '</tbody></table>'
    || '<a class="<prefix>-back" href="'|| l_home ||'">&larr; Home</a>');
  return l_out;
end;
/
```

Status pill BEM:
```
<prefix>-requests              ← <table> wrapper, themed header, white body
<prefix>-requests__row         ← <tr>, optional --<status> modifier
<prefix>-pill                  ← <span> badge
<prefix>-pill--open            ← primary bg
<prefix>-pill--in_progress     ← amber
<prefix>-pill--waiting         ← soft accent
<prefix>-pill--closed          ← green
```

## Forbidden

- ❌ Generic class names `.card`, `.menu`, `.button` — they collide with Universal Theme.
- ❌ Inline colour codes in PL/SQL — colours live only in `HD_<PREFIX>_UI_PKG.get_css`.
- ❌ Hardcoded labels — always `apex_lang.message('<APP>.MENU.<CODE>.TITLE')`.
- ❌ Hero template / `region_image` attribute — causes the "rocket icon" bug.
- ❌ Raw `&APP_ID.` in returned CLOB — see `apex-26-patterns` gotcha #1.
- ❌ APEXlang `classicReport` for ad-hoc lists — see `apex-26-patterns` gotcha #2.
