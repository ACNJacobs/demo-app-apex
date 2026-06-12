import oracledb
import re

host = "secureaihub.maxapex.net"
port = 1521
service = "XEPDB1"
user = "SAH"
password = "u73AFTjKhUn4EyBvgpcX"

# Read the template
with open(r"d:\maxapex\templates\starter-app.sql", 'r', encoding='utf-8') as f:
    sql_template = f.read()

# Find all hardcoded IDs (15-19 digit numbers that look like APEX IDs)
# Exclude small numbers like 42, 1, 0, 9999, 26, etc.
id_pattern = re.compile(r'\b(\d{15,19})\b')
all_ids = set(id_pattern.findall(sql_template))

print(f"Found {len(all_ids)} unique hardcoded IDs in template")

# Connect to DB to get a safe starting point for new IDs
conn = oracledb.connect(user=user, password=password, dsn=f"{host}:{port}/{service}")
cursor = conn.cursor()

# Check what IDs already exist in key tables
# We need to query through apex views since SAH can't see APEX_260100 tables directly
cursor.execute("""
    SELECT MAX(TO_NUMBER(REGEXP_SUBSTR(object_name, '\\d+'))) 
    FROM all_objects 
    WHERE object_name LIKE 'WWV_FLOW%' 
    AND owner LIKE 'APEX%'
""")
max_obj_id = cursor.fetchone()[0] or 0

print(f"Max object ID in dictionary: {max_obj_id}")

# Generate new IDs starting from a safe offset
# Use a large offset to avoid any conflicts
base_offset = 9000000000000000000  # 9 quintillion

id_mapping = {}
for i, old_id in enumerate(sorted(all_ids, key=int)):
    new_id = str(base_offset + i)
    id_mapping[old_id] = new_id
    print(f"  {old_id} → {new_id}")

# Replace all IDs in the template
sql_modified = sql_template
for old_id, new_id in id_mapping.items():
    sql_modified = sql_modified.replace(old_id, new_id)

# Also replace &APP_ID. and &APP_NAME. references with safe strings
# (These are SQL*Plus substitution vars, not valid in Python execution)
sql_modified = sql_modified.replace("&APP_ID.", "200")
sql_modified = sql_modified.replace("&APP_NAME.", "TEST APP")
sql_modified = sql_modified.replace("&SESSION.", "0")
sql_modified = sql_modified.replace("&DEBUG.", "NO")
sql_modified = sql_modified.replace("&LOGOUT_URL.", "logout")
sql_modified = sql_modified.replace("&APP_USER.", "APP_USER")
sql_modified = sql_modified.replace("FLOW_ID.", "200")

# Remove SQL*Plus commands that don't work via oracledb
lines = sql_modified.split('\n')
clean_lines = []
for line in lines:
    stripped = line.strip().lower()
    if stripped.startswith('prompt '):
        continue
    if stripped.startswith('set '):
        continue
    if stripped.startswith('whenever '):
        continue
    clean_lines.append(line)

sql_clean = '\n'.join(clean_lines)

# Now we need to split by / on its own line for PL/SQL blocks
# But we also need to handle that some / are inside strings
# For simplicity, let's just execute the whole thing as one big PL/SQL block
# by wrapping in begin/end

# Actually, the file has multiple begin/end blocks separated by /
# We need to execute each one separately
statements = []
current = []
for line in sql_clean.split('\n'):
    if line.strip() == '/':
        stmt = '\n'.join(current).strip()
        if stmt:
            statements.append(stmt)
        current = []
    else:
        current.append(line)
if current:
    stmt = '\n'.join(current).strip()
    if stmt:
        statements.append(stmt)

print(f"\nPrepared {len(statements)} statements to execute")

# Set install parameters first
cursor.execute("""
    begin
        apex_application_install.set_workspace('SECURE_AI_HUB');
        apex_application_install.set_application_id(200);
        apex_application_install.set_application_name('TEST APP');
        apex_application_install.set_application_alias('TEST-APP');
    end;
""")
conn.commit()
print("Install parameters set")

# Execute each statement
for i, stmt in enumerate(statements, 1):
    if not stmt.strip() or stmt.strip().startswith('--'):
        continue
    
    print(f"Executing statement {i}/{len(statements)}...")
    try:
        cursor.execute(stmt)
        conn.commit()
    except Exception as e:
        print(f"ERROR on statement {i}: {e}")
        print(f"Preview: {stmt[:200]}...")
        # Continue anyway - some errors might be recoverable
        conn.rollback()

print("\n=== Verifying app creation ===")
cursor.execute("SELECT application_id, application_name, alias FROM apex_applications WHERE application_id = 200")
row = cursor.fetchone()
if row:
    print(f"✅ SUCCESS! App created: {row[0]} - {row[1]} ({row[2]})")
else:
    print("❌ App 200 not found")
    
    # Check all apps
    cursor.execute("SELECT application_id, application_name FROM apex_applications ORDER BY application_id")
    print("\nExisting apps:")
    for r in cursor.fetchall():
        print(f"  {r[0]}: {r[1]}")

cursor.close()
conn.close()
print("\nDone!")
