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
