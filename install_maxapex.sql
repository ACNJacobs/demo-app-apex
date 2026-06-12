set define off
set serveroutput on size unlimited
prompt === STARTING SCAFF APP DATABASE INSTALL ===
prompt === db/install/10_scaff_material_request_schema.sql ===
-- =============================================================================
-- SCAFF — material-request schema (PO list + form header + LOVs)
-- =============================================================================
-- Veilig herinstalleerbaar: drops first, then create + seed.
-- Run as APP_DATA.
-- =============================================================================

set define off
set serveroutput on size unlimited

prompt === drop existing (ignore errors) ===
begin
  for r in (select table_name from user_tables
             where table_name in ('SCAFF_MATERIAL_REQUEST',
                                  'SCAFF_PO',
                                  'SCAFF_REF_VERVOER',
                                  'SCAFF_REF_LADER'))
  loop
    execute immediate 'drop table '||r.table_name||' cascade constraints purge';
  end loop;
end;
/

prompt === PO ===
create table SCAFF_PO (
  po_id           number generated always as identity primary key,
  po_prefix       varchar2(10 char) not null,          -- 'PO/', 'IO/', 'PO/N'
  po_number       varchar2(20 char) not null,          -- '31719'
  po_display      varchar2(40 char) generated always as (po_prefix || po_number) virtual,
  customer_name   varchar2(200 char) not null,
  address_line    varchar2(200 char),
  postal_code     varchar2(20 char),
  city            varchar2(100 char),
  constraint scaff_po_uk unique (po_prefix, po_number)
);

create index scaff_po_search_ix on scaff_po (upper(customer_name));

prompt === Vervoer LOV ===
create table SCAFF_REF_VERVOER (
  code         varchar2(20 char) primary key,
  label_nl     varchar2(100 char) not null,
  label_en     varchar2(100 char) not null,
  sort_seq     number default 10
);

prompt === Lader LOV ===
create table SCAFF_REF_LADER (
  code         varchar2(20 char) primary key,
  label_nl     varchar2(100 char) not null,
  label_en     varchar2(100 char) not null,
  sort_seq     number default 10
);

prompt === Material request header ===
create table SCAFF_MATERIAL_REQUEST (
  request_id      number generated always as identity primary key,
  po_id           number not null references scaff_po(po_id),
  contact_name    varchar2(200 char),
  site_manager    varchar2(200 char),
  gsm             varchar2(50 char)  not null,
  vervoer_code    varchar2(20 char)  not null references scaff_ref_vervoer(code),
  lader_code      varchar2(20 char)  not null references scaff_ref_lader(code),
  delivery_date   date               not null,
  delivery_hour   varchar2(5 char)   default '07:00',
  hold_flag       varchar2(1 char)   default 'N' check (hold_flag in ('Y','N')),
  remark          varchar2(4000 char),
  created_by      varchar2(100 char) default nvl(sys_context('apex$session','app_user'), user),
  created_at      timestamp          default systimestamp
);

