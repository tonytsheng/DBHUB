## calling rdsadmin.rdsadmin_util.grant_sys_object needs the DMSUSER in caps

drop user DMSUSER;
create tablespace DMSUSER;
create user DMSUSER identified by DMSUSER default tablespace DMSUSER;
create user DMSUSER identified by DMSUSER default tablespace system;
grant create session to DMSUSER;
grant create any table to DMSUSER;
grant drop any table to DMSUSER;
grant unlimited tablespace to DMSUSER;
grant execute any procedure to DMSUSER;
grant alter any table to DMSUSER;
grant update any table to DMSUSER;
grant create any index to DMSUSER;
exec rdsadmin.rdsadmin_util.grant_sys_object('V_$ARCHIVED_LOG','DMSUSER');
exec rdsadmin.rdsadmin_util.grant_sys_object('V_$LOG','DMSUSER');
exec rdsadmin.rdsadmin_util.grant_sys_object('V_$LOGFILE','DMSUSER');
exec rdsadmin.rdsadmin_util.grant_sys_object('V_$DATABASE','DMSUSER');
exec rdsadmin.rdsadmin_util.grant_sys_object('V_$THREAD','DMSUSER');
exec rdsadmin.rdsadmin_util.grant_sys_object('V_$PARAMETER','DMSUSER');
exec rdsadmin.rdsadmin_util.grant_sys_object('V_$NLS_PARAMETERS','DMSUSER');
exec rdsadmin.rdsadmin_util.grant_sys_object('V_$TIMEZONE_NAMES','DMSUSER');
exec rdsadmin.rdsadmin_util.grant_sys_object('V_$TRANSACTION','DMSUSER');
exec rdsadmin.rdsadmin_util.grant_sys_object('DBA_OBJECTS','DMSUSER'); 
exec rdsadmin.rdsadmin_util.grant_sys_object('DBA_REGISTRY','DMSUSER');
exec rdsadmin.rdsadmin_util.grant_sys_object('OBJ$','DMSUSER');
grant SELECT on ALL_INDEXES to DMSUSER;
grant SELECT on ALL_OBJECTS to DMSUSER;
grant SELECT on ALL_TABLES to DMSUSER;
grant SELECT on ALL_USERS to DMSUSER;
grant SELECT on ALL_CATALOG to DMSUSER;
grant SELECT on ALL_CONSTRAINTS to DMSUSER;
grant SELECT on ALL_CONS_COLUMNS to DMSUSER;
grant SELECT on ALL_TAB_COLS to DMSUSER;
grant SELECT on ALL_IND_COLUMNS to DMSUSER;
grant SELECT on ALL_LOG_GROUPS to DMSUSER;
GRANT SELECT on SYS.DBA_REGISTRY to DMSUSER;
GRANT SELECT on SYS.OBJ$ to DMSUSER;
GRANT SELECT on DBA_TABLESPACES to DMSUSER;
GRANT SELECT on ALL_TAB_PARTITIONS to DMSUSER;
GRANT SELECT on ALL_ENCRYPTED_COLUMNS to DMSUSER;
GRANT SELECT ANY TRANSACTION to DMSUSER;
GRANT SELECT on V_$LOGMNR_LOGS to DMSUSER;
GRANT SELECT on V_$LOGMNR_CONTENTS to DMSUSER;
GRANT SELECT on V_$LOG to DMSUSER;
GRANT SELECT on V_$ARCHIVED_LOG to DMSUSER;
GRANT SELECT on V_$LOGFILE to DMSUSER;
GRANT SELECT on V_$TRANSACTION to DMSUSER;
exec rdsadmin.rdsadmin_util.grant_sys_object('DBA_TABLESPACES','DMSUSER');
grant SELECT on ALL_TAB_PARTITIONS to DMSUSER;
exec rdsadmin.rdsadmin_util.grant_sys_object('ALL_ENCRYPTED_COLUMNS','DMSUSER');
grant SELECT on ALL_VIEWS  to DMSUSER;

exec rdsadmin.rdsadmin_util.grant_sys_object('DBMS_LOGMNR','DMSUSER');
exec rdsadmin.rdsadmin_util.grant_sys_object('V_$LOGMNR_LOGS','DMSUSER');
exec rdsadmin.rdsadmin_util.grant_sys_object('V_$LOGMNR_CONTENTS','DMSUSER');
grant logmining to DMSUSER;

-- for use with SCT
grant SELECT ANY DICTIONARY to DMSUSER;

grant select_catalog_role to DMSUSER;
grant execute_catalog_role to DMSUSER;

