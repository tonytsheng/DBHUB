drop user dmsuser;
create tablespace dmsuser;
create user dmsuser identified by dmsuser default tablespace dmsuser;
create user dmsuser identified by dmsuser default tablespace system;
grant create session to dmsuser;
grant create any table to dmsuser;
grant drop any table to dmsuser;
grant unlimited tablespace to dmsuser;
grant execute any procedure to dmsuser;
grant alter any table to dmsuser;
grant update any table to dmsuser;
grant create any index to dmsuser;
exec rdsadmin.rdsadmin_util.grant_sys_object('V_$ARCHIVED_LOG','DMS_USER');
exec rdsadmin.rdsadmin_util.grant_sys_object('V_$LOG','DMS_USER');
exec rdsadmin.rdsadmin_util.grant_sys_object('V_$LOGFILE','DMS_USER');
exec rdsadmin.rdsadmin_util.grant_sys_object('V_$DATABASE','DMS_USER');
exec rdsadmin.rdsadmin_util.grant_sys_object('V_$THREAD','DMS_USER');
exec rdsadmin.rdsadmin_util.grant_sys_object('V_$PARAMETER','DMS_USER');
exec rdsadmin.rdsadmin_util.grant_sys_object('V_$NLS_PARAMETERS','DMS_USER');
exec rdsadmin.rdsadmin_util.grant_sys_object('V_$TIMEZONE_NAMES','DMS_USER');
exec rdsadmin.rdsadmin_util.grant_sys_object('V_$TRANSACTION','DMS_USER');
exec rdsadmin.rdsadmin_util.grant_sys_object('DBA_OBJECTS','DMS_USER'); 
exec rdsadmin.rdsadmin_util.grant_sys_object('DBA_REGISTRY','DMS_USER');
exec rdsadmin.rdsadmin_util.grant_sys_object('OBJ$','DMS_USER');
grant SELECT on ALL_INDEXES to dmsuser;
grant SELECT on ALL_OBJECTS to dmsuser;
grant SELECT on ALL_TABLES to dmsuser;
grant SELECT on ALL_USERS to dmsuser;
grant SELECT on ALL_CATALOG to dmsuser;
grant SELECT on ALL_CONSTRAINTS to dmsuser;
grant SELECT on ALL_CONS_COLUMNS to dmsuser;
grant SELECT on ALL_TAB_COLS to dmsuser;
grant SELECT on ALL_IND_COLUMNS to dmsuser;
grant SELECT on ALL_LOG_GROUPS to dmsuser;
GRANT SELECT on SYS.DBA_REGISTRY to dmsuser;
GRANT SELECT on SYS.OBJ$ to dmsuser;
GRANT SELECT on DBA_TABLESPACES to dmsuser;
GRANT SELECT on ALL_TAB_PARTITIONS to dmsuser;
GRANT SELECT on ALL_ENCRYPTED_COLUMNS to dmsuser;
GRANT SELECT ANY TRANSACTION to dmsuser;
GRANT SELECT on V_$LOGMNR_LOGS to dmsuser;
GRANT SELECT on V_$LOGMNR_CONTENTS to dmsuser;
GRANT SELECT on V_$LOG to dmsuser;
GRANT SELECT on V_$ARCHIVED_LOG to dmsuser;
GRANT SELECT on V_$LOGFILE to dmsuser;
GRANT SELECT on V_$TRANSACTION to dmsuser;
exec rdsadmin.rdsadmin_util.grant_sys_object('DBA_TABLESPACES','DMS_USER');
grant SELECT on ALL_TAB_PARTITIONS to dmsuser;
exec rdsadmin.rdsadmin_util.grant_sys_object('ALL_ENCRYPTED_COLUMNS','DMS_USER');
grant SELECT on ALL_VIEWS  to dmsuser;

exec rdsadmin.rdsadmin_util.grant_sys_object('DBMS_LOGMNR','DMS_USER');
exec rdsadmin.rdsadmin_util.grant_sys_object('V_$LOGMNR_LOGS','DMS_USER');
exec rdsadmin.rdsadmin_util.grant_sys_object('V_$LOGMNR_CONTENTS','DMS_USER');
grant logmining to dmsuser;

-- for use with SCT
grant SELECT ANY DICTIONARY to dmsuser;

grant select_catalog_role to dmsuser;
grant execute_catalog_role to dmsuser;

