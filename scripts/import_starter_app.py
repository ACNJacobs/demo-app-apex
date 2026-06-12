#!/usr/bin/env python3
"""
Import the APEX starter app template into Oracle APEX.

This script creates a minimal APEX app by executing a generated SQL script
in a single PL/SQL block, preserving wwv_flow_imp package state.

Usage:
    python scripts/import_starter_app.py --id 300 --name "DEMO APP" --alias "DEMO-APP"

Requirements:
    pip install oracledb
"""

import argparse
import oracledb
import sys

# Connection details for MaxApex_Live
DEFAULT_HOST = "secureaihub.maxapex.net"
DEFAULT_PORT = 1521
DEFAULT_SERVICE = "XEPDB1"
DEFAULT_USER = "SAH"
DEFAULT_PASSWORD = "u73AFTjKhUn4EyBvgpcX"
DEFAULT_WORKSPACE = "SECURE_AI_HUB"


def generate_sql(app_id, app_name, app_alias, workspace):
    """Generate the complete import SQL as a single PL/SQL block."""
    
    # Use IDs that are guaranteed unique (high offset)
    # Original SCAFF APP used IDs around 7207163271888401
    # We'll use 9900000000000000000 + app_id * 1000 + sequence
    base = 9900000000000000000 + (app_id * 1000)
    
    def nid(offset):
        return str(base + offset)
    
    sql = f"""
begin
    -- Set install parameters
    apex_application_install.set_workspace('{workspace}');
    apex_application_install.set_application_id({app_id});
    apex_application_install.set_application_name('{app_name}');
    apex_application_install.set_application_alias('{app_alias}');

    -- Begin import
    wwv_flow_imp.import_begin (
        p_version_yyyy_mm_dd=>'2026.03.30',
        p_release=>'26.1.0',
        p_default_workspace_id=>4396054143779997,
        p_default_application_id=>{app_id},
        p_default_id_offset=>0,
        p_default_owner=>'SAH'
    );

    -- Remove if exists
    begin
        wwv_flow_imp.remove_flow(wwv_flow.g_flow_id);
    exception when others then null;
    end;

    -- Create app
    wwv_imp_workspace.create_flow(
        p_id=>wwv_flow.g_flow_id,
        p_owner=>'SAH',
        p_name=>'{app_name}',
        p_alias=>'{app_alias}',
        p_page_view_logging=>'YES',
        p_page_protection_enabled_y_n=>'Y',
        p_checksum_salt=>'B4AF2F75F57898AC125DEBFDCDB669AB4B18884E9B800DB8492F105827AF68BC',
        p_bookmark_checksum_function=>'SH512',
        p_compatibility_mode=>'26.1',
        p_flow_language=>'nl',
        p_flow_language_derived_from=>'FLOW_PREFERENCE',
        p_allow_feedback_yn=>'Y',
        p_date_format=>'DS',
        p_timestamp_format=>'DS',
        p_timestamp_tz_format=>'DS',
        p_application_tab_set=>0,
        p_logo_type=>'T',
        p_logo_text=>'{app_name}',
        p_flow_version=>'Release 1.0',
        p_flow_status=>'AVAILABLE_W_EDIT_LINK',
        p_browser_cache=>'N',
        p_browser_frame=>'D',
        p_authorize_batch_job=>'N',
        p_rejoin_existing_sessions=>'N',
        p_csv_encoding=>'Y',
        p_files_version=>1,
        p_print_server_type=>'NATIVE',
        p_file_storage=>'DB',
        p_is_pwa=>'N',
        p_theme_id=>42,
        p_home_url=>'f?p={app_id}:1:0::NO',
        p_login_url=>'f?p={app_id}:LOGIN:0::NO',
        p_theme_style_by_user_pref=>false,
        p_built_with_love=>false,
        p_global_page_id=>0
    );

    -- Create authentication scheme
    wwv_flow_imp_shared.create_authentication(
        p_id=>wwv_flow_imp.id({nid(99)}),
        p_flow_id=>wwv_flow.g_flow_id,
        p_name=>'Oracle APEX Accounts',
        p_static_id=>'oracle-apex-accounts',
        p_scheme_type=>'NATIVE_APEX_ACCOUNTS',
        p_invalid_session_type=>'LOGIN',
        p_use_secure_cookie_yn=>'N',
        p_ras_mode=>0
    );

    -- Update app to use the authentication scheme
    wwv_flow_imp.set_flow_authentication(
        p_flow_id=>wwv_flow.g_flow_id,
        p_authentication=>'Oracle APEX Accounts'
    );

    -- Global page
    wwv_flow_imp_page.create_page(
        p_id=>0,
        p_name=>'Global Page',
        p_reload_on_submit=>null,
        p_warn_on_unsaved_changes=>null,
        p_autocomplete_on_off=>'OFF',
        p_protection_level=>'D'
    );

    -- Home page
    wwv_flow_imp_page.create_page(
        p_id=>1,
        p_name=>'Home',
        p_alias=>'HOME',
        p_step_title=>'{app_name}',
        p_autocomplete_on_off=>'OFF',
        p_page_template_options=>'#DEFAULT#',
        p_protection_level=>'C'
    );
    wwv_flow_imp_page.create_page_plug(
        p_id=>wwv_flow_imp.id({nid(1)}),
        p_plug_name=>'Welcome',
        p_region_template_options=>'#DEFAULT#',
        p_plug_template=>4073835273271169698,
        p_plug_display_sequence=>10,
        p_plug_item_display_point=>'ABOVE',
        p_location=>null,
        p_plug_source=>'Welcome to {app_name}',
        p_plug_source_type=>'NATIVE_STATIC_CONTENT'
    );

    -- Login page
    wwv_flow_imp_page.create_page(
        p_id=>9999,
        p_name=>'Login Page',
        p_alias=>'LOGIN',
        p_step_title=>'{app_name} - Log In',
        p_warn_on_unsaved_changes=>'N',
        p_first_item=>'AUTO_FIRST_ITEM',
        p_autocomplete_on_off=>'OFF',
        p_page_template_options=>'#DEFAULT#',
        p_page_is_public_y_n=>'Y'
    );
    wwv_flow_imp_page.create_page_plug(
        p_id=>wwv_flow_imp.id({nid(2)}),
        p_plug_name=>'{app_name}',
        p_static_id=>'{app_alias.lower()}',
        p_region_template_options=>'#DEFAULT#',
        p_plug_template=>2675634334296186762,
        p_plug_display_sequence=>10,
        p_plug_item_display_point=>'ABOVE',
        p_location=>null
    );
    wwv_flow_imp_page.create_page_button(
        p_id=>wwv_flow_imp.id({nid(3)}),
        p_button_sequence=>40,
        p_button_plug_id=>wwv_flow_imp.id({nid(2)}),
        p_button_name=>'LOGIN',
        p_static_id=>'login',
        p_show_as_disabled=>false,
        p_button_action=>'SUBMIT',
        p_button_template_options=>'#DEFAULT#',
        p_button_template_id=>4073839297780169708,
        p_button_is_hot=>'Y',
        p_button_image_alt=>'Sign In',
        p_button_position=>'NEXT',
        p_grid_new_row=>'Y'
    );
    wwv_flow_imp_page.create_page_item(
        p_id=>wwv_flow_imp.id({nid(4)}),
        p_name=>'P9999_PASSWORD',
        p_item_sequence=>20,
        p_item_plug_id=>wwv_flow_imp.id({nid(2)}),
        p_prompt=>'Password',
        p_placeholder=>'Password',
        p_source_type=>'ALWAYS_NULL',
        p_display_as=>'NATIVE_PASSWORD',
        p_cSize=>40,
        p_cMaxlength=>100,
        p_tag_attributes=>'autocomplete="current-password"',
        p_label_alignment=>'RIGHT',
        p_field_template=>2042262243893469891,
        p_item_icon_css_classes=>'fa-key',
        p_item_template_options=>'#DEFAULT#',
        p_is_persistent=>'N'
    );
    wwv_flow_imp_page.create_page_item(
        p_id=>wwv_flow_imp.id({nid(5)}),
        p_name=>'P9999_REMEMBER',
        p_item_sequence=>30,
        p_item_plug_id=>wwv_flow_imp.id({nid(2)}),
        p_prompt=>'Remember username',
        p_source_type=>'ALWAYS_NULL',
        p_display_as=>'NATIVE_SINGLE_CHECKBOX',
        p_label_alignment=>'RIGHT',
        p_display_when=>'apex_authentication.persistent_cookies_enabled',
        p_display_when2=>'PLSQL',
        p_display_when_type=>'EXPRESSION',
        p_field_template=>2042262243893469891,
        p_item_template_options=>'#DEFAULT#'
    );
    wwv_flow_imp_page.create_page_item(
        p_id=>wwv_flow_imp.id({nid(6)}),
        p_name=>'P9999_USERNAME',
        p_item_sequence=>10,
        p_item_plug_id=>wwv_flow_imp.id({nid(2)}),
        p_prompt=>'Username',
        p_placeholder=>'Username',
        p_source_type=>'ALWAYS_NULL',
        p_display_as=>'NATIVE_TEXT_FIELD',
        p_cSize=>40,
        p_cMaxlength=>100,
        p_tag_attributes=>'autocomplete="username"',
        p_label_alignment=>'RIGHT',
        p_field_template=>2042262243893469891,
        p_item_icon_css_classes=>'fa-user',
        p_item_template_options=>'#DEFAULT#',
        p_is_persistent=>'N'
    );
    wwv_flow_imp_page.create_page_process(
        p_id=>wwv_flow_imp.id({nid(7)}),
        p_process_sequence=>30,
        p_process_point=>'AFTER_SUBMIT',
        p_process_type=>'NATIVE_SESSION_STATE',
        p_process_name=>'Clear Page(s) Cache',
        p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
          'type', 'CLEAR_CACHE_CURRENT_PAGE')).to_clob,
        p_error_display_location=>'INLINE_IN_NOTIFICATION'
    );
    wwv_flow_imp_page.create_page_process(
        p_id=>wwv_flow_imp.id({nid(8)}),
        p_process_sequence=>10,
        p_process_point=>'BEFORE_HEADER',
        p_process_type=>'NATIVE_PLSQL',
        p_process_name=>'Get Username Cookie',
        p_process_sql_clob=>wwv_flow_string.join(wwv_flow_t_varchar2(
        ':P9999_USERNAME := apex_authentication.get_login_username_cookie;',
        ':P9999_REMEMBER := case when :P9999_USERNAME is not null then ''Y'' end;')),
        p_process_clob_language=>'PLSQL'
    );
    wwv_flow_imp_page.create_page_process(
        p_id=>wwv_flow_imp.id({nid(9)}),
        p_process_sequence=>20,
        p_process_point=>'AFTER_SUBMIT',
        p_process_type=>'NATIVE_INVOKE_API',
        p_process_name=>'Login',
        p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
          'package', 'APEX_AUTHENTICATION',
          'package_method', 'LOGIN',
          'type', 'PLSQL_PACKAGE')).to_clob,
        p_error_display_location=>'INLINE_IN_NOTIFICATION'
    );
    wwv_flow_imp_shared.create_invokeapi_comp_param(
        p_id=>wwv_flow_imp.id({nid(10)}),
        p_page_process_id=>wwv_flow_imp.id({nid(9)}),
        p_page_id=>9999,
        p_name=>'p_password',
        p_direction=>'IN',
        p_data_type=>'VARCHAR2',
        p_has_default=>false,
        p_display_sequence=>2,
        p_value_type=>'ITEM',
        p_value=>'P9999_PASSWORD'
    );
    wwv_flow_imp_shared.create_invokeapi_comp_param(
        p_id=>wwv_flow_imp.id({nid(11)}),
        p_page_process_id=>wwv_flow_imp.id({nid(9)}),
        p_page_id=>9999,
        p_name=>'p_set_persistent_auth',
        p_direction=>'IN',
        p_data_type=>'BOOLEAN',
        p_has_default=>true,
        p_display_sequence=>3,
        p_value_type=>'API_DEFAULT'
    );
    wwv_flow_imp_shared.create_invokeapi_comp_param(
        p_id=>wwv_flow_imp.id({nid(12)}),
        p_page_process_id=>wwv_flow_imp.id({nid(9)}),
        p_page_id=>9999,
        p_name=>'p_username',
        p_direction=>'IN',
        p_data_type=>'VARCHAR2',
        p_has_default=>false,
        p_display_sequence=>1,
        p_value_type=>'ITEM',
        p_value=>'P9999_USERNAME'
    );
    wwv_flow_imp_page.create_page_process(
        p_id=>wwv_flow_imp.id({nid(13)}),
        p_process_sequence=>10,
        p_process_point=>'AFTER_SUBMIT',
        p_process_type=>'NATIVE_INVOKE_API',
        p_process_name=>'Set Username Cookie',
        p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
          'package', 'APEX_AUTHENTICATION',
          'package_method', 'SEND_LOGIN_USERNAME_COOKIE',
          'type', 'PLSQL_PACKAGE')).to_clob,
        p_error_display_location=>'INLINE_IN_NOTIFICATION'
    );
    wwv_flow_imp_shared.create_invokeapi_comp_param(
        p_id=>wwv_flow_imp.id({nid(14)}),
        p_page_process_id=>wwv_flow_imp.id({nid(13)}),
        p_page_id=>9999,
        p_name=>'p_consent',
        p_direction=>'IN',
        p_data_type=>'BOOLEAN',
        p_has_default=>false,
        p_display_sequence=>2,
        p_value_type=>'ITEM',
        p_value=>'P9999_REMEMBER'
    );
    wwv_flow_imp_shared.create_invokeapi_comp_param(
        p_id=>wwv_flow_imp.id({nid(15)}),
        p_page_process_id=>wwv_flow_imp.id({nid(13)}),
        p_page_id=>9999,
        p_name=>'p_username',
        p_direction=>'IN',
        p_data_type=>'VARCHAR2',
        p_has_default=>false,
        p_display_sequence=>1,
        p_value_type=>'EXPRESSION',
        p_value_language=>'PLSQL',
        p_value=>'lower( :P9999_USERNAME )'
    );

    -- End import
    wwv_flow_imp.import_end(p_auto_install_sup_obj => false);
    commit;
end;
"""
    return sql


