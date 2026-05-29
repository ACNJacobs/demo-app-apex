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
