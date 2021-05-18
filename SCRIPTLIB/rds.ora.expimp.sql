-- EXPDP

set serveroutput on;
DECLARE
  v_hdnl NUMBER;
BEGIN
  v_hdnl := DBMS_DATAPUMP.OPEN( operation => 'EXPORT', job_mode => 'SCHEMA', job_name=>null);
  dbms_output.put_line (v_hdnl);
  DBMS_DATAPUMP.ADD_FILE(
    handle    => v_hdnl,
    filename  => 'sample.dmp',
    directory => 'DATA_PUMP_DIR',
    filetype  => dbms_datapump.ku$_file_type_dump_file,
    reusefile => 1);
  DBMS_DATAPUMP.ADD_FILE(
    handle    => v_hdnl,
    filename  => 'sample_exp.log',
    directory => 'DATA_PUMP_DIR',
    filetype  => dbms_datapump.ku$_file_type_log_file,
    reusefile => 1);
  dbms_output.put_line ('Post add file');
  DBMS_DATAPUMP.METADATA_FILTER(v_hdnl,'SCHEMA_EXPR','IN (''FLY1'')');
  dbms_output.put_line ('Post metadata filter ');
  DBMS_DATAPUMP.START_JOB(v_hdnl);
END;
/

-- encrypted file add below
-- dbms_datapump.set_parameter(handle => h1, name => 'ENCRYPTION_PASSWORD', value => 'secret password') 

SELECT * FROM TABLE(rdsadmin.rds_file_util.listdir(p_directory => 'DATA_PUMP_DIR'));
exit;

-- IMPDP
select count(*) from FLY1.RESERVATION;
set serveroutput on;
DECLARE
  v_hdnl NUMBER;
BEGIN
  v_hdnl := DBMS_DATAPUMP.OPEN(
    operation => 'IMPORT',
    job_mode  => 'SCHEMA',
    job_name  => null);
  dbms_output.put_line (v_hdnl);
  DBMS_DATAPUMP.ADD_FILE(
    handle    => v_hdnl,
    filename  => 'sample.dmp',
    directory => 'DATA_PUMP_DIR',
    filetype  => dbms_datapump.ku$_file_type_dump_file,
    reusefile => 1);
  dbms_output.put_line ('after first add file');
  DBMS_DATAPUMP.ADD_FILE(
    handle    => v_hdnl,
    filename  => 'sample_imp.log',
    directory => 'DATA_PUMP_DIR',
    filetype  => dbms_datapump.ku$_file_type_log_file,
    reusefile => 1);
  dbms_output.put_line ('Post add file');
  DBMS_DATAPUMP.METADATA_FILTER(v_hdnl,'SCHEMA_EXPR','IN (''FLY1'')');
  dbms_output.put_line ('Post add metadatafilter ');
  DBMS_DATAPUMP.START_JOB(v_hdnl);
END;
/

-- SQL_FILE - get ddl from export file

set serveroutput on;
DECLARE
  v_hdnl NUMBER;
BEGIN
  v_hdnl := DBMS_DATAPUMP.OPEN(
    operation => 'SQL_FILE',
    job_mode  => 'FULL',
    job_name  => null);
  dbms_output.put_line (v_hdnl);
  DBMS_DATAPUMP.ADD_FILE(
    handle    => v_hdnl,
    filename  => 'sample.dmp',
    directory => 'DATA_PUMP_DIR',
    filetype  => dbms_datapump.ku$_file_type_dump_file,
    reusefile => 1);
  dbms_output.put_line ('after first add file');
  DBMS_DATAPUMP.ADD_FILE(
    handle    => v_hdnl,
    filename  => 'sample.sql',
    directory => 'DATA_PUMP_DIR',
    filetype  => dbms_datapump.ku$_file_type_sql_file,
    reusefile => 1);
  DBMS_DATAPUMP.ADD_FILE(
    handle    => v_hdnl,
    filename  => 'sample_imp.log',
    directory => 'DATA_PUMP_DIR',
    filetype  => dbms_datapump.ku$_file_type_log_file,
    reusefile => 1);
  dbms_output.put_line ('Post add file');
--  DBMS_DATAPUMP.METADATA_FILTER(v_hdnl,'SCHEMA_EXPR','IN (''SAMPLE'')');
  dbms_output.put_line ('Post add metadatafilter ');
  DBMS_DATAPUMP.START_JOB(v_hdnl);
END;
/
SELECT * FROM TABLE(rdsadmin.rds_file_util.read_text_file( p_directory => 'DATA_PUMP_DIR', p_filename  => 'sample.sql'));

select count(*) from FLY1.RESERVATION;
exit;

SELECT * FROM TABLE(rdsadmin.rds_file_util.listdir('DATA_PUMP_DIR')) ORDER BY MTIME;
SELECT * FROM TABLE(rdsadmin.rds_file_util.read_text_file( p_directory => 'DATA_PUMP_DIR', p_filename  => 'sample_imp.log'));

-- sample link
create database link <DB-LINK-NAME> connect to <USERNAME> identified by <PASSWORD> 
using '(DESCRIPTION=(ADDRESS=(PROTOCOL=TCP)(HOST=RDS-END-POINT)(PORT=1521))(CONNECT_DATA=(SID = RDS-DB-SID)))';

-- Move files over a db link
BEGIN
DBMS_FILE_TRANSFER.PUT_FILE(
source_directory_object       => 'DPUMP_DIR',
source_file_name              => 'EXPDP_SCHEMAS_20210321.DMP',
destination_directory_object  => 'DATA_PUMP_DIR',
destination_file_name         => 'EXPDP_SCHEMAS_20210321.DMP', 
destination_database          => 'LINKNAME' 
);
END;
/

-- remove file
exec utl_file.fremove('DATA_PUMP_DIR','SCHEMANAME.DMP');
