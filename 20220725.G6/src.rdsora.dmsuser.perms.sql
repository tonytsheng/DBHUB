GRANT SELECT ANY TRANSACTION TO customer_orders;
GRANT SELECT ON V_$ARCHIVED_LOG TO customer_orders;
GRANT SELECT ON V_$LOG TO customer_orders;
GRANT SELECT ON V_$LOGFILE TO customer_orders;
GRANT SELECT ON V_$LOGMNR_LOGS TO customer_orders;
GRANT SELECT ON V_$LOGMNR_CONTENTS TO customer_orders;
GRANT SELECT ON V_$DATABASE TO customer_orders;
GRANT SELECT ON V_$THREAD TO customer_orders;
GRANT SELECT ON V_$PARAMETER TO customer_orders;
GRANT SELECT ON V_$NLS_PARAMETERS TO customer_orders;
GRANT SELECT ON V_$TIMEZONE_NAMES TO customer_orders;
GRANT SELECT ON V_$TRANSACTION TO customer_orders;
GRANT SELECT ON V_$LOGMNR_LOGS to customer_orders;
GRANT SELECT ON ALL_INDEXES TO customer_orders;
GRANT SELECT ON ALL_OBJECTS TO customer_orders;
GRANT SELECT ON ALL_TABLES TO customer_orders;
GRANT SELECT ON ALL_USERS TO customer_orders;
GRANT SELECT ON ALL_CATALOG TO customer_orders;
GRANT SELECT ON ALL_CONSTRAINTS TO customer_orders;
GRANT SELECT ON ALL_CONS_COLUMNS TO customer_orders;
GRANT SELECT ON ALL_TAB_COLS TO customer_orders;
GRANT SELECT ON ALL_IND_COLUMNS TO customer_orders;
GRANT SELECT ON ALL_ENCRYPTED_COLUMNS TO customer_orders;
GRANT SELECT ON ALL_LOG_GROUPS TO customer_orders;
GRANT SELECT ON ALL_TAB_PARTITIONS TO customer_orders;
GRANT SELECT ON SYS.DBA_REGISTRY TO customer_orders;
GRANT SELECT ON SYS.OBJ$ TO customer_orders;
GRANT SELECT ON DBA_TABLESPACES TO customer_orders;
grant execute on SYS.DBMS_LOGMNR to customer_orders; -- oracle custom - login to machine, sqlplus / as sysdba, run this
grant execute on dbms_logmnr to customer_orders;
grant logmining to customer_orders;
grant execute_catalog_role to customer_orders; -- oracle custom - login to machine, sqlplus / as sysdba, run this
GRANT SELECT ON DBA_OBJECTS TO customer_orders; -- Required if the Oracle version is earlier than 11.2.0.3.
GRANT SELECT ON SYS.ENC$ TO customer_orders; -- Required if transparent data encryption (TDE) is enabled. For more information on using Oracle TDE with AWS DMS, see .
