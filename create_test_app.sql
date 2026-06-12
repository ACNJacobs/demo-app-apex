prompt --application/set_environment
set define off verify off feedback off
whenever sqlerror exit sql.sqlcode rollback
--------------------------------------------------------------------------------
-- Minimal APEX 26.1 app creation script for TEST APP (id 200)
-- Run as SAH (parsing schema) or APEX_ADMINISTRATOR_ROLE
--------------------------------------------------------------------------------
begin
wwv_flow_imp.import_begin (
 p_version_yyyy_mm_dd=>'2026.03.30'
,p_release=>'26.1.0'
,p_default_workspace_id=>4396054143779997
,p_default_application_id=>200
,p_default_id_offset=>0
,p_default_owner=>'SAH'
);
end;
/

prompt APPLICATION 200 - TEST APP

begin
wwv_imp_workspace.create_flow(
 p_id=>wwv_flow.g_flow_id
,p_owner=>'SAH'
,p_name=>'TEST APP'
,p_alias=>'TEST-APP'
,p_page_view_logging=>'YES'
,p_page_protection_enabled_y_n=>'Y'
,p_checksum_salt=>'B4AF2F75F57898AC125DEBFDCDB669AB4B18884E9B800DB8492F105827AF68BC'
,p_bookmark_checksum_function=>'SH512'
,p_compatibility_mode=>'26.1'
,p_flow_language=>'nl'
,p_flow_language_derived_from=>'FLOW_PREFERENCE'
,p_allow_feedback_yn=>'Y'
,p_date_format=>'DS'
,p_timestamp_format=>'DS'
,p_timestamp_tz_format=>'DS'
,p_flow_image_prefix=>''
,p_authentication_id=>wwv_flow_imp.id(7205400885888371)
,p_application_tab_set=>0
,p_logo_type=>'T'
,p_logo_text=>'TEST APP'
,p_proxy_server=>''
,p_no_proxy_domains=>''
,p_flow_version=>'Release 1.0'
,p_flow_status=>'AVAILABLE_W_EDIT_LINK'
,p_flow_unavailable_text=>'This application is currently unavailable.'
,p_exact_substitutions_only=>'Y'
,p_browser_cache=>'N'
,p_browser_frame=>'D'
,p_deep_linking=>'Y'
,p_vpd=>''
,p_vpd_teardown_code=>''
,p_authorize_public_pages_yn=>'N'
,p_session_timeout_warning_ms=>4000000
,p_configuration=>'N'
,p_last_updated_by=>'SAH'
,p_last_upd_yyyymmddhh24miss=>'20260612100000'
,p_file_prefix =>''
,p_files_version=>1
,p_ui_type_name => null
);
end;
/

prompt --global-page
begin
wwv_flow_imp.create_page(
 p_id=>0
,p_name=>'Global Page'
,p_step_title=>'Global Page'
,p_autocomplete_on_off=>'OFF'
,p_page_template_options=>'#DEFAULT#'
,p_protection_level=>'D'
,p_page_component_map=>'14'
,p_last_updated_by=>'SAH'
,p_last_upd_yyyymmddhh24miss=>'20260612100000'
);
end;
/

prompt --home-page
begin
wwv_flow_imp.create_page(
 p_id=>1
,p_name=>'Home'
,p_alias=>'HOME'
,p_step_title=>'Home'
,p_autocomplete_on_off=>'OFF'
,p_page_template_options=>'#DEFAULT#'
,p_protection_level=>'D'
,p_page_component_map=>'11'
,p_last_updated_by=>'SAH'
,p_last_upd_yyyymmddhh24miss=>'20260612100000'
);
end;
/

begin
wwv_flow_imp.create_page_plug(
 p_id=>wwv_flow_imp.id(28834820253510948)
,p_plug_name=>'Welcome'
,p_region_template_options=>'#DEFAULT#'
,p_plug_template=>wwv_flow_imp.id(28834820253510949)
,p_plug_display_sequence=>10
,p_plug_source_type=>'NATIVE_STATIC_CONTENT'
,p_plug_query_num_rows=>15
,p_attribute_01=>'Y'
,p_attribute_02=>'HTML'
,p_attribute_03=>wwv_flow_string.join(wwv_flow_t_varchar2(
'<h1>Welkom bij TEST APP</h1>',
'<p>Deze app is succesvol aangemaakt via SQLcl MCP.</p>'))
);
end;
/

prompt --login-page
begin
wwv_flow_imp.create_page(
 p_id=>9999
,p_name=>'Login'
,p_alias=>'LOGIN'
,p_step_title=>'Log In'
,p_autocomplete_on_off=>'OFF'
,p_page_template_options=>'#DEFAULT#'
,p_protection_level=>'C'
,p_page_component_map=>'12'
,p_last_updated_by=>'SAH'
,p_last_upd_yyyymmddhh24miss=>'20260612100000'
);
end;
/

prompt --end
begin
wwv_flow_imp.import_end(p_auto_install_sup_obj => nvl(wwv_flow_application_install.get_auto_install_sup_obj, false));
commit;
end;
/

set verify on feedback on define on
prompt --done