def execute_import(sql, host, port, service, user, password):
    """Execute the import SQL against the database."""
    print(f"Connecting to {host}:{port}/{service} as {user}...")
    conn = oracledb.connect(
        user=user,
        password=password,
        dsn=f"{host}:{port}/{service}"
    )
    cursor = conn.cursor()

    print(f"Executing import ({len(sql)} characters)...")
    try:
        cursor.execute(sql)
        conn.commit()
        print("✅ Import executed successfully!")
        return True
    except Exception as e:
        print(f"❌ Error during import: {e}")
        conn.rollback()
        import traceback
        traceback.print_exc()
        return False
    finally:
        cursor.close()
        conn.close()


def verify_app(app_id, host, port, service, user, password):
    """Check if the app was created."""
    conn = oracledb.connect(
        user=user,
        password=password,
        dsn=f"{host}:{port}/{service}"
    )
    cursor = conn.cursor()

    cursor.execute(
        "SELECT application_id, application_name, alias FROM apex_applications WHERE application_id = :1",
        [app_id]
    )
    row = cursor.fetchone()

    if row:
        print(f"\n✅ VERIFIED: App {row[0]} - {row[1]} (alias: {row[2]})")
        result = True
    else:
        print(f"\n❌ App {app_id} not found in apex_applications")
        cursor.execute("SELECT application_id, application_name FROM apex_applications ORDER BY application_id")
        print("\nExisting apps:")
        for r in cursor.fetchall():
            print(f"  {r[0]}: {r[1]}")
        result = False

    cursor.close()
    conn.close()
    return result


