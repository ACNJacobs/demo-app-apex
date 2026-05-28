BEGIN
  DBMS_NETWORK_ACL_ADMIN.CREATE_ACL(
    acl         => 'ollama_acl.xml',
    description => 'Ollama Network Access',
    principal   => 'APEX_260100',
    is_grant    => TRUE,
    privilege   => 'connect'
  );
  DBMS_NETWORK_ACL_ADMIN.ADD_PRIVILEGE(
    acl       => 'ollama_acl.xml',
    principal => 'APEX_260100',
    is_grant  => TRUE,
    privilege => 'resolve'
  );
  DBMS_NETWORK_ACL_ADMIN.ADD_PRIVILEGE(
    acl       => 'ollama_acl.xml',
    principal => 'APEX_260100',
    is_grant  => TRUE,
    privilege => 'use-client-certificates'
  );
  DBMS_NETWORK_ACL_ADMIN.ADD_PRIVILEGE(
    acl       => 'ollama_acl.xml',
    principal => 'APP_DATA',
    is_grant  => TRUE,
    privilege => 'connect'
  );
  DBMS_NETWORK_ACL_ADMIN.ADD_PRIVILEGE(
    acl       => 'ollama_acl.xml',
    principal => 'APP_DATA',
    is_grant  => TRUE,
    privilege => 'resolve'
  );
  DBMS_NETWORK_ACL_ADMIN.ADD_PRIVILEGE(
    acl       => 'ollama_acl.xml',
    principal => 'APP_DATA',
    is_grant  => TRUE,
    privilege => 'use-client-certificates'
  );
  DBMS_NETWORK_ACL_ADMIN.ASSIGN_ACL(
    acl  => 'ollama_acl.xml',
    host => 'ollama.com'
  );
  COMMIT;
END;
/
exit;
