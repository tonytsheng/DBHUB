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

-- from aws blog implement multi master replication with rds custom for oracle

create user gguser identified by gguser default tablespace users quota unlimited on users;
grant create session,connect,resource to gguser;
exec dbms_goldengate_auth.grant_admin_privilege (grantee=>'gguser', privilege_type=>'apply', grant_select_privileges=>true, do_grants=>TRUE);
exec dbms_goldengate_auth.grant_admin_privilege (grantee=>'gguser',privilege_type=>'capture',grant_select_privileges=>true,do_grants=>TRUE);
GRANT CREATE SESSION, ALTER SESSION TO gguser;
GRANT RESOURCE TO gguser;
GRANT SELECT ANY DICTIONARY TO gguser;
GRANT FLASHBACK ANY TABLE TO gguser;
GRANT SELECT ANY TABLE TO gguser;
GRANT SELECT_CATALOG_ROLE TO gguser WITH ADMIN OPTION;
GRANT EXECUTE ON DBMS_FLASHBACK TO gguser;
GRANT SELECT ON SYS.V_$DATABASE TO gguser;
GRANT ALTER ANY TABLE TO gguser;
GRANT CREATE SESSION TO gguser;
GRANT ALTER SESSION TO gguser;
GRANT CREATE CLUSTER TO gguser;
GRANT CREATE INDEXTYPE TO gguser;
GRANT CREATE OPERATOR TO gguser;
GRANT CREATE PROCEDURE TO gguser;
GRANT CREATE SEQUENCE TO gguser;
GRANT CREATE TABLE TO gguser;
GRANT CREATE TRIGGER TO gguser;
GRANT CREATE TYPE TO gguser;
GRANT SELECT ANY DICTIONARY TO gguser;
GRANT CREATE ANY TABLE TO gguser;
GRANT ALTER ANY TABLE TO gguser;
GRANT LOCK ANY TABLE TO gguser;
GRANT SELECT ANY TABLE TO gguser;
GRANT INSERT ANY TABLE TO gguser;
GRANT UPDATE ANY TABLE TO gguser;
GRANT DELETE ANY TABLE TO gguser;

