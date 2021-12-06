GRANT SELECT ANY TRANSACTION TO dmsuser;
GRANT SELECT ON V_$ARCHIVED_LOG TO dmsuser;
GRANT SELECT ON V_$LOG TO dmsuser;
GRANT SELECT ON V_$LOGFILE TO dmsuser;
GRANT SELECT ON V_$LOGMNR_LOGS TO dmsuser;
GRANT SELECT ON V_$LOGMNR_CONTENTS TO dmsuser;
GRANT SELECT ON V_$DATABASE TO dmsuser;
GRANT SELECT ON V_$THREAD TO dmsuser;
GRANT SELECT ON V_$PARAMETER TO dmsuser;
GRANT SELECT ON V_$NLS_PARAMETERS TO dmsuser;
GRANT SELECT ON V_$TIMEZONE_NAMES TO dmsuser;
GRANT SELECT ON V_$TRANSACTION TO dmsuser;
GRANT SELECT ON V_$LOGMNR_LOGS to dmsuser;
GRANT SELECT ON ALL_INDEXES TO dmsuser;
GRANT SELECT ON ALL_OBJECTS TO dmsuser;
GRANT SELECT ON ALL_TABLES TO dmsuser;
GRANT SELECT ON ALL_USERS TO dmsuser;
GRANT SELECT ON ALL_CATALOG TO dmsuser;
GRANT SELECT ON ALL_CONSTRAINTS TO dmsuser;
GRANT SELECT ON ALL_CONS_COLUMNS TO dmsuser;
GRANT SELECT ON ALL_TAB_COLS TO dmsuser;
GRANT SELECT ON ALL_IND_COLUMNS TO dmsuser;
GRANT SELECT ON ALL_ENCRYPTED_COLUMNS TO dmsuser;
GRANT SELECT ON ALL_LOG_GROUPS TO dmsuser;
GRANT SELECT ON ALL_TAB_PARTITIONS TO dmsuser;
GRANT SELECT ON SYS.DBA_REGISTRY TO dmsuser;
GRANT SELECT ON SYS.OBJ$ TO dmsuser;
GRANT SELECT ON DBA_TABLESPACES TO dmsuser;
grant execute on SYS.DBMS_LOGMNR to dmsuser; -- oracle custom - login to machine, sqlplus / as sysdba, run this
grant execute on dbms_logmnr to dmsuser;
grant logmining to dmsuser;
grant execute_catalog_role to dmsuser; -- oracle custom - login to machine, sqlplus / as sysdba, run this
GRANT SELECT ON DBA_OBJECTS TO dmsuser; -- Required if the Oracle version is earlier than 11.2.0.3.
GRANT SELECT ON SYS.ENC$ TO dmsuser; -- Required if transparent data encryption (TDE) is enabled. For more information on using Oracle TDE with AWS DMS, see .
