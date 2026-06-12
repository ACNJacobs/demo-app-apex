import oracledb

host = "secureaihub.maxapex.net"
port = 1521
service = "XEPDB1"
user = "SAH"
password = "u73AFTjKhUn4EyBvgpcX"

conn = oracledb.connect(user=user, password=password, dsn=f"{host}:{port}/{service}")
cursor = conn.cursor()

# Check the actual APEX_EXPORT package (via synonym)
cursor.execute("""
    SELECT text 
    FROM all_source 
    WHERE name = 'APEX_EXPORT' 
    AND type = 'PACKAGE' 
    ORDER BY line
""")

print("=== APEX_EXPORT package spec ===")
lines = cursor.fetchall()
for line in lines[:100]:  # First 100 lines
    text = line[0]
    if text.strip():
        print(text.rstrip())

cursor.close()
conn.close()