prompt === seed PO ===
insert into scaff_po (po_prefix, po_number, customer_name, address_line, postal_code, city) values ('PO/', '31719', 'SCAFF - Everzinc Angleur',            'Rue de Chen'||unistr('\00E9')||'e 53/1',         '4031', 'ANGLEUR');
insert into scaff_po (po_prefix, po_number, customer_name, address_line, postal_code, city) values ('PO/', '31723', 'SCAFF - Umicore Olen WKK',            'Watertorenstraat 33',            '2250', 'OLEN');
insert into scaff_po (po_prefix, po_number, customer_name, address_line, postal_code, city) values ('PO/', '31742', 'SCAFF - Mac'||unistr('\00B2')||' Antwerpen',     'Blauwe Weg 7 Haven 261',         '2030', 'ANTWERPEN');
insert into scaff_po (po_prefix, po_number, customer_name, address_line, postal_code, city) values ('PO/', '31762', 'SCAFF - ArcelorMittal Kessales Seraing','Rue Gustave Baivy 1',           '4101', 'Seraing');
insert into scaff_po (po_prefix, po_number, customer_name, address_line, postal_code, city) values ('PO/', '31770', 'SCAFF - Antwerp Euroterminal Verrebroek','Blikken 1333 Kaai 1333',       '9130', 'VERREBROEK');
insert into scaff_po (po_prefix, po_number, customer_name, address_line, postal_code, city) values ('PO/', '31796', 'SCAFF - Ch'||unistr('\00E2')||'teau de Jehay Amay','Rue du Parc 1',                 '4540', 'AMAY');
insert into scaff_po (po_prefix, po_number, customer_name, address_line, postal_code, city) values ('PO/', '31803', 'SCAFF - Recyfuel Engis',              'Rue du Parc Industriel Zoning Industriel d''Ehein', '4480', 'ENGIS');
insert into scaff_po (po_prefix, po_number, customer_name, address_line, postal_code, city) values ('PO/', '31818', 'SCAFF - Prayon Engis',                'Rue Joseph Wauters 144',         '4480', 'ENGIS');
insert into scaff_po (po_prefix, po_number, customer_name, address_line, postal_code, city) values ('PO/', '31847', 'SCAFF - Solvay Jemeppe',              'Rue Solvay 1',                   '5190', 'JEMEPPE-SUR-SAMBRE');
insert into scaff_po (po_prefix, po_number, customer_name, address_line, postal_code, city) values ('IO/', '00045', 'SCAFF - Intern depot Antwerpen',      'Kruibekesteenweg 50',            '9120', 'BEVEREN');
insert into scaff_po (po_prefix, po_number, customer_name, address_line, postal_code, city) values ('IO/', '00046', 'SCAFF - Intern depot Luik',           'Rue de l''Industrie 12',         '4000', 'LIEGE');
insert into scaff_po (po_prefix, po_number, customer_name, address_line, postal_code, city) values ('PO/N','00012', 'SCAFF - Nieuwe klant Gent',           'Wondelgemkaai 100',              '9000', 'GENT');

prompt === seed Vervoer ===
insert into scaff_ref_vervoer values ('LOG',  'Door Logistiek',         'By Logistics',        10);
insert into scaff_ref_vervoer values ('WERF', 'Door werf / aanvrager',  'By site / requester', 20);

prompt === seed Lader ===
insert into scaff_ref_lader values ('KOOIAAP', 'Kooiaap',              'Cherry picker',   10);
insert into scaff_ref_lader values ('KRAAN',   'Kraan',                'Crane',           20);
insert into scaff_ref_lader values ('LOSMID',  'Losmiddelen aanwezig', 'Loaders on site', 30);

commit;

prompt === counts ===
select 'SCAFF_PO'              as tbl, count(*) cnt from scaff_po
union all select 'SCAFF_REF_VERVOER', count(*) from scaff_ref_vervoer
union all select 'SCAFF_REF_LADER',   count(*) from scaff_ref_lader;

exit

/

prompt === db/install/11_relabel_vervoer_lader.sql ===
-- =============================================================================
-- 11_relabel_vervoer_lader.sql
--   Relabel Vervoer (4 -> 2: LOG, WERF) and Lader (4 -> 3: KOOIAAP, KRAAN, LOSMID)
--   Maps existing scaff_material_request rows BEFORE the FK lookups change.
-- =============================================================================
set define off

prompt === Insert NEW reference codes (idempotent) ===
merge into scaff_ref_vervoer t
using (
  select 'LOG'  as code, 'Door Logistiek'          as label_nl, 'By Logistics'        as label_en, 10 as sort_seq from dual union all
  select 'WERF',         'Door werf / aanvrager',                'By site / requester',                  20 from dual
) s on (t.code = s.code)
when not matched then insert (code, label_nl, label_en, sort_seq) values (s.code, s.label_nl, s.label_en, s.sort_seq)
when matched then update set t.label_nl = s.label_nl, t.label_en = s.label_en, t.sort_seq = s.sort_seq;

merge into scaff_ref_lader t
using (
  select 'KOOIAAP' as code, 'Kooiaap'              as label_nl, 'Cherry picker'        as label_en, 10 as sort_seq from dual union all
  select 'KRAAN',            'Kraan',                            'Crane',                            20 from dual union all
  select 'LOSMID',           'Losmiddelen aanwezig',             'Loaders on site',                  30 from dual
) s on (t.code = s.code)
when not matched then insert (code, label_nl, label_en, sort_seq) values (s.code, s.label_nl, s.label_en, s.sort_seq)
when matched then update set t.label_nl = s.label_nl, t.label_en = s.label_en, t.sort_seq = s.sort_seq;