grant SELECT ANY TRANSACTION to DMSUSER;
grant SELECT on V$NLS_PARAMETERS to DMSUSER;
grant SELECT on V$TIMEZONE_NAMES to DMSUSER;
grant SELECT on ALL_INDEXES to DMSUSER;
grant SELECT on ALL_OBJECTS to DMSUSER;
grant SELECT on DBA_OBJECTS to DMSUSER;
grant SELECT on ALL_TABLES to DMSUSER;
grant SELECT on ALL_USERS to DMSUSER;
grant SELECT on ALL_CATALOG to DMSUSER;
grant SELECT on ALL_CONSTRAINTS to DMSUSER;
grant SELECT on ALL_CONS_COLUMNS to DMSUSER;
grant SELECT on ALL_TAB_COLS to DMSUSER;
grant SELECT on ALL_IND_COLUMNS to DMSUSER;
grant DROP ANY TABLE to DMSUSER;
grant SELECT ANY TABLE to DMSUSER;
grant INSERT ANY TABLE to DMSUSER;
grant UPDATE ANY TABLE to DMSUSER;
grant CREATE ANY VIEW to DMSUSER;
grant DROP ANY VIEW to DMSUSER;
grant CREATE ANY PROCEDURE to DMSUSER;
grant ALTER ANY PROCEDURE to DMSUSER;
grant DROP ANY PROCEDURE to DMSUSER;
grant CREATE ANY SEQUENCE to DMSUSER;
grant ALTER ANY SEQUENCE to DMSUSER;
grant DROP ANY SEQUENCE to DMSUSER;
grant SELECT on DBA_USERS to DMSUSER;
grant SELECT on DBA_TAB_PRIVS to DMSUSER;
grant SELECT on DBA_OBJECTS to DMSUSER;
grant SELECT on DBA_SYNONYMS to DMSUSER;
grant SELECT on DBA_SEQUENCES to DMSUSER;
grant SELECT on DBA_TYPES to DMSUSER;
grant SELECT on DBA_INDEXES to DMSUSER;
grant SELECT on DBA_TABLES to DMSUSER;
grant SELECT on DBA_TRIGGERS to DMSUSER;

grant select,insert,update,alter,delete on fly1.airline to DMSUSER;
grant select,insert,update,alter,delete on fly1.airport to DMSUSER;
grant select,insert,update,alter,delete on fly1.employee to DMSUSER;
grant select,insert,update,alter,delete on fly1.reservation to DMSUSER;

exec rdsadmin.rdsadmin_util.grant_sys_object('V_$ARCHIVED_LOG','DMSUSER','SELECT');
exec rdsadmin.rdsadmin_util.grant_sys_object('V_$LOG','DMSUSER','SELECT');
exec rdsadmin.rdsadmin_util.grant_sys_object('V_$LOGFILE','DMSUSER','SELECT');
exec rdsadmin.rdsadmin_util.grant_sys_object('V_$DATABASE','DMSUSER','SELECT');
exec rdsadmin.rdsadmin_util.grant_sys_object('V_$THREAD','DMSUSER','SELECT');
exec rdsadmin.rdsadmin_util.grant_sys_object('V_$PARAMETER','DMSUSER','SELECT');
exec rdsadmin.rdsadmin_util.grant_sys_object('V_$NLS_PARAMETERS','DMSUSER','SELECT');
exec rdsadmin.rdsadmin_util.grant_sys_object('V_$TIMEZONE_NAMES','DMSUSER','SELECT');
exec rdsadmin.rdsadmin_util.grant_sys_object('V_$TRANSACTION','DMSUSER','SELECT');
exec rdsadmin.rdsadmin_util.grant_sys_object('DBA_REGISTRY','DMSUSER','SELECT');
exec rdsadmin.rdsadmin_util.grant_sys_object('OBJ$','DMSUSER','SELECT');
exec rdsadmin.rdsadmin_util.grant_sys_object('ALL_ENCRYPTED_COLUMNS','DMSUSER','SELECT');
exec rdsadmin.rdsadmin_util.grant_sys_object('V_$LOGMNR_LOGS','DMSUSER','SELECT');
exec rdsadmin.rdsadmin_util.grant_sys_object('V_$LOGMNR_CONTENTS','DMSUSER','SELECT');
exec rdsadmin.rdsadmin_util.grant_sys_object('DBMS_LOGMNR','DMSUSER','EXECUTE');
exec rdsadmin.rdsadmin_util.grant_sys_object('REGISTRY$SQLPATCH','DMSUSER','SELECT'); (as of AWS DMS versions 3.3.1 and later)
exec rdsadmin.rdsadmin_util.grant_sys_object('V_$STANDBY_LOG','DMSUSER','SELECT'); (for RDS Active Dataguard Standby (ADG))
exec rdsadmin.rdsadmin_util.grant_sys_object('ENC$','DMSUSER','SELECT'); (for transparent data encryption (TDE))
grant lock any table to DMSUSER;

