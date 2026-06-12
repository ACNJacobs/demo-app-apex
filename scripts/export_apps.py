import oracledb
import os

host = "secureaihub.maxapex.net"
port = 1521
service = "XEPDB1"
user = "SAH"
password = "u73AFTjKhUn4EyBvgpcX"

apps = [
    {"id": 200, "alias": "TEST-APP", "name": "TEST APP"},
    {"id": 300, "alias": "DEMO-APP", "name": "DEMO APP"},
    {"id": 400, "alias": "INSPECT-APP", "name": "INSPECT APP"},
]

conn = oracledb.connect(user=user, password=password, dsn=f"{host}:{port}/{service}")
cursor = conn.cursor()

for app in apps:
    app_id = app["id"]
    alias = app["alias"]
    name = app["name"]
    
    print(f"\n=== Exporting app {app_id} - {name} ===")
    
    # Create output directory
    output_dir = f"d:\\maxapex\\apex_app\\{alias}"
    os.makedirs(output_dir, exist_ok=True)
    os.makedirs(f"{output_dir}\\pages", exist_ok=True)
    os.makedirs(f"{output_dir}\\shared-components", exist_ok=True)
    
    # Export as SQL
    try:
        cursor.execute("SELECT name, contents FROM TABLE(apex_export.get_application(:1))", [app_id])
        
        rows = cursor.fetchall()
        print(f"  Got {len(rows)} export file(s)")
        
        total_chars = 0
        for i, row in enumerate(rows):
            filename = row[0]
            contents_lob = row[1]
            
            # Read CLOB content
            if contents_lob is not None:
                contents = contents_lob.read()
            else:
                contents = ""
            
            total_chars += len(contents)
            print(f"  File {i+1}: {filename} ({len(contents)} chars)")
            
            # Save file
            file_path = f"{output_dir}\\{filename}"
            with open(file_path, 'w', encoding='utf-8') as f:
                f.write(contents)
        
        print(f"  ✅ SQL export complete: {total_chars} chars total")
        
    except Exception as e:
        print(f"  ❌ SQL export failed: {e}")
        import traceback
        traceback.print_exc()

    # Export as APEXLANG
    try:
        cursor.execute("SELECT name, contents FROM TABLE(apex_export.get_application(:1, 'APEXLANG'))", [app_id])
        
        rows = cursor.fetchall()
        print(f"  Got {len(rows)} APEXLANG file(s)")
        
        total_chars = 0
        for i, row in enumerate(rows):
            filename = row[0]
            contents_lob = row[1]
            
            if contents_lob is not None:
                contents = contents_lob.read()
            else:
                contents = ""
            
            total_chars += len(contents)
            print(f"  File {i+1}: {filename} ({len(contents)} chars)")
            
            # Save with -apeclang suffix
            base_name = filename.replace('.sql', '')
            file_path = f"{output_dir}\\{base_name}-apeclang.sql"
            with open(file_path, 'w', encoding='utf-8') as f:
                f.write(contents)
        
        print(f"  ✅ APEXLANG export complete: {total_chars} chars total")
        
    except Exception as e:
        print(f"  ⚠️ APEXLANG export failed: {e}")

cursor.close()
conn.close()

print("\n=== Export complete ===")
print("Files saved under apex_app/<alias>/")