prompt === Re-map existing material requests to new codes ===
update scaff_material_request
   set vervoer_code = case vervoer_code
                        when 'EIGEN'  then 'WERF'
                        when 'AFHAAL' then 'WERF'
                        when 'VRACHT' then 'LOG'
                        when 'EXTERN' then 'LOG'
                        else vervoer_code
                      end
 where vervoer_code in ('EIGEN','AFHAAL','VRACHT','EXTERN');

update scaff_material_request
   set lader_code = case lader_code
                      when 'HEFTRUCK' then 'KOOIAAP'
                      when 'HAND'     then 'LOSMID'
                      when 'GEEN'     then 'LOSMID'
                      else lader_code
                    end
 where lader_code in ('HEFTRUCK','HAND','GEEN');

prompt === Drop obsolete reference codes ===
delete from scaff_ref_vervoer where code in ('EIGEN','AFHAAL','VRACHT','EXTERN');
delete from scaff_ref_lader   where code in ('HEFTRUCK','HAND','GEEN');

commit;

prompt === Counts ===
select 'SCAFF_REF_VERVOER' as tbl, count(*) cnt from scaff_ref_vervoer
union all select 'SCAFF_REF_LADER', count(*) from scaff_ref_lader;

exit

/

prompt === db/install/13_scaff_return_request_schema.sql ===
-- =============================================================================
-- SCAFF — return-request schema (retour aanvraag)
-- =============================================================================
-- Veilig herinstalleerbaar.
-- Run as APP_DATA.
-- =============================================================================

set define off
set serveroutput on size unlimited

prompt === drop existing (ignore errors) ===
begin
  for r in (select table_name from user_tables
             where table_name in ('SCAFF_RETURN_REQUEST'))
  loop
    execute immediate 'drop table '||r.table_name||' cascade constraints purge';
  end loop;
end;
/

prompt === Return request header ===
create table SCAFF_RETURN_REQUEST (
  return_id        number generated always as identity primary key,
  po_id            number not null references scaff_po(po_id),
  contact_name     varchar2(200 char),
  site_manager     varchar2(200 char),
  gsm              varchar2(50 char)  not null,
  bakken_count     number             default 0 not null,
  transport_done   varchar2(1 char)   default 'N' check (transport_done in ('Y','N')),
  vervoer_code     varchar2(20 char)              references scaff_ref_vervoer(code),
  lader_code       varchar2(20 char)              references scaff_ref_lader(code),
  delivery_date    date               not null,
  delivery_hour    varchar2(5 char)   default '07:00',
  hold_flag        varchar2(1 char)   default 'N' check (hold_flag in ('Y','N')),
  is_final         varchar2(1 char)   default 'N' check (is_final in ('Y','N')),
  remark           varchar2(4000 char),
  created_by       varchar2(100 char) default nvl(sys_context('apex$session','app_user'), user),
  created_at       timestamp          default systimestamp
);

create index scaff_rr_po_ix on scaff_return_request (po_id);
create index scaff_rr_user_ix on scaff_return_request (created_by);

prompt === counts ===
select 'SCAFF_RETURN_REQUEST' as tbl, count(*) cnt from scaff_return_request;

exit

/

prompt === db/install/14_scaff_transfer_request_schema.sql ===
-- =============================================================================
-- SCAFF — transfer-request schema (transfer materiaal van PO -> PO)
-- =============================================================================
-- Veilig herinstalleerbaar.
-- Run as APP_DATA.
-- =============================================================================

set define off
set serveroutput on size unlimited

prompt === drop existing (ignore errors) ===
begin
  for r in (select table_name from user_tables
             where table_name in ('SCAFF_TRANSFER_REQUEST'))
  loop
    execute immediate 'drop table '||r.table_name||' cascade constraints purge';
  end loop;
end;
/

