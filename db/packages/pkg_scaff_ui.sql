-- =============================================================================
-- PKG_SCAFF_UI  —  UI render helpers voor SCAFF APP
-- =============================================================================
-- get_mobile_menu : rendert 3 cards uit V_MOBILE_MENU met scaff-* classes.
--                   CSS NIET hier injecteren (region template stript <style>).
--                   In plaats daarvan in Page 1 Pre-Rendering proces:
--                     apex_css.add(HD_MOBILE_UI_PKG.get_menu_css);
-- =============================================================================
create or replace package PKG_SCAFF_UI
as
  function get_mobile_menu return clob;
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
      begin
        -- map CARD_CSS_CLASSES (mobile-card mobile-card--retour) → scaff-*
        l_classes := replace(replace(r.card_css_classes,
                       'mobile-card--', 'scaff-card--'),
                       'mobile-card',   'scaff-card');

        p('<a class="'||l_classes||'" href="'
          ||apex_escape.html_attribute(apex_util.prepare_url(r.card_link))
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

end PKG_SCAFF_UI;
/
