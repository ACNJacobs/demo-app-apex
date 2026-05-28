SET PAGESIZE 200 LINESIZE 200 FEEDBACK OFF
COL username FORMAT A22
COL account_status FORMAT A20
COL schema FORMAT A20
COL url_mapping_pattern FORMAT A30
PROMPT === DB users ===
SELECT username, account_status, TO_CHAR(lock_date,'YYYY-MM-DD') lock_date, TO_CHAR(expiry_date,'YYYY-MM-DD') expiry
FROM dba_users
WHERE username IN ('APP_DATA','ORDS_PUBLIC_USER','APEX_PUBLIC_USER','APEX_REST_PUBLIC_USER','ORDS_METADATA');
PROMPT
PROMPT === ORDS-enabled schemas ===
SELECT column_name FROM all_tab_columns WHERE owner='ORDS_METADATA' AND table_name='ORDS_SCHEMAS';
SELECT * FROM ords_metadata.ords_schemas;
PROMPT
PROMPT === APEX workspaces ===
SELECT workspace, workspace_id FROM apex_workspaces;
EXIT