prompt === Transfer request header ===
create table SCAFF_TRANSFER_REQUEST (
  transfer_id      number generated always as identity primary key,
  from_po_id       number not null references scaff_po(po_id),
  to_po_id         number not null references scaff_po(po_id),
  email_partner    varchar2(200 char) not null,
  contact_name     varchar2(200 char),
  site_manager     varchar2(200 char),
  gsm              varchar2(50 char)  not null,
  transport_done   varchar2(1 char)   default 'N' check (transport_done in ('Y','N')),
  vervoer_code     varchar2(20 char)              references scaff_ref_vervoer(code),
  lader_code       varchar2(20 char)              references scaff_ref_lader(code),
  delivery_date    date               not null,
  delivery_hour    varchar2(5 char)   default '07:00',
  hold_flag        varchar2(1 char)   default 'N' check (hold_flag in ('Y','N')),
  remark           varchar2(4000 char),
  created_by       varchar2(100 char) default nvl(sys_context('apex$session','app_user'), user),
  created_at       timestamp          default systimestamp,
  constraint scaff_tr_from_to_chk check (from_po_id <> to_po_id)
);

create index scaff_tr_from_ix on scaff_transfer_request (from_po_id);
create index scaff_tr_to_ix   on scaff_transfer_request (to_po_id);
create index scaff_tr_user_ix on scaff_transfer_request (created_by);

prompt === counts ===
select 'SCAFF_TRANSFER_REQUEST' as tbl, count(*) cnt from scaff_transfer_request;

exit

/

prompt === db/install/15_scaff_po_extra_dummy_seed.sql ===
set define off

prompt === seed extra IO + PO/N dummy data (idempotent) ===

merge into scaff_po t
using (
  select 'IO/'  as po_prefix, '00047' as po_number, 'SCAFF - Intern depot Genk'            as customer_name, 'Henry Fordlaan 12'                 as address_line, '3600' as postal_code, 'GENK'      as city from dual union all
  select 'IO/'  as po_prefix, '00048' as po_number, 'SCAFF - Intern depot Gent'            as customer_name, 'Skaldenstraat 125'                as address_line, '9042' as postal_code, 'GENT'      as city from dual union all
  select 'IO/'  as po_prefix, '00049' as po_number, 'SCAFF - Intern depot Charleroi'       as customer_name, 'Rue de Monceau Fontaine 40'       as address_line, '6031' as postal_code, 'CHARLEROI' as city from dual union all
  select 'IO/'  as po_prefix, '00050' as po_number, 'SCAFF - Intern depot Breda'           as customer_name, 'Konijnenberg 130'                 as address_line, '4825' as postal_code, 'BREDA'     as city from dual union all
  select 'IO/'  as po_prefix, '00051' as po_number, 'SCAFF - Intern depot Rotterdam'       as customer_name, 'Waalhaven Zuidzijde 20'           as address_line, '3088' as postal_code, 'ROTTERDAM' as city from dual union all
  select 'PO/N' as po_prefix, '00013' as po_number, 'SCAFF - Nieuwe klant Kortrijk'        as customer_name, 'Beneluxpark 22'                   as address_line, '8500' as postal_code, 'KORTRIJK'  as city from dual union all
  select 'PO/N' as po_prefix, '00014' as po_number, 'SCAFF - Nieuwe klant Antwerpen Noord' as customer_name, 'Noorderlaan 501'                  as address_line, '2030' as postal_code, 'ANTWERPEN' as city from dual union all
  select 'PO/N' as po_prefix, '00015' as po_number, 'SCAFF - Nieuwe klant Eindhoven'       as customer_name, 'Flight Forum 2100'                as address_line, '5657' as postal_code, 'EINDHOVEN' as city from dual union all
  select 'PO/N' as po_prefix, '00016' as po_number, 'SCAFF - Nieuwe klant Hasselt'         as customer_name, 'Gouverneur Verwilghensingel 2'    as address_line, '3500' as postal_code, 'HASSELT'   as city from dual union all
  select 'PO/N' as po_prefix, '00017' as po_number, 'SCAFF - Nieuwe klant Utrecht'         as customer_name, 'Papendorpseweg 100'               as address_line, '3528' as postal_code, 'UTRECHT'   as city from dual
) s
on (t.po_prefix = s.po_prefix and t.po_number = s.po_number)
when not matched then
  insert (po_prefix, po_number, customer_name, address_line, postal_code, city)
  values (s.po_prefix, s.po_number, s.customer_name, s.address_line, s.postal_code, s.city);

