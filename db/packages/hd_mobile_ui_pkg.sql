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
  border-radius: 0;
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
.scaff-card--retour    { background-image: linear-gradient(135deg, #E2001A 0%, #C8001A 100%) !important; }
.scaff-card--transfer  { background-image: linear-gradient(135deg, #E2001A 0%, #A6001A 100%) !important; }
.scaff-card--inspectie { background-image: linear-gradient(135deg, #E2001A 0%, #8C0014 100%) !important; }
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
/* Placeholder pages (in opbouw) */
.scaff-placeholder {
  max-width: 480px;
  margin: 40px auto;
  padding: 24px;
  text-align: center;
  background: #FCE6E9;
  border-radius: 14px;
  box-shadow: 0 4px 10px rgba(178, 0, 21, 0.12);
}
.scaff-placeholder__text {
  font-size: 1.1rem;
  color: #B30015;
  margin: 0 0 20px 0;
}
.scaff-placeholder__back {
  display: inline-block;
  padding: 12px 22px;
  background: #E2001A;
  color: #FFFFFF !important;
  border-radius: 10px;
  text-decoration: none !important;
  font-weight: 600;
}
.scaff-placeholder__back:hover,
.scaff-placeholder__back:focus {
  background: #B30015;
}
.scaff-requests {
  width: 100%;
  border-collapse: collapse;
  background: #FFFFFF;
  border-radius: 14px;
  overflow: hidden;
  box-shadow: 0 4px 10px rgba(178, 0, 21, 0.12);
  font-size: 0.9rem;
  margin-bottom: 16px;
}
.scaff-requests thead {
  background: #E2001A;
  color: #FFFFFF;
}
.scaff-requests th,
.scaff-requests td {
  padding: 10px 12px;
  text-align: left;
  border-bottom: 1px solid #FCE6E9;
}
.scaff-requests tbody tr:hover {
  background: #FCE6E9;
}
.scaff-pill {
  display: inline-block;
  padding: 2px 10px;
  border-radius: 999px;
  font-size: 0.75rem;
  font-weight: 600;
  text-transform: uppercase;
  letter-spacing: 0.02em;
  background: #FCE6E9;
  color: #B30015;
}
.scaff-pill--open      { background: #E2001A; color: #FFFFFF; }
.scaff-pill--in_progress { background: #FFB300; color: #2A2A2A; }
.scaff-pill--waiting   { background: #FCE6E9; color: #B30015; }
.scaff-pill--closed    { background: #C9E7C9; color: #1B5E20; }

/* ---------- Generic search-list (PO picker, etc.) ---------- */
.scaff-list {
  max-width: 480px;
  margin: 0 auto;
  padding: 0 12px 24px;
  background: transparent;
  list-style: none;
}
.scaff-list__head {
  background: #4D4D4D;
  color: #FFFFFF;
  text-align: center;
  font-size: 1.05rem;
  font-weight: 600;
  padding: 12px;
  border-radius: 0;
  letter-spacing: .3px;
}
.scaff-list__filters {
  display: flex;
  gap: 8px;
  padding: 12px 0;
  align-items: stretch;
}
.scaff-list__filters .scaff-list__prefix {
  flex: 0 0 90px;
}
.scaff-list__filters .scaff-list__search {
  flex: 1 1 auto;
}
.scaff-list__items {
  background: #FFFFFF;
  border: 1px solid #E5E5E5;
  border-radius: 4px;
  overflow: hidden;
}
a.scaff-list__item,
.scaff-list__item {
  display: flex !important;
  flex-direction: row;
  align-items: center;
  padding: 12px 14px;
  border-bottom: 1px solid #EEEEEE;
  background: #FFFFFF;
  color: #2A2A2A !important;
  text-decoration: none !important;
  position: relative;
  border-left: 4px solid transparent;
  transition: background .15s ease, border-color .15s ease;
}
a.scaff-list__item:hover,
a.scaff-list__item:focus {
  background: #FAFAFA;
  border-left-color: #B30015;
  text-decoration: none !important;
}
.scaff-list__item--active {
  border-left-color: #1A1A66;
  font-weight: 600;
}
.scaff-list__item:last-child { border-bottom: 0; }
.scaff-list__body { flex: 1 1 auto; min-width: 0; }
.scaff-list__title {
  display: block;
  font-size: 1rem;
  font-weight: 600;
  color: #2A2A2A;
  margin: 0 0 2px 0;
  line-height: 1.2;
}
.scaff-list__sub {
  display: block;
  font-size: .9rem;
  color: #2A2A2A;
  line-height: 1.2;
  margin: 0 0 2px 0;
}
.scaff-list__meta {
  display: block;
  font-size: .8rem;
  color: #6E6E6E;
  line-height: 1.2;
}
.scaff-list__chevron {
  flex: 0 0 auto;
  color: #BDBDBD;
  font-size: 1.2rem;
  margin-left: 8px;
}
.scaff-list__empty {
  padding: 24px;
  text-align: center;
  color: #6E6E6E;
  background: #FFFFFF;
}

/* ---------- Generic section header (form sections) ---------- */
.scaff-section__head {
  background: #4D4D4D;
  color: #FFFFFF;
  text-align: center;
  padding: 10px;
  font-size: 1rem;
  font-weight: 600;
  margin: 16px 0 0 0;
}
.scaff-section__sub {
  text-align: center;
  padding: 8px 12px 4px;
  color: #2A2A2A;
  font-size: .95rem;
}
.scaff-section__sub strong { display: block; font-weight: 700; }

/* ---------- Row action buttons (Edit / Hold / Delete) ---------- */
.scaff-list__actions {
  display: flex;
  flex-wrap: wrap;
  gap: 6px;
  margin-top: 8px;
  justify-content: flex-end;
}
.scaff-list__btn {
  display: inline-flex;
  align-items: center;
  gap: 4px;
  min-height: 32px;
  padding: 4px 10px;
  font-size: .8rem;
  font-weight: 600;
  line-height: 1.1;
  border-radius: 4px;
  border: 1px solid #BDBDBD;
  background: #FFFFFF;
  color: #2A2A2A;
  cursor: pointer;
  text-decoration: none !important;
  transition: background .15s, border-color .15s, color .15s;
}
.scaff-list__btn:hover,
.scaff-list__btn:focus { background: #FAFAFA; border-color: #6E6E6E; }
.scaff-list__btn--edit:hover,
.scaff-list__btn--edit:focus { border-color: #B30015; color: #B30015; }
.scaff-list__btn--hold {
  border-color: #B30015;
  color: #B30015;
  background: #FCE6E9;
}
.scaff-list__btn--hold:hover,
.scaff-list__btn--hold:focus { background: #F7CFD5; }
.scaff-list__btn--delete {
  border-color: #B30015;
  color: #FFFFFF;
  background: #E2001A;
}
.scaff-list__btn--delete:hover,
.scaff-list__btn--delete:focus {
  background: #B30015;
  color: #FFFFFF !important;
}
.scaff-list__btn[disabled] { opacity: .55; cursor: not-allowed; }
~';
    return l_css;
  end get_menu_css;

end HD_MOBILE_UI_PKG;
/
