import oracledb

host = "secureaihub.maxapex.net"
port = 1521
service = "XEPDB1"
user = "SAH"
password = "u73AFTjKhUn4EyBvgpcX"

conn = oracledb.connect(user=user, password=password, dsn=f"{host}:{port}/{service}")
cursor = conn.cursor()

# Try different parameter combinations for apex_export.get_application

# Try 1: Just application_id
try:
    cursor.execute("SELECT apex_export.get_application(200) FROM dual")
    row = cursor.fetchone()
    print(f"Try 1 (just app_id): {type(row[0]) if row else 'None'}")
except Exception as e:
    print(f"Try 1 failed: {e}")

# Try 2: With export_type
try:
    cursor.execute("SELECT apex_export.get_application(200, 'SQL') FROM dual")
    row = cursor.fetchone()
    print(f"Try 2 (app_id, type): {type(row[0]) if row else 'None'}")
except Exception as e:
    print(f"Try 2 failed: {e}")

# Try 3: Named parameters
try:
    cursor.execute("""
        SELECT apex_export.get_application(
            p_application_id => 200,
            p_export_type => 'SQL'
        ) FROM dual
    """)
    row = cursor.fetchone()
    print(f"Try 3 (named): {type(row[0]) if row else 'None'}")
except Exception as e:
    print(f"Try 3 failed: {e}")

# Try 4: Check if it's a pipelined function
try:
    cursor.execute("""
        SELECT * FROM TABLE(apex_export.get_application(200))
    """)
    rows = cursor.fetchall()
    print(f"Try 4 (table): {len(rows)} rows")
except Exception as e:
    print(f"Try 4 failed: {e}")

# Try 5: Check wwv_flow_export_api
try:
    cursor.execute("""
        SELECT wwv_flow_export_api.get_application(200) FROM dual
    """)
    row = cursor.fetchone()
    print(f"Try 5 (wwv_flow_export_api): {type(row[0]) if row else 'None'}")
except Exception as e:
    print(f"Try 5 failed: {e}")

cursor.close()
conn.close()