commit;

prompt === prefix counts ===
select po_prefix, count(*) as cnt
  from scaff_po
 group by po_prefix
 order by po_prefix;

/

prompt === db/packages/hd_mobile_ui_pkg.sql ===
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

/

prompt === db/packages/pkg_scaff_ui.sql ===
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
  function get_label_translations return varchar2;
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
    
    if l_lang not in ('nl','en','fr','de','pl','ru','ar','tr') then
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

  function get_label_translations return varchar2
  is
    l_json clob;
  begin
    apex_json.initialize_clob_output;
    apex_json.open_object;

    -- Form page labels (p11, p21, p31)
    apex_json.write('P_LBL_CONTACT',        apex_lang.message('SCAFF.MR.FORM.CONTACT'));
    apex_json.write('P_LBL_WERFLEIDER',     apex_lang.message('SCAFF.MR.FORM.WERFLEIDER'));
    apex_json.write('P_LBL_GSM',            apex_lang.message('SCAFF.MR.FORM.GSM'));
    apex_json.write('P_LBL_DELIVERY_DATE',  apex_lang.message('SCAFF.MR.FORM.DELIVERY_DATE'));
    apex_json.write('P_LBL_BAKKEN',         apex_lang.message('SCAFF.MR.FORM.BAKKEN'));
    apex_json.write('P_LBL_TRANSPORT',      apex_lang.message('SCAFF.MR.FORM.TRANSPORT'));
    apex_json.write('P_LBL_LADER',          apex_lang.message('SCAFF.MR.FORM.LADER'));
    apex_json.write('P_LBL_UUR',            apex_lang.message('SCAFF.MR.FORM.UUR'));
    apex_json.write('P_LBL_AANHOUDEN',      apex_lang.message('SCAFF.MR.FORM.AANHOUDEN'));
    apex_json.write('P_LBL_LAASTE',         apex_lang.message('SCAFF.MR.FORM.LAASTE'));
    apex_json.write('P_LBL_OPMERKING',      apex_lang.message('SCAFF.MR.FORM.OPMERKING'));
    apex_json.write('P_LBL_OPSLAAN',        apex_lang.message('SCAFF.MR.FORM.BTN.SAVE'));
    apex_json.write('P_LBL_ANNULEREN',      apex_lang.message('SCAFF.MR.FORM.BTN.CANCEL'));
    apex_json.write('P_LBL_PREFIX',         apex_lang.message('SCAFF.MR.LIST.PREFIX'));
    apex_json.write('P_LBL_SEARCH',         apex_lang.message('SCAFF.MR.LIST.SEARCH'));

    -- List page labels (p40, p50)
    apex_json.write('P_LBL_PO',             apex_lang.message('SCAFF.MR.LIST.PO'));
    apex_json.write('P_LBL_KLANT',          apex_lang.message('SCAFF.MR.LIST.KLANT'));
    apex_json.write('P_LBL_STAD',           apex_lang.message('SCAFF.MR.LIST.STAD'));
    apex_json.write('P_LBL_DATUM',          apex_lang.message('SCAFF.MR.LIST.DATUM'));
    apex_json.write('P_LBL_STATUS',         apex_lang.message('SCAFF.MR.LIST.STATUS'));
    apex_json.write('P_LBL_BEWERKEN',       apex_lang.message('SCAFF.MR.LIST.EDIT'));
    apex_json.write('P_LBL_AANHOUDEN',      apex_lang.message('SCAFF.MR.LIST.HOLD'));
    apex_json.write('P_LBL_HERSTARTEN',     apex_lang.message('SCAFF.MR.LIST.RESUME'));
    apex_json.write('P_LBL_VERWIJDEREN',    apex_lang.message('SCAFF.MR.LIST.DELETE'));
    apex_json.write('P_LBL_BEVESTIGEN',     apex_lang.message('SCAFF.MR.LIST.DELETE.CONFIRM'));

    -- Item IDs for form pages
    apex_json.write('P11_CONTACT',          'P11_CONTACT');
    apex_json.write('P11_WERFLEIDER',       'P11_WERFLEIDER');
    apex_json.write('P11_GSM',              'P11_GSM');
    apex_json.write('P11_DELIVERY_DATE',    'P11_DELIVERY_DATE');
    apex_json.write('P11_BAKKEN',           'P11_BAKKEN');
    apex_json.write('P11_TRANSPORT',        'P11_TRANSPORT_DONE');
    apex_json.write('P11_LADER',            'P11_LADER');
    apex_json.write('P11_UUR',              'P11_UUR');
    apex_json.write('P11_AANHOUDEN',        'P11_AANHOUDEN');
    apex_json.write('P11_LAASTE',           'P11_LAATSTE');
    apex_json.write('P11_OPMERKING',        'P11_OPMERKING');
    
    apex_json.write('P21_CONTACT',          'P21_CONTACT');
    apex_json.write('P21_WERFLEIDER',       'P21_WERFLEIDER');
    apex_json.write('P21_GSM',              'P21_GSM');
    apex_json.write('P21_DELIVERY_DATE',    'P21_DATUM');
    apex_json.write('P21_BAKKEN',           'P21_BAKKEN');
    apex_json.write('P21_TRANSPORT',        'P21_TRANSPORT_DONE');
    apex_json.write('P21_LADER',            'P21_LADER');
    apex_json.write('P21_UUR',              'P21_UUR');
    apex_json.write('P21_AANHOUDEN',        'P21_AANHOUDEN');
    apex_json.write('P21_LAASTE',           'P21_LAATSTE');
    apex_json.write('P21_OPMERKING',        'P21_OPMERKING');
    
    apex_json.write('P31_CONTACT',          'P31_CONTACT');
    apex_json.write('P31_WERFLEIDER',       'P31_WERFLEIDER');
    apex_json.write('P31_GSM',              'P31_GSM');
    apex_json.write('P31_DELIVERY_DATE',    'P31_DATUM');
    apex_json.write('P31_BAKKEN',           'P31_BAKKEN');
    apex_json.write('P31_TRANSPORT',        'P31_TRANSPORT_DONE');
    apex_json.write('P31_LADER',            'P31_LADER');
    apex_json.write('P31_UUR',              'P31_UUR');
    apex_json.write('P31_AANHOUDEN',        'P31_AANHOUDEN');
    apex_json.write('P31_LAASTE',           'P31_LAATSTE');
    apex_json.write('P31_OPMERKING',        'P31_OPMERKING');

    apex_json.close_object;
    l_json := apex_json.get_clob_output;
    apex_json.free_output;
    return l_json;
  end get_label_translations;

