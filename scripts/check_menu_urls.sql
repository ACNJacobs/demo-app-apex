set serveroutput on
set lines 300
set long 5000
declare
  l_link     varchar2(4000);
  l_prepared varchar2(4000);
begin
  apex_session.create_session(p_app_id => 100, p_page_id => 1, p_username => 'TEST');

  for r in (
    select card_id, card_link
      from v_mobile_menu
     order by display_sequence
     fetch first 4 rows only
  ) loop
    l_link := r.card_link;
    l_link := replace(l_link, '&'||'APP_ID.',      to_char(apex_application.g_flow_id));
    l_link := replace(l_link, '&'||'APP_SESSION.', to_char(apex_application.g_instance));
    l_link := replace(l_link, '&'||'DEBUG.',       nvl(v('DEBUG'),'NO'));
    l_prepared := apex_util.prepare_url(l_link);
    dbms_output.put_line(r.card_id || ': ' || l_prepared);
  end loop;

  apex_session.delete_session;
end;
/
exit
