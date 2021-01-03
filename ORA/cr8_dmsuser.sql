drop user dmsuser;
create tablespace dmsuser;
create user dmsuser identified by dmsuser default tablespace dmsuser;
grant create session to dmsuser;
GRANT SELECT on V_$DATABASE to dmsuser;
GRANT SELECT on V$DATABASE to dmsuser;
GRANT SELECT on V_$THREAD to dmsuser;
GRANT SELECT on V$THREAD to dmsuser;
GRANT SELECT on V_$PARAMETER to dmsuser;
GRANT SELECT on V$PARAMETER to dmsuser;
GRANT SELECT on V_$NLS_PARAMETERS to dmsuser;
GRANT SELECT on V$NLS_PARAMETERS to dmsuser;
GRANT SELECT on V_$TIMEZONE_NAMES to dmsuser;
GRANT SELECT on V$TIMEZONE_NAMES to dmsuser;
GRANT SELECT on ALL_INDEXES to dmsuser;
GRANT SELECT on ALL_OBJECTS to dmsuser;
GRANT SELECT on ALL_TABLES to dmsuser;
GRANT SELECT on ALL_USERS to dmsuser;
GRANT SELECT on ALL_CATALOG to dmsuser;
GRANT SELECT on ALL_CONSTRAINTS to dmsuser;
GRANT SELECT on ALL_CONS_COLUMNS to dmsuser;
GRANT SELECT on ALL_TAB_COLS to dmsuser;
GRANT SELECT on ALL_IND_COLUMNS to dmsuser;
GRANT SELECT on ALL_LOG_GROUPS to dmsuser;
GRANT SELECT on SYS.DBA_REGISTRY to dmsuser;
GRANT SELECT on SYS.OBJ$ to dmsuser;
GRANT SELECT on DBA_TABLESPACES to dmsuser;
GRANT SELECT on ALL_TAB_PARTITIONS to dmsuser;
GRANT SELECT on ALL_ENCRYPTED_COLUMNS to dmsuser;
GRANT SELECT ANY TRANSACTION to dmsuser;
GRANT SELECT on V_$LOGMNR_LOGS to dmsuser;
GRANT SELECT on V$LOGMNR_LOGS to dmsuser;
GRANT SELECT on V_$LOGMNR_CONTENTS to dmsuser;
GRANT SELECT on V$LOGMNR_CONTENTS to dmsuser;
GRANT SELECT on V_$LOG to dmsuser;
GRANT SELECT on V$LOG to dmsuser;
GRANT SELECT on V_$ARCHIVED_LOG to dmsuser;
GRANT SELECT on V$ARCHIVED_LOG to dmsuser;
GRANT SELECT on V_$LOGFILE to dmsuser;
GRANT SELECT on V$LOGFILE to dmsuser;
GRANT SELECT on V_$TRANSACTION to dmsuser;
GRANT SELECT on V$TRANSACTION to dmsuser;
GRANT CREATE SESSION to dmsuser;
GRANT SELECT ANY TRANSACTION to dmsuser;
GRANT SELECT on DBA_TABLESPACES to dmsuser;
GRANT LOGMINING to dmsuser; (for Oracle 12c only)
-- GRANT SELECT ON any-replicated-table to dmsuser;