end PKG_SCAFF_UI;
/

/

prompt === db/packages/pkg_scaff_req.sql ===
-- =============================================================================
-- PKG_SCAFF_REQ  —  Material request mutations (edit / hold / delete)
-- =============================================================================
set define off

create or replace package PKG_SCAFF_REQ
as
  -- Returns Y/N indicating whether current APP_USER may mutate p_request_id.
  function can_edit (p_request_id in number) return varchar2;

  -- Toggle hold_flag for the given request. Returns the NEW flag ('Y'/'N').
  function toggle_hold (p_request_id in number) return varchar2;

  -- Delete a request. Returns 1 if deleted, 0 if not found / not allowed.
  function delete_request (p_request_id in number) return number;

  -- Returns the date that is p_days_ahead business days (Mon-Fri) after p_from.
  -- Counts only weekdays; if p_from itself is a weekend it is skipped first.
  function next_business_day (p_from in date, p_days_ahead in pls_integer) return date;

  -- Y/N : is the given date a weekday (Mon-Fri).
  function is_business_day (p_d in date) return varchar2;

  -- Return-request mutations (mirror material-request).
  function can_edit_return    (p_return_id in number) return varchar2;
  function toggle_hold_return (p_return_id in number) return varchar2;
  function delete_return      (p_return_id in number) return number;

  -- Transfer-request mutations (mirror material-request).
  function can_edit_transfer    (p_transfer_id in number) return varchar2;
  function toggle_hold_transfer (p_transfer_id in number) return varchar2;
  function delete_transfer      (p_transfer_id in number) return number;
