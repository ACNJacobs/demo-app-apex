-- =============================================================================
-- PKG_SCAFF_UI  —  UI render helpers voor SCAFF APP
-- =============================================================================
set define off
-- get_mobile_menu : rendert 3 cards uit V_MOBILE_MENU met scaff-* classes.
--                   CSS NIET hier injecteren (region template stript <style>).
--                   In plaats daarvan in Page 1 Pre-Rendering proces:
--                     apex_css.add(HD_MOBILE_UI_PKG.get_menu_css);
-- =============================================================================
create or replace package PKG_SCAFF_UI
as
  function get_mobile_menu return clob;
  function get_placeholder return clob;
  function get_my_requests return clob;
  function get_po_list (
    p_prefix in varchar2 default 'PO/',
    p_search in varchar2 default null
  ) return clob;
end PKG_SCAFF_UI;
/

create or replace package body PKG_SCAFF_UI
as

  function get_mobile_menu return clob
  is
    l_out clob;

    procedure p( p_text in varchar2 ) is
    begin
      dbms_lob.writeappend(l_out, length(p_text), p_text);
    end;
  begin
    dbms_lob.createtemporary(l_out, true);

    -- 1. Inject CSS in-line (eigen class names, geen conflict met UT)
    p('<style id="scaff-mobile-css">');
    dbms_lob.append(l_out, HD_MOBILE_UI_PKG.get_menu_css);
    p('</style>');

    -- 2. Cards grid
    p('<div class="scaff-menu">');

    for r in (
      select card_id, title_key, subtitle_key, card_icon, card_link, card_css_classes
        from V_MOBILE_MENU
       order by display_sequence
    ) loop
      declare
        l_title    varchar2(4000) := apex_lang.message(p_name => r.title_key);
        l_subtitle varchar2(4000) := apex_lang.message(p_name => r.subtitle_key);
        l_classes  varchar2(200);
        l_link     varchar2(4000) := r.card_link;
      begin
        -- substitute APEX tokens (dynamicContent regions don't auto-substitute)
        l_link := replace(l_link, '&'||'APP_ID.',      to_char(apex_application.g_flow_id));
        l_link := replace(l_link, '&'||'APP_SESSION.', to_char(apex_application.g_instance));
        l_link := replace(l_link, '&'||'DEBUG.',       nvl(v('DEBUG'),'NO'));

        -- map CARD_CSS_CLASSES (mobile-card mobile-card--retour) → scaff-*
        l_classes := replace(replace(r.card_css_classes,
                       'mobile-card--', 'scaff-card--'),
                       'mobile-card',   'scaff-card');

        p('<a class="'||l_classes||'" href="'
          ||apex_escape.html_attribute(apex_util.prepare_url(l_link))
          ||'" aria-label="'||apex_escape.html_attribute(l_title)||'">');

        p('<span class="scaff-card__icon"><span class="fa '
          ||apex_escape.html_attribute(r.card_icon)||'" aria-hidden="true"></span></span>');

        p('<span class="scaff-card__body">');
        p('<span class="scaff-card__title">'||apex_escape.html(l_title)||'</span>');
        if l_subtitle is not null then
          p('<span class="scaff-card__desc">'||apex_escape.html(l_subtitle)||'</span>');
        end if;
        p('</span>');

        p('</a>');
      end;
    end loop;

    p('</div>');

    return l_out;
  end get_mobile_menu;

  function get_placeholder return clob
  is
    l_out      clob;
    l_text     varchar2(4000) := apex_lang.message(p_name => 'SCAFF.PAGE.INPROGRESS.TEXT');
    l_back     varchar2(4000) := apex_lang.message(p_name => 'SCAFF.PAGE.BACK');
    l_home_url varchar2(4000) := apex_util.prepare_url(
      'f?p='||apex_application.g_flow_id||':1:'||apex_application.g_instance);
  begin
    dbms_lob.createtemporary(l_out, true);
    dbms_lob.writeappend(l_out, length('<style id="scaff-mobile-css">'), '<style id="scaff-mobile-css">');
    dbms_lob.append(l_out, HD_MOBILE_UI_PKG.get_menu_css);
    dbms_lob.writeappend(l_out, length('</style>'), '</style>');

    return l_out
        || '<div class="scaff-placeholder">'
        || '<p class="scaff-placeholder__text">'||apex_escape.html(l_text)||'</p>'
        || '<a class="scaff-placeholder__back" href="'
             ||apex_escape.html_attribute(l_home_url)||'">'
             ||apex_escape.html(l_back)||'</a>'
        || '</div>';
  end get_placeholder;

  function get_my_requests return clob
  is
    l_out      clob;
    l_back     varchar2(4000) := apex_lang.message(p_name => 'SCAFF.PAGE.BACK');
    l_home_url varchar2(4000) := apex_util.prepare_url(
      'f?p='||apex_application.g_flow_id||':1:'||apex_application.g_instance);
    l_empty    varchar2(4000) := apex_lang.message(p_name => 'SCAFF.PAGE.AANVRAGEN.EMPTY');
    l_h_id     varchar2(4000) := apex_lang.message(p_name => 'SCAFF.PAGE.AANVRAGEN.COL.ID');
    l_h_title  varchar2(4000) := apex_lang.message(p_name => 'SCAFF.PAGE.AANVRAGEN.COL.TITLE');
    l_h_stat   varchar2(4000) := apex_lang.message(p_name => 'SCAFF.PAGE.AANVRAGEN.COL.STATUS');
    l_h_prio   varchar2(4000) := apex_lang.message(p_name => 'SCAFF.PAGE.AANVRAGEN.COL.PRIORITY');
    l_h_when   varchar2(4000) := apex_lang.message(p_name => 'SCAFF.PAGE.AANVRAGEN.COL.CREATED');
    l_count    pls_integer    := 0;

    procedure p( p_text in varchar2 ) is
    begin
      dbms_lob.writeappend(l_out, length(p_text), p_text);
    end;
  begin
    dbms_lob.createtemporary(l_out, true);

    p('<style id="scaff-mobile-css">');
    dbms_lob.append(l_out, HD_MOBILE_UI_PKG.get_menu_css);
    p('</style>');

    p('<div class="scaff-menu">');
    p('<table class="scaff-requests">');
    p('<thead><tr>');
    p('<th>'||apex_escape.html(l_h_id)||'</th>');
    p('<th>'||apex_escape.html(l_h_title)||'</th>');
    p('<th>'||apex_escape.html(l_h_stat)||'</th>');
    p('<th>'||apex_escape.html(l_h_prio)||'</th>');
    p('<th>'||apex_escape.html(l_h_when)||'</th>');
    p('</tr></thead><tbody>');

    for r in (
      select t.id
           , t.title
           , t.status
           , t.priority
           , to_char(t.created_at,'YYYY-MM-DD') created
        from hd_tickets t
        left join hd_users u on u.id = t.created_by
       where lower(coalesce(u.username,'x')) = lower(v('APP_USER'))
          or v('APP_USER') in ('ADMIN','APP_DATA','nobody','APEX_PUBLIC_USER')
       order by t.created_at desc
       fetch first 50 rows only
    ) loop
      l_count := l_count + 1;
      p('<tr class="scaff-requests__row scaff-requests__row--'||lower(r.status)||'">');
      p('<td>'||r.id||'</td>');
      p('<td>'||apex_escape.html(r.title)||'</td>');
      p('<td><span class="scaff-pill scaff-pill--'||lower(r.status)||'">'||apex_escape.html(r.status)||'</span></td>');
      p('<td>'||apex_escape.html(r.priority)||'</td>');
      p('<td>'||r.created||'</td>');
      p('</tr>');
    end loop;

    p('</tbody></table>');

    if l_count = 0 then
      p('<p class="scaff-placeholder__text">'||apex_escape.html(l_empty)||'</p>');
    end if;

    p('<a class="scaff-placeholder__back" href="'
      ||apex_escape.html_attribute(l_home_url)||'">'
      ||apex_escape.html(l_back)||'</a>');

    p('</div>');
    return l_out;
  end get_my_requests;

  function get_po_list (
    p_prefix in varchar2 default 'PO/',
    p_search in varchar2 default null
  ) return clob
  is
    l_out      clob;
    l_count    pls_integer := 0;
    l_empty    varchar2(4000) := apex_lang.message(p_name => 'SCAFF.MR.LIST.EMPTY');
    l_head     varchar2(4000) := apex_lang.message(p_name => 'SCAFF.MR.LIST.HEAD');
    l_prefix   varchar2(20)   := nvl(p_prefix, 'PO/');
    l_search   varchar2(200)  := upper(trim(p_search));
    l_target   varchar2(4000);

    procedure p( p_text in varchar2 ) is
    begin
      dbms_lob.writeappend(l_out, length(p_text), p_text);
    end;
  begin
    dbms_lob.createtemporary(l_out, true);

    p('<style id="scaff-mobile-css">');
    dbms_lob.append(l_out, HD_MOBILE_UI_PKG.get_menu_css);
    p('</style>');

    p('<div class="scaff-list">');
    p('<div class="scaff-list__head">'||apex_escape.html(l_head)||'</div>');
    p('<div class="scaff-list__items">');

    for r in (
      select po_id, po_display, customer_name, address_line, postal_code, city
        from scaff_po
       where po_prefix = l_prefix
         and (l_search is null
              or upper(po_number)     like '%'||l_search||'%'
              or upper(customer_name) like '%'||l_search||'%'
              or upper(city)          like '%'||l_search||'%'
              or upper(address_line)  like '%'||l_search||'%')
       order by po_number
       fetch first 50 rows only
    ) loop
      l_count := l_count + 1;
      l_target := apex_util.prepare_url(
                    'f?p='||apex_application.g_flow_id||':11:'||apex_application.g_instance
                    ||'::NO::P11_PO_ID:'||r.po_id);

      p('<a class="scaff-list__item'
        ||case when l_count=1 then ' scaff-list__item--active' end
        ||'" href="'||apex_escape.html_attribute(l_target)||'">');
      p('<span class="scaff-list__body">');
      p('<span class="scaff-list__title">'||apex_escape.html(r.po_display)||'</span>');
      p('<span class="scaff-list__sub">'||apex_escape.html(r.customer_name)||'</span>');
      p('<span class="scaff-list__meta">'
        ||apex_escape.html(r.address_line||' , '||r.postal_code||' '||r.city)
        ||'</span>');
      p('</span>');
      p('<span class="scaff-list__chevron" aria-hidden="true">&rsaquo;</span>');
      p('</a>');
    end loop;

    p('</div>');

    if l_count = 0 then
      p('<div class="scaff-list__empty">'||apex_escape.html(l_empty)||'</div>');
    end if;

    p('</div>');
    return l_out;
  end get_po_list;

end PKG_SCAFF_UI;
/
