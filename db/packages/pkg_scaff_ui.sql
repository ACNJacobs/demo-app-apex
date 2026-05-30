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
  function get_po_list (
    p_prefix       in varchar2 default 'PO/',
    p_search       in varchar2 default null,
    p_target_page  in varchar2,
    p_target_item  in varchar2
  ) return clob;
  function get_po_pick_list (
    p_prefix    in varchar2 default 'PO/',
    p_search    in varchar2 default null,
    p_pick_item in varchar2,
    p_selected  in varchar2 default null
  ) return clob;
end PKG_SCAFF_UI;
/

create or replace package body PKG_SCAFF_UI
as

  function get_mobile_menu return clob
  is
    l_out clob;
    l_lang varchar2(10);

    procedure p( p_text in varchar2 ) is
    begin
      dbms_lob.writeappend(l_out, length(p_text), p_text);
    end;
  begin
    dbms_lob.createtemporary(l_out, true);
    
    -- Determine language preference
    l_lang := lower(nvl(v('P1_LANG'), nvl(apex_util.get_preference('FSP_LANGUAGE_PREFERENCE'), 
      nvl(apex_util.get_session_lang, 
        case 
          when owa_util.get_cgi_env('HTTP_ACCEPT_LANGUAGE') like 'nl%' then 'nl'
          when owa_util.get_cgi_env('HTTP_ACCEPT_LANGUAGE') like 'fr%' then 'fr'
          when owa_util.get_cgi_env('HTTP_ACCEPT_LANGUAGE') like 'en%' then 'en'
          else 'en'
        end
      )
    )));
    
    if l_lang not in ('nl','en','fr') then
      l_lang := 'en';
    end if;

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
        l_title    varchar2(4000) := apex_lang.message(p_name => r.title_key, p_lang => l_lang);
        l_subtitle varchar2(4000) := apex_lang.message(p_name => r.subtitle_key, p_lang => l_lang);
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
    l_head     varchar2(4000) := apex_lang.message(p_name => 'SCAFF.MENU.AANVRAGEN.TITLE');
    l_empty    varchar2(4000) := apex_lang.message(p_name => 'SCAFF.PAGE.AANVRAGEN.EMPTY');
    l_hold     varchar2(4000) := apex_lang.message(p_name => 'SCAFF.MY.HOLD');
    l_edit     varchar2(4000) := apex_lang.message(p_name => 'SCAFF.MR.LIST.EDIT');
    l_pause    varchar2(4000) := apex_lang.message(p_name => 'SCAFF.MR.LIST.HOLD');
    l_resume   varchar2(4000) := apex_lang.message(p_name => 'SCAFF.MR.LIST.RESUME');
    l_delete   varchar2(4000) := apex_lang.message(p_name => 'SCAFF.MR.LIST.DELETE');
    l_confirm  varchar2(4000) := apex_lang.message(p_name => 'SCAFF.MR.LIST.DELETE.CONFIRM');
    l_user     varchar2(200)  := lower(v('APP_USER'));
    l_count    pls_integer    := 0;
    l_edit_url varchar2(4000);

    procedure p( p_text in varchar2 ) is
    begin
      dbms_lob.writeappend(l_out, length(p_text), p_text);
    end;
  begin
    dbms_lob.createtemporary(l_out, true);

    p('<style id="scaff-mobile-css">');
    dbms_lob.append(l_out, HD_MOBILE_UI_PKG.get_menu_css);
    p('</style>');

    p('<div class="scaff-list" data-scaff-list="my-requests">');
    p('<div class="scaff-list__head">'||apex_escape.html(l_head)||'</div>');
    p('<div class="scaff-list__items">');

    for r in (
      select mr.request_id
           , mr.po_id
           , po.po_display
           , po.customer_name
           , po.city
           , to_char(mr.delivery_date,'DD-MON-YYYY','NLS_DATE_LANGUAGE=ENGLISH') as delivery_date
           , mr.delivery_hour
           , mr.hold_flag
           , coalesce(v.label_nl, mr.vervoer_code) as vervoer
           , to_char(mr.created_at,'YYYY-MM-DD HH24:MI') as created
        from scaff_material_request mr
        join scaff_po po on po.po_id = mr.po_id
        left join scaff_ref_vervoer v on v.code = mr.vervoer_code
       where lower(mr.created_by) = l_user
          or l_user in ('admin','app_data','nobody','apex_public_user')
       order by mr.created_at desc
       fetch first 50 rows only
    ) loop
      l_count := l_count + 1;
      l_edit_url := apex_util.prepare_url(
        'f?p='||apex_application.g_flow_id||':11:'||apex_application.g_instance
        ||'::NO::P11_REQUEST_ID,P11_PO_ID:'||r.request_id||','||r.po_id);

      p('<div class="scaff-list__item" data-request-id="'||r.request_id||'">');
      p('<span class="scaff-list__body">');
      p('<span class="scaff-list__title">'
        ||apex_escape.html(r.po_display)
        ||' &middot; '
        ||apex_escape.html(r.delivery_date||' '||r.delivery_hour)
        ||case when r.hold_flag = 'Y'
               then ' <span class="scaff-pill scaff-pill--hold">'
                    ||apex_escape.html(l_hold)||'</span>'
          end
        ||'</span>');
      p('<span class="scaff-list__sub">'||apex_escape.html(r.customer_name)||'</span>');
      p('<span class="scaff-list__meta">'
        ||apex_escape.html(r.vervoer)||' &middot; '
        ||apex_escape.html(r.city)||' &middot; '
        ||apex_escape.html(r.created)
        ||'</span>');
      p('<span class="scaff-list__actions">');
      p('<a class="scaff-list__btn scaff-list__btn--edit" href="'
        ||apex_escape.html_attribute(l_edit_url)||'">'
        ||'<span class="fa fa-pencil" aria-hidden="true"></span> '
        ||apex_escape.html(l_edit)||'</a>');
      p('<button type="button" class="scaff-list__btn scaff-list__btn--hold" '
        ||'data-scaff-action="toggle-hold" data-request-id="'||r.request_id||'">'
        ||case when r.hold_flag = 'Y'
               then '<span class="fa fa-play" aria-hidden="true"></span> '||apex_escape.html(l_resume)
               else '<span class="fa fa-pause" aria-hidden="true"></span> '||apex_escape.html(l_pause)
          end
        ||'</button>');
      p('<button type="button" class="scaff-list__btn scaff-list__btn--delete" '
        ||'data-scaff-action="delete" data-request-id="'||r.request_id||'" '
        ||'data-confirm="'||apex_escape.html_attribute(l_confirm)||'">'
        ||'<span class="fa fa-trash-o" aria-hidden="true"></span> '
        ||apex_escape.html(l_delete)||'</button>');
      p('</span>');
      p('</span>');
      p('</div>');
    end loop;

    p('</div>');

    if l_count = 0 then
      p('<div class="scaff-list__empty">'||apex_escape.html(l_empty)||'</div>');
    end if;

    p('</div>');
    return l_out;
  end get_my_requests;

  function get_po_list (
    p_prefix in varchar2 default 'PO/',
    p_search in varchar2 default null
  ) return clob
  is
  begin
    return get_po_list(p_prefix => p_prefix,
                       p_search => p_search,
                       p_target_page => '11',
                       p_target_item => 'P11_PO_ID');
  end get_po_list;

  function get_po_list (
    p_prefix       in varchar2 default 'PO/',
    p_search       in varchar2 default null,
    p_target_page  in varchar2,
    p_target_item  in varchar2
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
                    'f?p='||apex_application.g_flow_id||':'||p_target_page||':'||apex_application.g_instance
                    ||'::NO::'||p_target_item||':'||r.po_id);

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

  function get_po_pick_list (
    p_prefix    in varchar2 default 'PO/',
    p_search    in varchar2 default null,
    p_pick_item in varchar2,
    p_selected  in varchar2 default null
  ) return clob
  is
    l_out      clob;
    l_count    pls_integer := 0;
    l_empty    varchar2(4000) := apex_lang.message(p_name => 'SCAFF.MR.LIST.EMPTY');
    l_prefix   varchar2(20)   := nvl(p_prefix, 'PO/');
    l_search   varchar2(200)  := upper(trim(p_search));
    l_sel_id   number         := case when p_selected is not null and regexp_like(p_selected,'^[0-9]+$') then to_number(p_selected) end;

    procedure p( p_text in varchar2 ) is
    begin
      dbms_lob.writeappend(l_out, length(p_text), p_text);
    end;
  begin
    dbms_lob.createtemporary(l_out, true);

    p('<div class="scaff-list">');
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
      p('<a class="scaff-list__item scaff-list__item--pick'
        ||case when l_sel_id = r.po_id then ' is-selected' end
        ||'" href="#" '
        ||'data-scaff-pick="'||apex_escape.html_attribute(p_pick_item)||'" '
        ||'data-scaff-id="'||r.po_id||'">');
      p('<span class="scaff-list__check" aria-hidden="true">'
        ||'<span class="scaff-list__check-box"></span></span>');
      p('<span class="scaff-list__body">');
      p('<span class="scaff-list__title">'||apex_escape.html(r.po_display)||'</span>');
      p('<span class="scaff-list__sub">'||apex_escape.html(r.customer_name)||'</span>');
      p('<span class="scaff-list__meta">'
        ||apex_escape.html(r.address_line||' , '||r.postal_code||' '||r.city)
        ||'</span>');
      p('</span>');
      p('</a>');
    end loop;

    p('</div>');

    if l_count = 0 then
      p('<div class="scaff-list__empty">'||apex_escape.html(l_empty)||'</div>');
    end if;

    p('</div>');
    return l_out;
  end get_po_pick_list;

end PKG_SCAFF_UI;
/
