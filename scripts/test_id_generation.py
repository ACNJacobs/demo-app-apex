import oracledb

host = "secureaihub.maxapex.net"
port = 1521
service = "XEPDB1"
user = "SAH"
password = "u73AFTjKhUn4EyBvgpcX"

conn = oracledb.connect(user=user, password=password, dsn=f"{host}:{port}/{service}")
cursor = conn.cursor()

# Test wwv_flow_imp.id() without arguments
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

# Test id() without argument
cursor.execute("SELECT wwv_flow_imp.id() FROM dual")
result = cursor.fetchone()[0]
print(f"wwv_flow_imp.id() (no arg) = {result}")

# Test id() with argument
cursor.execute("SELECT wwv_flow_imp.id(9999999999999999) FROM dual")
result2 = cursor.fetchone()[0]
print(f"wwv_flow_imp.id(9999999999999999) = {result2}")

# End import
cursor.execute("""
    begin
        wwv_flow_imp.import_end(p_auto_install_sup_obj => false);
    end;
""")
conn.commit()

cursor.close()
conn.close()
