import oracledb

host = "secureaihub.maxapex.net"
port = 1521
service = "XEPDB1"
user = "SAH"
password = "u73AFTjKhUn4EyBvgpcX"

conn = oracledb.connect(user=user, password=password, dsn=f"{host}:{port}/{service}")
cursor = conn.cursor()

print("=== All applications ===")
cursor.execute("SELECT application_id, workspace, application_name, alias FROM apex_applications ORDER BY application_id")
for row in cursor.fetchall():
    print(f"  {row[0]} | {row[1]} | {row[2]} | {row[3]}")

print("\n=== App 200 details ===")
cursor.execute("SELECT * FROM apex_applications WHERE application_id = 200")
cols = [d[0] for d in cursor.description]
for row in cursor.fetchall():
    for c, v in zip(cols, row):
        print(f"  {c}: {v}")

print("\n=== wwv_flow.g_flow_id ===")
try:
    cursor.execute("SELECT wwv_flow.g_flow_id FROM dual")
    print(f"  g_flow_id = {cursor.fetchone()[0]}")
except Exception as e:
    print(f"  Error: {e}")

print("\n=== Check for any app with 'TEST' in name ===")
cursor.execute("SELECT application_id, application_name, alias FROM apex_applications WHERE lower(application_name) LIKE '%test%'")
for row in cursor.fetchall():
    print(f"  {row[0]} | {row[1]} | {row[2]}")

cursor.close()
conn.close()
