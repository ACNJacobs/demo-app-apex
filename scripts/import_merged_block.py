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

# Step 1: Replace substitution variables with safe strings
sql_clean = sql_template.replace("&APP_ID.", "200")
sql_clean = sql_clean.replace("&APP_NAME.", "TEST APP")
sql_clean = sql_clean.replace("&SESSION.", "0")
sql_clean = sql_clean.replace("&DEBUG.", "NO")
sql_clean = sql_clean.replace("&LOGOUT_URL.", "logout")
sql_clean = sql_clean.replace("&APP_USER.", "APP_USER")
sql_clean = sql_clean.replace("FLOW_ID.", "200")

# Step 2: Remove SQL*Plus commands and prompts
lines = sql_clean.split('\n')
plsql_lines = []
for line in lines:
    stripped = line.strip().lower()
    if stripped.startswith('prompt '):
        continue
    if stripped.startswith('set '):
        continue
    if stripped.startswith('whenever '):
        continue
    if stripped == '/':
        continue
    plsql_lines.append(line)

# Step 3: Extract all begin...end; blocks and merge into one
plsql_text = '\n'.join(plsql_lines)

# Find all begin...end; blocks
blocks = []
pattern = re.compile(r'begin\s+(.*?)\s+end\s*;', re.DOTALL)
for match in pattern.finditer(plsql_text):
    block_content = match.group(1).strip()
    if block_content:
        blocks.append(block_content)

print(f"Found {len(blocks)} PL/SQL blocks to merge")

# Step 4: Build one mega PL/SQL block
# We need to handle that some blocks contain 'commit;' which is fine in PL/SQL
# But we need to remove duplicate 'begin' and 'end' from inner blocks

merged_statements = []
for block in blocks:
    # Remove inner begin/end if they exist (nested blocks)
    # Actually, let's just keep the statements as-is
    # But we need to handle that some statements are standalone (not in begin/end)
    merged_statements.append(block)

# Build the final SQL
final_sql = "begin\n"
final_sql += "apex_application_install.set_workspace('SECURE_AI_HUB');\n"
final_sql += "apex_application_install.set_application_id(200);\n"
final_sql += "apex_application_install.set_application_name('TEST APP');\n"
final_sql += "apex_application_install.set_application_alias('TEST-APP');\n\n"

for stmt in merged_statements:
    final_sql += stmt + "\n\n"

final_sql += "commit;\n"
final_sql += "end;"

# Check size
print(f"Final SQL size: {len(final_sql)} characters")
if len(final_sql) > 32000:
    print("WARNING: SQL exceeds 32KB, may fail in Oracle!")

# Write to file for inspection
with open(r"d:\maxapex\scripts\merged_import.sql", 'w', encoding='utf-8') as f:
    f.write(final_sql)
print("Written to d:\maxapex\scripts\merged_import.sql")

# Step 5: Execute
conn = oracledb.connect(user=user, password=password, dsn=f"{host}:{port}/{service}")
cursor = conn.cursor()

print("\nExecuting merged PL/SQL block...")
try:
    cursor.execute(final_sql)
    conn.commit()
    print("✅ Block executed successfully!")
except Exception as e:
    print(f"❌ Error: {e}")
    conn.rollback()
    import traceback
    traceback.print_exc()

# Verify
print("\n=== Checking for app 200 ===")
cursor.execute("SELECT application_id, application_name, alias FROM apex_applications WHERE application_id = 200")
row = cursor.fetchone()
if row:
    print(f"✅ SUCCESS! App created: {row[0]} - {row[1]} ({row[2]})")
else:
    print("❌ App 200 not found")
    cursor.execute("SELECT application_id, application_name FROM apex_applications ORDER BY application_id")
    print("\nExisting apps:")
    for r in cursor.fetchall():
        print(f"  {r[0]}: {r[1]}")

cursor.close()
conn.close()
