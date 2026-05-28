SET PAGESIZE 200 LINESIZE 200 FEEDBACK OFF
COL grantee FORMAT A20
COL granted_role FORMAT A40
COL role_name FORMAT A40
PROMPT === Roles granted to APP_DATA ===
SELECT grantee, granted_role FROM dba_role_privs WHERE grantee='APP_DATA' ORDER BY 2;
PROMPT
PROMPT === ORDS role tables ===
SELECT table_name FROM dba_tables WHERE owner='ORDS_METADATA' AND table_name LIKE '%ROLE%';
PROMPT
PROMPT === ORDS user_roles columns ===
SELECT column_name FROM all_tab_columns WHERE owner='ORDS_METADATA' AND table_name='ORDS_USER_ROLES';
PROMPT
PROMPT === All ORDS roles ===
SELECT * FROM ords_metadata.ords_user_roles WHERE ROWNUM<5;
EXIT
