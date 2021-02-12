select count(*) from FLY1.RESERVATION;
DECLARE
  v_hdnl NUMBER;
BEGIN
  v_hdnl := DBMS_DATAPUMP.OPEN( 
    operation => 'IMPORT', 
    job_mode  => 'SCHEMA', 
    job_name  => null);
  DBMS_DATAPUMP.ADD_FILE( 
    handle    => v_hdnl, 
    filename  => 'sample.dmp', 
    directory => 'DATA_PUMP_DIR', 
    filetype  => dbms_datapump.ku$_file_type_dump_file);
  DBMS_DATAPUMP.ADD_FILE( 
    handle    => v_hdnl, 
    filename  => 'sample_imp.log', 
    directory => 'DATA_PUMP_DIR', 
    filetype  => dbms_datapump.ku$_file_type_log_file,
    reusefile => 1);
  DBMS_DATAPUMP.METADATA_FILTER(v_hdnl,'SCHEMA_EXPR','IN (''FLY1'')');
  DBMS_DATAPUMP.START_JOB(v_hdnl);
END;
/            
select count(*) from FLY1.RESERVATION;
exit;

