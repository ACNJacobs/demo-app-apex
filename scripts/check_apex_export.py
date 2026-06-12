import oracledb

host = "secureaihub.maxapex.net"
port = 1521
service = "XEPDB1"
user = "SAH"
password = "u73AFTjKhUn4EyBvgpcX"

conn = oracledb.connect(user=user, password=password, dsn=f"{host}:{port}/{service}")
cursor = conn.cursor()

# Check apex_export package specification
cursor.execute("""
    SELECT text 
    FROM all_source 
    WHERE name = 'APEX_EXPORT' 
    AND type = 'PACKAGE' 
    AND owner = 'APEX_260100'
    ORDER BY line
""")

print("=== APEX_EXPORT package spec ===")
lines = cursor.fetchall()
for line in lines[:50]:  # First 50 lines
    print(line[0])

cursor.close()
conn.close()
