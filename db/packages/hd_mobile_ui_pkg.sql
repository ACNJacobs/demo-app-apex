-- =============================================================================
-- HD_MOBILE_UI_PKG  —  Custom CSS voor mobiel startmenu (Altrad rood)
-- =============================================================================
-- Inject via Pre-Rendering proces:
--   apex_css.add(p_css => HD_MOBILE_UI_PKG.get_menu_css);
-- Class-namen: scaff-menu / scaff-card (geen Universal Theme conflict).
-- =============================================================================
create or replace package HD_MOBILE_UI_PKG
as
  c_altrad_red       constant varchar2(7) := '#E2001A';
  c_altrad_red_dark  constant varchar2(7) := '#B30015';
  c_altrad_red_soft  constant varchar2(7) := '#FCE6E9';

  function get_menu_css return clob;
end HD_MOBILE_UI_PKG;
/

create or replace package body HD_MOBILE_UI_PKG
as

  function get_menu_css return clob
  is
    l_css clob;
  begin
    l_css :=
q'~
/* Mobile-first: cards stacked, gecentreerd met max-width zodat het er
   ook op desktop nog uitziet als mobiele app (geen full-width strepen). */
.scaff-menu {
  display: flex;
  flex-direction: column;
  gap: 14px;
  padding: 16px;
  margin: 0 auto;
  max-width: 480px;
  width: 100%;
  box-sizing: border-box;
  list-style: none;
}
a.scaff-card,
.scaff-card {
  display: flex !important;
  flex-direction: row !important;
  align-items: center;
  gap: 16px;
  padding: 18px 20px;
  min-height: 96px;
  width: 100%;
  box-sizing: border-box;
  background: #E2001A !important;
  background-image: none !important;
  color: #FFFFFF !important;
  border-radius: 14px;
  text-decoration: none !important;
  box-shadow: 0 6px 14px rgba(178, 0, 21, 0.25);
  transition: transform .15s ease, box-shadow .15s ease, background .15s ease;
}
a.scaff-card:hover,
a.scaff-card:focus,
.scaff-card:hover,
.scaff-card:focus {
  background: #B30015 !important;
  color: #FFFFFF !important;
  transform: translateY(-2px);
  box-shadow: 0 10px 22px rgba(178, 0, 21, 0.35);
  text-decoration: none !important;
}
.scaff-card--retour   { background-image: linear-gradient(135deg, #E2001A 0%, #C8001A 100%) !important; }
.scaff-card--transfer { background-image: linear-gradient(135deg, #E2001A 0%, #A6001A 100%) !important; }
.scaff-card__icon {
  flex: 0 0 auto;
  width: 56px;
  height: 56px;
  border-radius: 50%;
  background: #FFFFFF;
  display: inline-flex;
  align-items: center;
  justify-content: center;
}
.scaff-card__icon .fa {
  color: #E2001A;
  font-size: 1.6rem;
}
.scaff-card__body { flex: 1 1 auto; min-width: 0; }
.scaff-card__title {
  display: block;
  font-size: 1.2rem;
  font-weight: 700;
  letter-spacing: .2px;
  color: #FFFFFF;
  margin: 0 0 4px 0;
  line-height: 1.2;
}
.scaff-card__desc {
  display: block;
  font-size: .9rem;
  color: #FFFFFF;
  opacity: .92;
  margin: 0;
  line-height: 1.3;
}
~';
    return l_css;
  end get_menu_css;

end HD_MOBILE_UI_PKG;
/
