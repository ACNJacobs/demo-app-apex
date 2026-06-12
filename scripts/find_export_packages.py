import oracledb

host = "secureaihub.maxapex.net"
port = 1521
service = "XEPDB1"
user = "SAH"
password = "u73AFTjKhUn4EyBvgpcX"

conn = oracledb.connect(user=user, password=password, dsn=f"{host}:{port}/{service}")
cursor = conn.cursor()

# Find packages related to export
cursor.execute("""
    SELECT owner, object_name 
    FROM all_objects 
    WHERE object_name LIKE '%EXPORT%' 
    AND object_type = 'PACKAGE'
    AND owner LIKE 'APEX%'
    ORDER BY owner, object_name
""")

print("=== Export-related packages ===")
for row in cursor.fetchall():
    print(f"  {row[0]}.{row[1]}")

# Also check for APEX_EXPORT specifically
cursor.execute("""
    SELECT owner, object_name, object_type
    FROM all_objects 
    WHERE object_name = 'APEX_EXPORT'
    ORDER BY owner, object_type
""")

print("\n=== APEX_EXPORT objects ===")
for row in cursor.fetchall():
    print(f"  {row[0]}.{row[1]} ({row[2]})")

cursor.close()
conn.close()