def main():
    parser = argparse.ArgumentParser(description='Import APEX starter app template')
    parser.add_argument('--id', type=int, required=True, help='Application ID (e.g. 200)')
    parser.add_argument('--name', type=str, required=True, help='Application name (e.g. "MY APP")')
    parser.add_argument('--alias', type=str, required=True, help='Application alias (e.g. "MY-APP")')
    parser.add_argument('--workspace', type=str, default=DEFAULT_WORKSPACE, help=f'Workspace name (default: {DEFAULT_WORKSPACE})')
    parser.add_argument('--host', type=str, default=DEFAULT_HOST, help=f'Database host (default: {DEFAULT_HOST})')
    parser.add_argument('--port', type=int, default=DEFAULT_PORT, help=f'Database port (default: {DEFAULT_PORT})')
    parser.add_argument('--service', type=str, default=DEFAULT_SERVICE, help=f'Database service (default: {DEFAULT_SERVICE})')
    parser.add_argument('--user', type=str, default=DEFAULT_USER, help=f'Database user (default: {DEFAULT_USER})')
    parser.add_argument('--password', type=str, default=DEFAULT_PASSWORD, help='Database password')

    args = parser.parse_args()

    # Generate SQL
    print(f"Generating import SQL for app {args.id} ({args.name})...")
    sql = generate_sql(args.id, args.name, args.alias, args.workspace)

    # Execute
    success = execute_import(
        sql,
        args.host, args.port, args.service,
        args.user, args.password
    )

    if success:
        verified = verify_app(args.id, args.host, args.port, args.service, args.user, args.password)
        if verified:
            print(f"\n🎉 App '{args.name}' (ID {args.id}) is ready!")
            print(f"   URL: https://{args.host}/ords/f?p={args.id}:1")
        else:
            sys.exit(1)
    else:
        sys.exit(1)


if __name__ == '__main__':
    main()