end PKG_SCAFF_REQ;
/

create or replace package body PKG_SCAFF_REQ
as
  function is_admin return boolean
  is
    l_user varchar2(200) := lower(v('APP_USER'));
  begin
    return l_user in ('admin','app_data','nobody','apex_public_user');
  end is_admin;

  function can_edit (p_request_id in number) return varchar2
  is
    l_owner varchar2(200);
    l_user  varchar2(200) := lower(v('APP_USER'));
  begin
    select lower(created_by) into l_owner
      from scaff_material_request
     where request_id = p_request_id;
    if l_owner = l_user or is_admin then
      return 'Y';
    end if;
    return 'N';
  exception
    when no_data_found then
      return 'N';
  end can_edit;

  function toggle_hold (p_request_id in number) return varchar2
  is
    l_new varchar2(1);
  begin
    if can_edit(p_request_id) = 'N' then
      return null;
    end if;
    update scaff_material_request
       set hold_flag = case when hold_flag = 'Y' then 'N' else 'Y' end
     where request_id = p_request_id
    returning hold_flag into l_new;
    commit;
    return l_new;
  end toggle_hold;

  function delete_request (p_request_id in number) return number
  is
  begin
    if can_edit(p_request_id) = 'N' then
      return 0;
    end if;
    delete from scaff_material_request where request_id = p_request_id;
    commit;
    return sql%rowcount;
  end delete_request;

  function is_business_day (p_d in date) return varchar2
  is
    l_day varchar2(20);
  begin
    l_day := upper(trim(to_char(p_d, 'fmDAY', 'NLS_DATE_LANGUAGE=ENGLISH')));
    if l_day in ('SATURDAY','SUNDAY') then
      return 'N';
    end if;
    return 'Y';
  end is_business_day;

  function next_business_day (p_from in date, p_days_ahead in pls_integer) return date
  is
    l_d     date := trunc(p_from);
    l_left  pls_integer := greatest(nvl(p_days_ahead,0), 0);
  begin
    while l_left > 0 loop
      l_d := l_d + 1;
      if is_business_day(l_d) = 'Y' then
        l_left := l_left - 1;
      end if;
    end loop;
    return l_d;
  end next_business_day;

  function can_edit_return (p_return_id in number) return varchar2
  is
    l_owner varchar2(200);
    l_user  varchar2(200) := lower(v('APP_USER'));
  begin
    select lower(created_by) into l_owner
      from scaff_return_request
     where return_id = p_return_id;
    if l_owner = l_user or is_admin then
      return 'Y';
    end if;
    return 'N';
  exception
    when no_data_found then
      return 'N';
  end can_edit_return;

  function toggle_hold_return (p_return_id in number) return varchar2
  is
    l_new varchar2(1);
  begin
    if can_edit_return(p_return_id) = 'N' then
      return null;
    end if;
    update scaff_return_request
       set hold_flag = case when hold_flag = 'Y' then 'N' else 'Y' end
     where return_id = p_return_id
    returning hold_flag into l_new;
    commit;
    return l_new;
  end toggle_hold_return;

  function delete_return (p_return_id in number) return number
  is
  begin
    if can_edit_return(p_return_id) = 'N' then
      return 0;
    end if;
    delete from scaff_return_request where return_id = p_return_id;
    commit;
    return sql%rowcount;
  end delete_return;

  function can_edit_transfer (p_transfer_id in number) return varchar2
  is
    l_owner varchar2(200);
    l_user  varchar2(200) := lower(v('APP_USER'));
  begin
    select lower(created_by) into l_owner
      from scaff_transfer_request
     where transfer_id = p_transfer_id;
    if l_owner = l_user or is_admin then
      return 'Y';
    end if;
    return 'N';
  exception
    when no_data_found then
      return 'N';
  end can_edit_transfer;

  function toggle_hold_transfer (p_transfer_id in number) return varchar2
  is
    l_new varchar2(1);
  begin
    if can_edit_transfer(p_transfer_id) = 'N' then
      return null;
    end if;
    update scaff_transfer_request
       set hold_flag = case when hold_flag = 'Y' then 'N' else 'Y' end
     where transfer_id = p_transfer_id
    returning hold_flag into l_new;
    commit;
    return l_new;
  end toggle_hold_transfer;

  function delete_transfer (p_transfer_id in number) return number
  is
  begin
    if can_edit_transfer(p_transfer_id) = 'N' then
      return 0;
    end if;
    delete from scaff_transfer_request where transfer_id = p_transfer_id;
    commit;
    return sql%rowcount;
  end delete_transfer;

