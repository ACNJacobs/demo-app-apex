set serveroutput on
set lines 300
set long 5000
declare
  l_html clob;
begin
  apex_session.create_session(p_app_id => 100, p_page_id => 1, p_username => 'TEST');
  l_html := pkg_scaff_ui.get_mobile_menu;
  dbms_output.put_line(regexp_substr(l_html, 'href="[^"]+"', 1, 1));
  dbms_output.put_line(regexp_substr(l_html, 'href="[^"]+"', 1, 2));
  dbms_output.put_line(regexp_substr(l_html, 'href="[^"]+"', 1, 3));
  dbms_output.put_line(regexp_substr(l_html, 'href="[^"]+"', 1, 4));
end;
/
exit
