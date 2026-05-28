BEGIN
  DBMS_NETWORK_ACL_ADMIN.CREATE_ACL(
    acl         => 'docker_internal_acl.xml',
    description => 'Docker Internal Network Access',
    principal   => 'APEX_260100',
    is_grant    => TRUE,
    privilege   => 'connect'
  );
  DBMS_NETWORK_ACL_ADMIN.ADD_PRIVILEGE(
    acl       => 'docker_internal_acl.xml',
    principal => 'APEX_260100',
    is_grant  => TRUE,
    privilege => 'resolve'
  );
  DBMS_NETWORK_ACL_ADMIN.ADD_PRIVILEGE(
    acl       => 'docker_internal_acl.xml',
    principal => 'APP_DATA',
    is_grant  => TRUE,
    privilege => 'connect'
  );
  DBMS_NETWORK_ACL_ADMIN.ADD_PRIVILEGE(
    acl       => 'docker_internal_acl.xml',
    principal => 'APP_DATA',
    is_grant  => TRUE,
    privilege => 'resolve'
  );
  DBMS_NETWORK_ACL_ADMIN.ASSIGN_ACL(
    acl  => 'docker_internal_acl.xml',
    host => 'host.docker.internal'
  );
  COMMIT;
END;
/
exit;
