GRANT CREATE SESSION, ALTER SESSION TO oggadmin;
GRANT RESOURCE TO oggadmin;
GRANT SELECT ANY DICTIONARY TO oggadmin;
GRANT FLASHBACK ANY TABLE TO oggadmin;
GRANT SELECT ANY TABLE TO oggadmin;
GRANT SELECT_CATALOG_ROLE TO rds_master_user_name WITH ADMIN OPTION;
exec rdsadmin.rdsadmin_util.grant_sys_object ('DBA_CLUSTERS', 'OGGADM1');
GRANT EXECUTE ON DBMS_FLASHBACK TO oggadmin;
GRANT SELECT ON SYS.V_$DATABASE TO oggadmin;
GRANT ALTER ANY TABLE TO oggadmin;
