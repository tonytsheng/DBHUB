GRANT CREATE SESSION TO customer_orders;
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
GRANT SELECT ON V_$CONTAINERS TO customer_orders;                   
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
GRANT SELECT ON DBA_OBJECTS TO customer_orders; -– Required if the Oracle version is earlier than 11.2.0.3.
GRANT SELECT ON SYS.ENC$ TO customer_orders; -– Required if transparent data encryption (TDE) is enabled. For more information on using Oracle TDE with AWS DMS, see Supported encryption methods for using Oracle as a source for AWS DMS.
GRANT SELECT ON GV_$TRANSACTION TO customer_orders; -– Required if the source database is Oracle RAC in AWS DMS versions 3.4.6 and higher.
GRANT SELECT ON V_$DATAGUARD_STATS TO customer_orders; -- Required if the source database is Oracle Data Guard and Oracle Standby is used in the latest release of DMS version 3.4.6, version 3.4.7, and higher.
GRANT EXECUTE ON SYS.DBMS_CRYPTO TO customer_orders;
GRANT SELECT ON SYS.DBA_DIRECTORIES TO customer_orders;
GRANT SELECT on ALL_VIEWS to dms_user;
GRANT SELECT on dba_segments to customer_orders;
GRANT SELECT on gv_$parameter  to dms_user;
GRANT SELECT on v_$instance to dms_user;
GRANT SELECT on v_$version to dms_user;
GRANT SELECT on gv_$ASM_DISKGROUP to dms_user;
GRANT SELECT on gv_$database to dms_user;
GRANT SELECT on dba_db_links to dms_user;
GRANT SELECT on gv_$log_History to dms_user;
GRANT SELECT on gv_$log to dms_user;
GRANT SELECT ON DBA_TYPES TO customer_orders;
SELECT supplemental_log_data_min FROM v$database;
ALTER TABLE orders ADD SUPPLEMENTAL LOG DATA (PRIMARY KEY) COLUMNS;
GRANT EXECUTE on DBMS_LOGMNR to customer_orders;
GRANT SELECT on V_$LOGMNR_LOGS to customer_orders;
GRANT SELECT on V_$LOGMNR_CONTENTS to customer_orders;
GRANT LOGMINING to customer_orders; -– Required only if the Oracle version is 12c or higher.
GRANT SELECT on v_$transportable_platform to customer_orders;  
GRANT CREATE ANY DIRECTORY to customer_orders;                  
GRANT EXECUTE on DBMS_FILE_TRANSFER to customer_orders;       
GRANT EXECUTE on DBMS_FILE_GROUP to customer_orders;


SELECT log_mode FROM v$database;
ALTER DATABASE ADD SUPPLEMENTAL LOG DATA;
ALTER DATABASE ADD SUPPLEMENTAL LOG DATA (PRIMARY KEY) COLUMNS;
