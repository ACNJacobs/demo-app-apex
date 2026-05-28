BEGIN
    DBMS_NETWORK_ACL_ADMIN.APPEND_HOST_ACE(
        host => '*',
        ace => xs$ace_type(privilege_list => xs$name_list('connect', 'resolve', 'use-client-certificates', 'use-passwords'),
                           principal_name => 'PUBLIC',
                           principal_type => xs_acl.ptype_db)
    );
    COMMIT;
END;
/
exit;
