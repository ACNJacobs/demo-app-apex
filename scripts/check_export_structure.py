import oracledb

host = "secureaihub.maxapex.net"
port = 1521
service = "XEPDB1"
user = "SAH"
password = "u73AFTjKhUn4EyBvgpcX"

conn = oracledb.connect(user=user, password=password, dsn=f"{host}:{port}/{service}")
cursor = conn.cursor()

# Check the structure of the returned object
cursor.execute("SELECT * FROM TABLE(apex_export.get_application(200))")

# Get column info
print("=== Column info ===")
for desc in cursor.description:
    print(f"  {desc[0]}: {desc[1]}")

# Fetch first row
row = cursor.fetchone()
if row:
    print(f"\n=== First row ===")
    print(f"  Number of columns: {len(row)}")
    for i, val in enumerate(row):
        print(f"  Column {i}: type={type(val)}, value={repr(str(val)[:100])}")

cursor.close()
conn.close()
