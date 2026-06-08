SET PAGESIZE 200 LINESIZE 200 FEEDBACK OFF
COL grantee FORMAT A20
COL granted_role FORMAT A40
PROMPT === Roles granted to APP_DATA ===
SELECT grantee, granted_role FROM dba_role_privs WHERE grantee='APP_DATA' ORDER BY 2;
PROMPT
PROMPT === ORDS role tables ===
SELECT table_name FROM dba_tables WHERE owner='ORDS_METADATA' AND table_name LIKE '%ROLE%';
PROMPT
PROMPT === ORDS SEC_ROLES columns ===
SELECT column_name FROM all_tab_columns WHERE owner='ORDS_METADATA' AND table_name='SEC_ROLES' ORDER BY column_id;
PROMPT
PROMPT === Sample ORDS roles (SEC_ROLES) ===
SELECT * FROM ords_metadata.sec_roles WHERE ROWNUM<5;
PROMPT
PROMPT === Sample ORDS role mappings (SEC_ROLE_MAPPINGS) ===
SELECT * FROM ords_metadata.sec_role_mappings WHERE ROWNUM<5;
EXIT
