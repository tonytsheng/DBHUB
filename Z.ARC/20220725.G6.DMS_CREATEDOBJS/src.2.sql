GRANT CREATE SESSION to CUSTOMER_ORDERS;
GRANT SELECT ANY TRANSACTION to CUSTOMER_ORDERS;
GRANT SELECT on DBA_TABLESPACES to CUSTOMER_ORDERS;
GRANT SELECT ON any-replicated-table to CUSTOMER_ORDERS;
GRANT EXECUTE on rdsadmin.rdsadmin_util to CUSTOMER_ORDERS;
 -- For Oracle 12c only:
GRANT LOGMINING to CUSTOMER_ORDERS
exec rdsadmin.rdsadmin_util.grant_sys_object('ALL_VIEWS', 'CUSTOMER_ORDERS', 'SELECT');
exec rdsadmin.rdsadmin_util.grant_sys_object('ALL_TAB_PARTITIONS', 'CUSTOMER_ORDERS', 'SELECT');
exec rdsadmin.rdsadmin_util.grant_sys_object('ALL_INDEXES', 'CUSTOMER_ORDERS', 'SELECT');
exec rdsadmin.rdsadmin_util.grant_sys_object('ALL_OBJECTS', 'CUSTOMER_ORDERS', 'SELECT');
exec rdsadmin.rdsadmin_util.grant_sys_object('ALL_TABLES', 'CUSTOMER_ORDERS', 'SELECT');
exec rdsadmin.rdsadmin_util.grant_sys_object('ALL_USERS', 'CUSTOMER_ORDERS', 'SELECT');
exec rdsadmin.rdsadmin_util.grant_sys_object('ALL_CATALOG', 'CUSTOMER_ORDERS', 'SELECT');
exec rdsadmin.rdsadmin_util.grant_sys_object('ALL_CONSTRAINTS', 'CUSTOMER_ORDERS', 'SELECT');
exec rdsadmin.rdsadmin_util.grant_sys_object('ALL_CONS_COLUMNS', 'CUSTOMER_ORDERS', 'SELECT');
exec rdsadmin.rdsadmin_util.grant_sys_object('ALL_TAB_COLS', 'CUSTOMER_ORDERS', 'SELECT');
exec rdsadmin.rdsadmin_util.grant_sys_object('ALL_IND_COLUMNS', 'CUSTOMER_ORDERS', 'SELECT');
exec rdsadmin.rdsadmin_util.grant_sys_object('ALL_LOG_GROUPS', 'CUSTOMER_ORDERS', 'SELECT');
exec rdsadmin.rdsadmin_util.grant_sys_object('V_$ARCHIVED_LOG', 'CUSTOMER_ORDERS', 'SELECT');
exec rdsadmin.rdsadmin_util.grant_sys_object('V_$LOG', 'CUSTOMER_ORDERS', 'SELECT');
exec rdsadmin.rdsadmin_util.grant_sys_object('V_$LOGFILE', 'CUSTOMER_ORDERS', 'SELECT');
exec rdsadmin.rdsadmin_util.grant_sys_object('V_$DATABASE', 'CUSTOMER_ORDERS', 'SELECT');
exec rdsadmin.rdsadmin_util.grant_sys_object('V_$THREAD', 'CUSTOMER_ORDERS', 'SELECT');
exec rdsadmin.rdsadmin_util.grant_sys_object('V_$PARAMETER', 'CUSTOMER_ORDERS', 'SELECT');
exec rdsadmin.rdsadmin_util.grant_sys_object('V_$NLS_PARAMETERS', 'CUSTOMER_ORDERS', 'SELECT');
exec rdsadmin.rdsadmin_util.grant_sys_object('V_$TIMEZONE_NAMES', 'CUSTOMER_ORDERS', 'SELECT');
exec rdsadmin.rdsadmin_util.grant_sys_object('V_$TRANSACTION', 'CUSTOMER_ORDERS', 'SELECT');
exec rdsadmin.rdsadmin_util.grant_sys_object('V_$CONTAINERS', 'CUSTOMER_ORDERS', 'SELECT');
exec rdsadmin.rdsadmin_util.grant_sys_object('DBA_REGISTRY', 'CUSTOMER_ORDERS', 'SELECT');
exec rdsadmin.rdsadmin_util.grant_sys_object('OBJ$', 'CUSTOMER_ORDERS', 'SELECT');
exec rdsadmin.rdsadmin_util.grant_sys_object('ALL_ENCRYPTED_COLUMNS', 'CUSTOMER_ORDERS', 'SELECT');
exec rdsadmin.rdsadmin_util.grant_sys_object('V_$LOGMNR_LOGS', 'CUSTOMER_ORDERS', 'SELECT');
exec rdsadmin.rdsadmin_util.grant_sys_object('V_$LOGMNR_CONTENTS','CUSTOMER_ORDERS','SELECT');
exec rdsadmin.rdsadmin_util.grant_sys_object('DBMS_LOGMNR', 'CUSTOMER_ORDERS', 'EXECUTE');

-- (as of Oracle versions 12.1 and later)
exec rdsadmin.rdsadmin_util.grant_sys_object('REGISTRY$SQLPATCH', 'CUSTOMER_ORDERS', 'SELECT');

-- (for Amazon RDS Active Dataguard Standby (ADG))
exec rdsadmin.rdsadmin_util.grant_sys_object('V_$STANDBY_LOG', 'CUSTOMER_ORDERS', 'SELECT');

-- (for transparent data encryption (TDE))

exec rdsadmin.rdsadmin_util.grant_sys_object('ENC$', 'CUSTOMER_ORDERS', 'SELECT');

-- (for validation with LOB columns)
exec rdsadmin.rdsadmin_util.grant_sys_object('DBMS_CRYPTO', 'CUSTOMER_ORDERS', 'EXECUTE');

-- (for binary reader)
exec rdsadmin.rdsadmin_util.grant_sys_object('DBA_DIRECTORIES','CUSTOMER_ORDERS','SELECT');