exec rdsadmin.rdsadmin_util.grant_sys_object('ALL_VIEWS', 'dmsuser', 'SELECT');
exec rdsadmin.rdsadmin_util.grant_sys_object('ALL_TAB_PARTITIONS', 'dmsuser', 'SELECT');
exec rdsadmin.rdsadmin_util.grant_sys_object('ALL_INDEXES', 'dmsuser', 'SELECT');
exec rdsadmin.rdsadmin_util.grant_sys_object('ALL_OBJECTS', 'dmsuser', 'SELECT');
exec rdsadmin.rdsadmin_util.grant_sys_object('ALL_TABLES', 'dmsuser', 'SELECT');
exec rdsadmin.rdsadmin_util.grant_sys_object('ALL_USERS', 'dmsuser', 'SELECT');
exec rdsadmin.rdsadmin_util.grant_sys_object('ALL_CATALOG', 'dmsuser', 'SELECT');
exec rdsadmin.rdsadmin_util.grant_sys_object('ALL_CONSTRAINTS', 'dmsuser', 'SELECT');
exec rdsadmin.rdsadmin_util.grant_sys_object('ALL_CONS_COLUMNS', 'dmsuser', 'SELECT');
exec rdsadmin.rdsadmin_util.grant_sys_object('ALL_TAB_COLS', 'dmsuser', 'SELECT');
exec rdsadmin.rdsadmin_util.grant_sys_object('ALL_IND_COLUMNS', 'dmsuser', 'SELECT');
exec rdsadmin.rdsadmin_util.grant_sys_object('ALL_LOG_GROUPS', 'dmsuser', 'SELECT');
exec rdsadmin.rdsadmin_util.grant_sys_object('V_$ARCHIVED_LOG', 'dmsuser', 'SELECT');
exec rdsadmin.rdsadmin_util.grant_sys_object('V$ARCHIVED_LOG', 'dmsuser', 'SELECT');
exec rdsadmin.rdsadmin_util.grant_sys_object('V_$LOG', 'dmsuser', 'SELECT');
exec rdsadmin.rdsadmin_util.grant_sys_object('V$LOG', 'dmsuser', 'SELECT');
exec rdsadmin.rdsadmin_util.grant_sys_object('V_$LOGFILE', 'dmsuser', 'SELECT');
exec rdsadmin.rdsadmin_util.grant_sys_object('V$LOGFILE', 'dmsuser', 'SELECT');
exec rdsadmin.rdsadmin_util.grant_sys_object('V_$DATABASE', 'dmsuser', 'SELECT');
exec rdsadmin.rdsadmin_util.grant_sys_object('V_$THREAD', 'dmsuser', 'SELECT');
exec rdsadmin.rdsadmin_util.grant_sys_object('V_$PARAMETER', 'dmsuser', 'SELECT');
exec rdsadmin.rdsadmin_util.grant_sys_object('V_$NLS_PARAMETERS', 'dmsuser', 'SELECT');
exec rdsadmin.rdsadmin_util.grant_sys_object('V_$TIMEZONE_NAMES', 'dmsuser', 'SELECT');
exec rdsadmin.rdsadmin_util.grant_sys_object('V_$TRANSACTION', 'dmsuser', 'SELECT');
exec rdsadmin.rdsadmin_util.grant_sys_object('DBA_REGISTRY', 'dmsuser', 'SELECT');
exec rdsadmin.rdsadmin_util.grant_sys_object('OBJ$', 'dmsuser', 'SELECT');
exec rdsadmin.rdsadmin_util.grant_sys_object('ALL_ENCRYPTED_COLUMNS', 'dmsuser', 'SELECT');
exec rdsadmin.rdsadmin_util.grant_sys_object('V_$LOGMNR_LOGS', 'dmsuser', 'SELECT');
exec rdsadmin.rdsadmin_util.grant_sys_object('V_$LOGMNR_CONTENTS','dmsuser','SELECT');
exec rdsadmin.rdsadmin_util.grant_sys_object('DBMS_LOGMNR', 'dmsuser', 'EXECUTE');

-- (as of AWS DMS versions 3.3.1 and later and as of Oracle versions 12.1 and later)
exec rdsadmin.rdsadmin_util.grant_sys_object('REGISTRY$SQLPATCH', 'dmsuser', 'SELECT');

-- (for Amazon RDS Active Dataguard Standby (ADG))
exec rdsadmin.rdsadmin_util.grant_sys_object('V_$STANDBY_LOG', 'dmsuser', 'SELECT'); 

-- (for transparent data encryption (TDE))
exec rdsadmin.rdsadmin_util.grant_sys_object('ENC$', 'dmsuser', 'SELECT'); 
exit