grant SELECT ANY TRANSACTION to dmsuser;
grant SELECT on V$NLS_PARAMETERS to dmsuser;
grant SELECT on V$TIMEZONE_NAMES to dmsuser;
grant SELECT on ALL_INDEXES to dmsuser;
grant SELECT on ALL_OBJECTS to dmsuser;
grant SELECT on DBA_OBJECTS to dmsuser;
grant SELECT on ALL_TABLES to dmsuser;
grant SELECT on ALL_USERS to dmsuser;
grant SELECT on ALL_CATALOG to dmsuser;
grant SELECT on ALL_CONSTRAINTS to dmsuser;
grant SELECT on ALL_CONS_COLUMNS to dmsuser;
grant SELECT on ALL_TAB_COLS to dmsuser;
grant SELECT on ALL_IND_COLUMNS to dmsuser;
grant DROP ANY TABLE to dmsuser;
grant SELECT ANY TABLE to dmsuser;
grant INSERT ANY TABLE to dmsuser;
grant UPDATE ANY TABLE to dmsuser;
grant CREATE ANY VIEW to dmsuser;
grant DROP ANY VIEW to dmsuser;
grant CREATE ANY PROCEDURE to dmsuser;
grant ALTER ANY PROCEDURE to dmsuser;
grant DROP ANY PROCEDURE to dmsuser;
grant CREATE ANY SEQUENCE to dmsuser;
grant ALTER ANY SEQUENCE to dmsuser;
grant DROP ANY SEQUENCE to dmsuser;
grant SELECT on DBA_USERS to dmsuser;
grant SELECT on DBA_TAB_PRIVS to dmsuser;
grant SELECT on DBA_OBJECTS to dmsuser;
grant SELECT on DBA_SYNONYMS to dmsuser;
grant SELECT on DBA_SEQUENCES to dmsuser;
grant SELECT on DBA_TYPES to dmsuser;
grant SELECT on DBA_INDEXES to dmsuser;
grant SELECT on DBA_TABLES to dmsuser;
grant SELECT on DBA_TRIGGERS to dmsuser;

grant select,insert,update,alter,delete on fly1.airline to dmsuser;
grant select,insert,update,alter,delete on fly1.airport to dmsuser;
grant select,insert,update,alter,delete on fly1.employee to dmsuser;
grant select,insert,update,alter,delete on fly1.reservation to dmsuser;

exec rdsadmin.rdsadmin_util.grant_sys_object('V_$ARCHIVED_LOG','dmsuser','SELECT');
exec rdsadmin.rdsadmin_util.grant_sys_object('V_$LOG','dmsuser','SELECT');
exec rdsadmin.rdsadmin_util.grant_sys_object('V_$LOGFILE','dmsuser','SELECT');
exec rdsadmin.rdsadmin_util.grant_sys_object('V_$DATABASE','dmsuser','SELECT');
exec rdsadmin.rdsadmin_util.grant_sys_object('V_$THREAD','dmsuser','SELECT');
exec rdsadmin.rdsadmin_util.grant_sys_object('V_$PARAMETER','dmsuser','SELECT');
exec rdsadmin.rdsadmin_util.grant_sys_object('V_$NLS_PARAMETERS','dmsuser','SELECT');
exec rdsadmin.rdsadmin_util.grant_sys_object('V_$TIMEZONE_NAMES','dmsuser','SELECT');
exec rdsadmin.rdsadmin_util.grant_sys_object('V_$TRANSACTION','dmsuser','SELECT');
exec rdsadmin.rdsadmin_util.grant_sys_object('DBA_REGISTRY','dmsuser','SELECT');
exec rdsadmin.rdsadmin_util.grant_sys_object('OBJ$','dmsuser','SELECT');
exec rdsadmin.rdsadmin_util.grant_sys_object('ALL_ENCRYPTED_COLUMNS','dmsuser','SELECT');
exec rdsadmin.rdsadmin_util.grant_sys_object('V_$LOGMNR_LOGS','dmsuser','SELECT');
exec rdsadmin.rdsadmin_util.grant_sys_object('V_$LOGMNR_CONTENTS','dmsuser','SELECT');
exec rdsadmin.rdsadmin_util.grant_sys_object('DBMS_LOGMNR','dmsuser','EXECUTE');
exec rdsadmin.rdsadmin_util.grant_sys_object('REGISTRY$SQLPATCH','dmsuser','SELECT'); (as of AWS DMS versions 3.3.1 and later)
exec rdsadmin.rdsadmin_util.grant_sys_object('V_$STANDBY_LOG','dmsuser','SELECT'); (for RDS Active Dataguard Standby (ADG))
exec rdsadmin.rdsadmin_util.grant_sys_object('ENC$','dmsuser','SELECT'); (for transparent data encryption (TDE))
grant lock any table to dmsuser;

exec rdsadmin.rdsadmin_master_util.create_archivelog_dir;
exec rdsadmin.rdsadmin_master_util.create_onlinelog_dir;
GRANT READ ON DIRECTORY ONLINELOG_DIR TO dmsuser;
GRANT READ ON DIRECTORY ARCHIVELOG_DIR TO dmsuser;
exit

