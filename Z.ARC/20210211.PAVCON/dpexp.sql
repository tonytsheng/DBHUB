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
exit;
