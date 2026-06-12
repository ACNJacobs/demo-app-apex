prompt --application/set_environment
set define off verify off feedback off
whenever sqlerror exit sql.sqlcode rollback
--------------------------------------------------------------------------------
-- Oracle APEX 26.1 Starter App Export
-- Minimal template for creating new apps via import
-- Usage: sql -S SAH/password@host:port/PDB @starter-app.sql
-- Then: apex export -applicationid <new_id> -exptype APEXLANG
--------------------------------------------------------------------------------
begin
wwv_flow_imp.import_begin (
 p_version_yyyy_mm_dd=>'2026.03.30'
,p_release=>'26.1.0'
,p_default_workspace_id=>4396054143779997
,p_default_application_id=>999
,p_default_id_offset=>0
,p_default_owner=>'SAH'
);
end;
/

prompt APPLICATION 999 - STARTER APP

prompt --application/delete_application
begin
wwv_flow_imp.remove_flow(wwv_flow.g_flow_id);
end;
/

prompt --application/create_application
begin
wwv_imp_workspace.create_flow(
 p_id=>wwv_flow.g_flow_id
,p_owner=>'SAH'
,p_name=>'STARTER APP'
,p_alias=>'STARTER-APP'
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
,p_application_tab_set=>0
,p_logo_type=>'T'
,p_logo_text=>'STARTER APP'
,p_proxy_server=>''
,p_no_proxy_domains=>''
,p_flow_version=>'Release 1.0'
,p_flow_status=>'AVAILABLE_W_EDIT_LINK'
,p_browser_cache=>'N'
,p_browser_frame=>'D'
,p_authorize_batch_job=>'N'
,p_rejoin_existing_sessions=>'N'
,p_csv_encoding=>'Y'
,p_file_prefix=>''
,p_files_version=>1
,p_print_server_type=>'NATIVE'
,p_file_storage=>'DB'
,p_is_pwa=>'N'
,p_theme_id=>42
,p_home_url=>'f?p=&APP_ID.:1:&SESSION.::&DEBUG.'
,p_login_url=>'f?p=&APP_ID.:LOGIN:&SESSION.::&DEBUG.'
,p_theme_style_by_user_pref=>false
,p_built_with_love=>false
,p_global_page_id=>0
);
end;
/

prompt --theme
begin
wwv_flow_imp_shared.create_theme(
 p_id=>wwv_flow_imp.id(42)
,p_theme_id=>42
,p_theme_name=>'Universal Theme'
,p_theme_internal_comments=>'Released: 18.1.0. The Universal Theme is a fully responsive theme that offers a clean and modern user interface. It is designed to work seamlessly on all devices, from desktops to tablets and smartphones.'
,p_ui_type_name=>'DESKTOP'
,p_is_locked=>false
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
 p_id=>wwv_flow_imp.id(99900000000000001)
,p_plug_name=>'Welcome'
,p_region_template_options=>'#DEFAULT#'
,p_plug_template=>wwv_flow_imp.id(99900000000000002)
,p_plug_display_sequence=>10
,p_plug_source_type=>'NATIVE_STATIC_CONTENT'
,p_plug_query_num_rows=>15
,p_attribute_01=>'Y'
,p_attribute_02=>'HTML'
,p_attribute_03=>'<h1>Welkom bij STARTER APP</h1><p>Deze app is succesvol aangemaakt via SQLcl MCP.</p>'
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
wwv_flow_imp.import_end(p_auto_install_sup_obj => false);
commit;
end;
/

set verify on feedback on define on
prompt --done
