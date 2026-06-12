import oracledb

host = "secureaihub.maxapex.net"
port = 1521
service = "XEPDB1"
user = "SAH"
password = "u73AFTjKhUn4EyBvgpcX"

conn = oracledb.connect(user=user, password=password, dsn=f"{host}:{port}/{service}")
cursor = conn.cursor()

# Check max IDs in key tables
tables = [
    "apex_260100.wwv_flows",
    "apex_260100.wwv_flow_lists",
    "apex_260100.wwv_flow_list_items",
    "apex_260100.wwv_flow_themes",
    "apex_260100.wwv_flow_authentications",
    "apex_260100.wwv_flow_steps",
    "apex_260100.wwv_flow_page_plugs",
    "apex_260100.wwv_flow_page_items",
    "apex_260100.wwv_flow_page_buttons",
    "apex_260100.wwv_flow_page_da_events",
    "apex_260100.wwv_flow_page_da_actions",
    "apex_260100.wwv_flow_page_processes",
    "apex_260100.wwv_flow_plugin_settings",
    "apex_260100.wwv_flow_invokeapi_comp_params"
]

print("=== Max IDs in APEX dictionary ===")
for table in tables:
    try:
        cursor.execute(f"SELECT MAX(id) FROM {table}")
        max_id = cursor.fetchone()[0]
        print(f"  {table.split('.')[1]:40s} MAX_ID = {max_id}")
    except Exception as e:
        print(f"  {table.split('.')[1]:40s} ERROR: {e}")

cursor.close()
conn.close()