end PKG_SCAFF_REQ;
/

show errors package body PKG_SCAFF_REQ

/

prompt === db/views/v_mobile_menu.sql ===
-- =============================================================================
-- V_MOBILE_MENU  —  Mobiel startscherm voor SCAFF APP
-- =============================================================================
-- Gebruikt door APEX Cards region op (toekomstige) mobile home page.
-- Kolommen zijn afgestemd op standaard APEX Cards bindings.
-- =============================================================================
create or replace view V_MOBILE_MENU
( CARD_ID
, DISPLAY_SEQUENCE
, TITLE_KEY
, SUBTITLE_KEY
, CARD_ICON
, CARD_ICON_COLOR
, CARD_LINK
, CARD_CSS_CLASSES
) as
select 1                                          as card_id
     , 10                                         as display_sequence
     , 'SCAFF.MENU.MATERIAAL.TITLE'               as title_key
     , 'SCAFF.MENU.MATERIAAL.SUBTITLE'            as subtitle_key
     , 'fa-robot'                                 as card_icon
     , 'altrad-red'                               as card_icon_color
     , 'f?p=&APP_ID.:10:&APP_SESSION.::&DEBUG.:::' as card_link
     , 'mobile-card mobile-card--materiaal'       as card_css_classes
  from dual
union all
select 2
     , 20
     , 'SCAFF.MENU.RETOUR.TITLE'
     , 'SCAFF.MENU.RETOUR.SUBTITLE'
     , 'fa-undo'
     , 'altrad-red'
     , 'f?p=&APP_ID.:20:&APP_SESSION.::&DEBUG.:::'
     , 'mobile-card mobile-card--retour'
  from dual
union all
select 3
     , 30
     , 'SCAFF.MENU.TRANSFER.TITLE'
     , 'SCAFF.MENU.TRANSFER.SUBTITLE'
     , 'fa-truck'
     , 'altrad-red'
     , 'f?p=&APP_ID.:30:&APP_SESSION.::&DEBUG.:::'
     , 'mobile-card mobile-card--transfer'
  from dual
union all
select 4
     , 40
     , 'SCAFF.MENU.AANVRAGEN.TITLE'
     , 'SCAFF.MENU.AANVRAGEN.SUBTITLE'
     , 'fa-list-check'
     , 'altrad-red'
     , 'f?p=&APP_ID.:50:&APP_SESSION.::&DEBUG.:::'
     , 'mobile-card mobile-card--aanvragen'
  from dual
;

comment on table  V_MOBILE_MENU                  is 'Mobiel startmenu — 3 cards. Titels via apex_lang text messages.';
comment on column V_MOBILE_MENU.CARD_ID          is 'Stabiele ID (1=Materiaal, 2=Retour, 3=Transfer, 4=Aanvragen).';
comment on column V_MOBILE_MENU.DISPLAY_SEQUENCE is 'Sorteervolgorde.';
comment on column V_MOBILE_MENU.TITLE_KEY        is 'APEX text message key voor de titel.';
comment on column V_MOBILE_MENU.SUBTITLE_KEY     is 'APEX text message key voor de subtitle.';
comment on column V_MOBILE_MENU.CARD_ICON        is 'Font Awesome class (incl. fa- prefix).';
comment on column V_MOBILE_MENU.CARD_ICON_COLOR  is 'CSS klasse voor icon kleur.';
comment on column V_MOBILE_MENU.CARD_LINK        is 'APEX f?p= link.';
comment on column V_MOBILE_MENU.CARD_CSS_CLASSES is 'Extra CSS classes per card.';

/

prompt === DONE ===
