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
