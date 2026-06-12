import oracledb

host = "secureaihub.maxapex.net"
port = 1521
service = "XEPDB1"
user = "SAH"
password = "u73AFTjKhUn4EyBvgpcX"

# Ultra-minimal app creation in ONE PL/SQL block
# No complex strings, no multi-line JS, no & variables

sql = """
begin
    -- Set install parameters
    apex_application_install.set_workspace('SECURE_AI_HUB');
    apex_application_install.set_application_id(200);
    apex_application_install.set_application_name('TEST APP');
    apex_application_install.set_application_alias('TEST-APP');

    -- Begin import
    wwv_flow_imp.import_begin (
        p_version_yyyy_mm_dd=>'2026.03.30',
        p_release=>'26.1.0',
        p_default_workspace_id=>4396054143779997,
        p_default_application_id=>200,
        p_default_id_offset=>0,
        p_default_owner=>'SAH'
    );

    -- Remove if exists
    begin
        wwv_flow_imp.remove_flow(wwv_flow.g_flow_id);
    exception when others then null;
    end;

    -- Create minimal app
    wwv_imp_workspace.create_flow(
        p_id=>wwv_flow.g_flow_id,
        p_owner=>'SAH',
        p_name=>'TEST APP',
        p_alias=>'TEST-APP',
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
        p_logo_text=>'TEST APP',
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
        p_home_url=>'f?p=200:1:0::NO',
        p_login_url=>'f?p=200:LOGIN:0::NO',
        p_theme_style_by_user_pref=>false,
        p_built_with_love=>false,
        p_global_page_id=>null
    );

    -- Create global page (required by FK constraint)
    wwv_flow_imp_page.create_page(
        p_id=>0,
        p_name=>'Global Page',
        p_reload_on_submit=>null,
        p_warn_on_unsaved_changes=>null,
        p_autocomplete_on_off=>'OFF',
        p_protection_level=>'D'
    );

    -- Create minimal home page
    wwv_flow_imp_page.create_page(
        p_id=>1,
        p_name=>'Home',
        p_alias=>'HOME',
        p_step_title=>'TEST APP',
        p_autocomplete_on_off=>'OFF',
        p_page_template_options=>'#DEFAULT#',
        p_protection_level=>'C'
    );

    wwv_flow_imp_page.create_page_plug(
        p_id=>wwv_flow_imp.id(99999999999990001),
        p_plug_name=>'Welcome',
        p_region_template_options=>'#DEFAULT#',
        p_plug_template=>4073835273271169698,
        p_plug_display_sequence=>10,
        p_plug_item_display_point=>'ABOVE',
        p_location=>null,
        p_plug_source=>'Welcome to TEST APP',
        p_plug_source_type=>'NATIVE_STATIC_CONTENT'
    );

    -- End import
    wwv_flow_imp.import_end(p_auto_install_sup_obj => false);
    commit;
end;
"""

print("Connecting to database...")
conn = oracledb.connect(user=user, password=password, dsn=f"{host}:{port}/{service}")
cursor = conn.cursor()

print("Executing ultra-minimal import...")
print(f"SQL length: {len(sql)} characters")

try:
    cursor.execute(sql)
    conn.commit()
    print("\n✅ Import executed successfully!")
except Exception as e:
    print(f"\n❌ Error: {e}")
    conn.rollback()
    import traceback
    traceback.print_exc()

# Verify
print("\n=== Checking for app 200 ===")
cursor.execute("SELECT application_id, application_name, alias FROM apex_applications WHERE application_id = 200")
row = cursor.fetchone()
if row:
    print(f"✅ SUCCESS! App created: {row[0]} - {row[1]} ({row[2]})")
else:
    print("❌ App 200 not found")
    cursor.execute("SELECT application_id, application_name FROM apex_applications ORDER BY application_id")
    print("\nExisting apps:")
    for r in cursor.fetchall():
        print(f"  {r[0]}: {r[1]}")

cursor.close()
conn.close()
