set serveroutput on;

DECLARE

      v_dt                          varchar2(15);
      v_owner                             varchar2(200);
      v_degree                      number:=1;
v_hdnl                        number;
      v_scn                         number;
      v_job_run                     varchar2(10);
      v_job_group                   varchar2(10);
      v_db_link                     varchar2(30):='srcdb';
      v_err_msg                     varchar2(200);
      
BEGIN  
      
---   select CURRENT_SCN into v_scn from v$database@srcnaxap;
    v_scn:= 5016161105;
      select to_char(sysdate,'yyyymmdd_hh24miss') into v_dt from dual;

BEGIN
dbms_output.put_line ('starting');

            v_owner := 'ODB';
            v_degree := 1;
dbms_output.put_line ('pre handle');
            
--            v_hdnl := DBMS_DATAPUMP.OPEN(operation => 'IMPORT', job_mode  => 'SCHEMA', remote_link => v_db_link, job_name => 'impdp_'||lower(v_owner)||'_STYLESHEET_CONTENT_'||v_dt); 
            v_hdnl := DBMS_DATAPUMP.OPEN(operation => 'IMPORT', job_mode  => 'TABLE', job_name => 'impdp_'||lower(v_owner)||'_STYLESHEET_CONTENT_'||v_dt); 
dbms_output.put_line ('post handle');
            
--            DBMS_DATAPUMP.ADD_FILE( handle => v_hdnl, filename  => 'impdp_'||lower(v_owner)||'_STYLESHEET_CONTENT_'||v_dt||'.log',  directory => 'DATA_PUMP_DIR', filetype  => dbms_datapump.ku$_file_type_log_file);  
--            DBMS_DATAPUMP.METADATA_FILTER( handle=>v_hdnl, name=> 'SCHEMA_EXPR', value=> 'IN ('''||v_owner||''')');
 --           DBMS_DATAPUMP.METADATA_FILTER(handle =>v_hdnl, name =>'NAME_EXPR', value =>' IN (''STYLESHEET_CONTENT'')',object_type => 'TABLE');
  --          DBMS_DATAPUMP.METADATA_FILTER(v_hdnl, 'EXCLUDE_PATH_EXPR','IN (''STATISTICS'')');
--            DBMS_DATAPUMP.METADATA_TRANSFORM(handle => v_hdnl, name=> 'DISABLE_ARCHIVE_LOGGING', value=>1);
--            DBMS_DATAPUMP.SET_PARAMETER (handle => v_hdnl, name => 'FLASHBACK_SCN', value => v_scn);
--            DBMS_DATAPUMP.SET_PARAMETER (handle => v_hdnl, name => 'METRICS', value => 1);
--            DBMS_DATAPUMP.SET_PARAMETER (handle => v_hdnl, name => 'LOGTIME', value => 'ALL');
--            DBMS_DATAPUMP.SET_PARAMETER (handle => v_hdnl, name => 'TABLE_EXISTS_ACTION', value => 'REPLACE');
--            DBMS_DATAPUMP.SET_PARALLEL (handle => v_hdnl, degree => v_degree);
--            DBMS_DATAPUMP.START_JOB(v_hdnl);
--            DBMS_DATAPUMP.DETACH(v_hdnl);
                        
                        
      EXCEPTION
            when others THEN
                  v_err_msg:=SUBSTR(SQLERRM, 1, 200);
                  dbms_output.put_line('ERROR - '||v_err_msg);
      END;

end;
/
exit

