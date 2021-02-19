set serveroutput on;
DECLARE
  v_hdnl NUMBER;
  v_out varchar2(25);
  pct_done  NUMBER;        -- percentage complete
  job_state VARCHAR2(30);  -- track job state
  ind       NUMBER;        -- loop index
  dph       NUMBER;        -- job handle
  pct_done  NUMBER;        -- percentage complete
  job_state VARCHAR2(30);  -- track job state
  le        ku$_LogEntry;  -- WIP and error messages
  js        ku$_JobStatus; -- job status from get_status
  jd        ku$_JobDesc;   -- job description from get_status
  sts       ku$_Status;    -- status object returned by get_status
BEGIN
  v_hdnl := DBMS_DATAPUMP.OPEN( operation => 'EXPORT', job_mode => 'SCHEMA', job_name=>null);
  dbms_output.put_line (v_hdnl);
  DBMS_DATAPUMP.ADD_FILE(
    handle    => v_hdnl,
    filename  => 'customer_orders.dmp',
    directory => 'DATA_PUMP_DIR',
    filetype  => dbms_datapump.ku$_file_type_dump_file,
    reusefile => 1);
  DBMS_DATAPUMP.ADD_FILE(
    handle    => v_hdnl,
    filename  => 'custordersexp.log',
    directory => 'DATA_PUMP_DIR',
    filetype  => dbms_datapump.ku$_file_type_log_file,
    reusefile => 1);
  dbms_output.put_line ('Post add file');
  DBMS_DATAPUMP.METADATA_FILTER(v_hdnl,'SCHEMA_EXPR','IN (''CUSTOMER_ORDERS'')');
  dbms_output.put_line ('Post metadata filter ');
  DBMS_DATAPUMP.START_JOB(v_hdnl);
END;
/
-- SELECT * FROM TABLE(rdsadmin.rds_file_util.listdir(p_directory => 'DATA_PUMP_DIR'));
-- SELECT * FROM TABLE(rdsadmin.rds_file_util.read_text_file( p_directory => 'DATA_PUMP_DIR', 
--     p_filename  => 'custordersexp.log'));
exit;