exec rdsadmin.rdsadmin_master_util.create_archivelog_dir;
exec rdsadmin.rdsadmin_master_util.create_onlinelog_dir;
GRANT READ ON DIRECTORY ONLINELOG_DIR TO DMSUSER;
GRANT READ ON DIRECTORY ARCHIVELOG_DIR TO DMSUSER;
grant LOGMINING TO DMSUSER;

exec rdsadmin.rdsadmin_util.grant_sys_object('ALL_VIEWS', 'DMSUSER', 'SELECT');
exec rdsadmin.rdsadmin_util.grant_sys_object('ALL_TAB_PARTITIONS', 'DMSUSER', 'SELECT');
exec rdsadmin.rdsadmin_util.grant_sys_object('ALL_INDEXES', 'DMSUSER', 'SELECT');
exec rdsadmin.rdsadmin_util.grant_sys_object('ALL_OBJECTS', 'DMSUSER', 'SELECT');
exec rdsadmin.rdsadmin_util.grant_sys_object('ALL_TABLES', 'DMSUSER', 'SELECT');
exec rdsadmin.rdsadmin_util.grant_sys_object('ALL_USERS', 'DMSUSER', 'SELECT');
exec rdsadmin.rdsadmin_util.grant_sys_object('ALL_CATALOG', 'DMSUSER', 'SELECT');
exec rdsadmin.rdsadmin_util.grant_sys_object('ALL_CONSTRAINTS', 'DMSUSER', 'SELECT');
exec rdsadmin.rdsadmin_util.grant_sys_object('ALL_CONS_COLUMNS', 'DMSUSER', 'SELECT');
exec rdsadmin.rdsadmin_util.grant_sys_object('ALL_TAB_COLS', 'DMSUSER', 'SELECT');
exec rdsadmin.rdsadmin_util.grant_sys_object('ALL_IND_COLUMNS', 'DMSUSER', 'SELECT');
exec rdsadmin.rdsadmin_util.grant_sys_object('ALL_LOG_GROUPS', 'DMSUSER', 'SELECT');
exec rdsadmin.rdsadmin_util.grant_sys_object('V_$ARCHIVED_LOG', 'DMSUSER', 'SELECT');
exec rdsadmin.rdsadmin_util.grant_sys_object('V_$LOG', 'DMSUSER', 'SELECT');
exec rdsadmin.rdsadmin_util.grant_sys_object('V_$LOGFILE', 'DMSUSER', 'SELECT');
exec rdsadmin.rdsadmin_util.grant_sys_object('V_$DATABASE', 'DMSUSER', 'SELECT');
exec rdsadmin.rdsadmin_util.grant_sys_object('V_$THREAD', 'DMSUSER', 'SELECT');
exec rdsadmin.rdsadmin_util.grant_sys_object('V_$PARAMETER', 'DMSUSER', 'SELECT');
exec rdsadmin.rdsadmin_util.grant_sys_object('V_$NLS_PARAMETERS', 'DMSUSER', 'SELECT');
exec rdsadmin.rdsadmin_util.grant_sys_object('V_$TIMEZONE_NAMES', 'DMSUSER', 'SELECT');
exec rdsadmin.rdsadmin_util.grant_sys_object('V_$TRANSACTION', 'DMSUSER', 'SELECT');
exec rdsadmin.rdsadmin_util.grant_sys_object('DBA_REGISTRY', 'DMSUSER', 'SELECT');
exec rdsadmin.rdsadmin_util.grant_sys_object('OBJ$', 'DMSUSER', 'SELECT');
exec rdsadmin.rdsadmin_util.grant_sys_object('ALL_ENCRYPTED_COLUMNS', 'DMSUSER', 'SELECT');
exec rdsadmin.rdsadmin_util.grant_sys_object('V_$LOGMNR_LOGS', 'DMSUSER', 'SELECT');
exec rdsadmin.rdsadmin_util.grant_sys_object('V_$LOGMNR_CONTENTS','DMSUSER','SELECT');
exec rdsadmin.rdsadmin_util.grant_sys_object('DBMS_LOGMNR', 'DMSUSER', 'EXECUTE');

-- (as of AWS DMS versions 3.3.1 and later and as of Oracle versions 12.1 and later)
exec rdsadmin.rdsadmin_util.grant_sys_object('REGISTRY$SQLPATCH', 'DMSUSER', 'SELECT');

-- (for Amazon RDS Active Dataguard Standby (ADG))
exec rdsadmin.rdsadmin_util.grant_sys_object('V_$STANDBY_LOG', 'DMSUSER', 'SELECT'); 

-- (for transparent data encryption (TDE))
exec rdsadmin.rdsadmin_util.grant_sys_object('ENC$', 'DMSUSER', 'SELECT'); 
exit

