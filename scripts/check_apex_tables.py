import oracledb

host = "secureaihub.maxapex.net"
port = 1521
service = "XEPDB1"
user = "SAH"
password = "u73AFTjKhUn4EyBvgpcX"

conn = oracledb.connect(user=user, password=password, dsn=f"{host}:{port}/{service}")
cursor = conn.cursor()

# Check what APEX tables exist that SAH can see
cursor.execute("""
    SELECT owner, table_name 
    FROM all_tables 
    WHERE table_name LIKE 'WWV_FLOW%' 
    AND owner LIKE 'APEX%'
    ORDER BY owner, table_name
""")

print("=== APEX tables visible to SAH ===")
for row in cursor.fetchall():
    print(f"  {row[0]}.{row[1]}")

cursor.close()
conn.close()
