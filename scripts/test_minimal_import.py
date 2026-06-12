import oracledb

host = "secureaihub.maxapex.net"
port = 1521
service = "XEPDB1"
user = "SAH"
password = "u73AFTjKhUn4EyBvgpcX"

conn = oracledb.connect(user=user, password=password, dsn=f"{host}:{port}/{service}")
cursor = conn.cursor()

# First, set install parameters
cursor.execute("""
    begin
        apex_application_install.set_workspace('SECURE_AI_HUB');
        apex_application_install.set_application_id(200);
        apex_application_install.set_application_name('TEST APP');
        apex_application_install.set_application_alias('TEST-APP');
    end;
""")
conn.commit()

# Now do a minimal import test - just import_begin and import_end
print("Testing minimal import...")
try:
    cursor.execute("""
        begin
            wwv_flow_imp.import_begin (
                p_version_yyyy_mm_dd=>'2026.03.30',
                p_release=>'26.1.0',
                p_default_workspace_id=>4396054143779997,
                p_default_application_id=>200,
                p_default_id_offset=>0,
                p_default_owner=>'SAH'
            );
        end;
    """)
    conn.commit()
    print("import_begin succeeded")
    
    # Check g_flow_id
    cursor.execute("SELECT wwv_flow.g_flow_id FROM dual")
    flow_id = cursor.fetchone()[0]
    print(f"g_flow_id = {flow_id}")
    
    # Now do import_end
    cursor.execute("""
        begin
            wwv_flow_imp.import_end(p_auto_install_sup_obj => false);
            commit;
        end;
    """)
    conn.commit()
    print("import_end succeeded")
    
except Exception as e:
    print(f"Error: {e}")
    conn.rollback()

# Check if app exists
cursor.execute("SELECT application_id, application_name, alias FROM apex_applications WHERE application_id = 200")
row = cursor.fetchone()
if row:
    print(f"\n✅ App created: {row[0]} - {row[1]} ({row[2]})")
else:
    print("\n❌ App 200 still not found")
    
    # Check wwv_flows table directly
    cursor.execute("SELECT id, name, alias FROM apex_260100.wwv_flows WHERE id = 200")
    row = cursor.fetchone()
    if row:
        print(f"But found in wwv_flows: {row}")

cursor.close()
conn.close()
