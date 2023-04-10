REM  This script is based on the AWR Miner script originally created by Tyler Muth
REM  It combines some additional logic/code from Craig Silveira and percentile logic from Yves Colin and Bertrand Drouvot
REM  In general, the modifications from the original AWR Miner are to remove unneeded data collection items (such as no need to collect TOP SQL).
REM  Other modifications are to collect some statistics around the # of lines of plsql, # of tables, etc that might be useful for understanding complexity.
REM  Another modification was to be able to collect proper metrics when running in a PDB
REM 


REM
REM
REM This script assumes that you have a valid license for Diagnostics Pack.  Do not run this script if you do not.
REM  PLEASE READ THE ABOVE LINE  ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
REM If you do not have a Diagnostic Pack license, ask your AWS contact for a version of this script that is designed to work with STATSPACK
REM
REM


REM
REM  This script needs just read-only access to data dictionary and performance tables (gv$/v$/dba_hist_*).  One way to do this is via
REM
REM  create user readonly_dba identified by YourPassword;
REM  grant create session, select_catalog_role to readonly_dba;
REM
REM



REM You can always download the latest version of this script from https://dbcsi.d29q8g3b9hzyur.amplifyapp.com/aws_awr_miner.sql

define AWR_MINER_VER = 4.0.11.aws.40

REM 4.0.11.aws.12 - added nls_numeric_characters='. ' to fix comma vs decimal point confusion
REM 4.0.11.aws.13 = fix issue where hostnames were reported incorrectly
REM 4.0.11.aws.13 = fix feature usage query
REM 4.0.11.aws.13 = add a HCC metric to sysstat query
REM 4.0.11.aws.13 = add check to report statistics_level
REM 4.0.11.aws.14 = add check to report control_management_pack_access
REM 4.0.11.aws.15 = add INSTANCES_CURRENT and HOSTS_CURRENT
REM 4.0.11.aws.16 = add CONTAINER.  Add better check for running against PDB.
REM 4.0.11.aws.17 = fix some bugs with PDB checks introduced when running against 10.2
REM 4.0.11.aws.18 = fix some more bugs with PDB checks introduced when running against 11,10
REM 4.0.11.aws.19 = fix some more bugs with PDB checks - thanks to Sudip Archarya!  Starting to add some EE to SE2 data collection queries.
REM 4.0.11.aws.20 = Collect more SE2 data.
REM 4.0.11.aws.21 = add another Diagnostic Pack check to double/triple check before running
REM 4.0.11.aws.22 = added note to user permissions needed (create session, select_catalog_role).  Tweaked HOSTS, HOSTS_CURRENT query.
REM 4.0.11.aws.23 = add even more Diagnostic Pack checks to really really check before running.
REM 4.0.11.aws.24 = tweaked regex to better remove domain names from Hosts query
REM 4.0.11.aws.25 = tweaked disk space query to filter out invalid status.  Added debug for sqlplus
REM 4.0.11.aws.26 = Added/revised documentation for the script
REM 4.0.11.aws.27 = Added DBID to dba_feature_usage_statistics query. Added SET tab off.  Added new DB_ metrics to general info section.
REM 4.0.11.aws.28 = Fixed bug with too long identifiers for pre12.2 databases - thanks PiniD.
REM 4.0.11.aws.29 = First attempt at being able to run against an individual PDB
REM 4.0.11.aws.30 = Changes to work with ADW and ATP databases
REM 4.0.11.aws.31 = A few performance tweaks.
REM 4.0.11.aws.32 = handle unexpected exceptions in General Information plsql code block better. tweaked HOST_CONNECTED query.
REM 4.0.11.aws.33 = added a message about also running against CDB when running against PDB
REM 4.0.11.aws.34 = collect physical read bytes per sec (not just physical read total bytes per sec).  start collecting IOSTAT_FUNCTION
REM 4.0.11.aws.35 = added workload breakout query (thanks mattiabe@)
REM 4.0.11.aws.36 = added some additional help text and prompts
REM 4.0.11.aws.37 = added some additional Temporary Tablespace and Exadata metrics
REM 4.0.11.aws.38 = added set NUMFORMAT to ensure expected output.  Comment out legacy ALTER SESSION WORKAREA,SORT_AREA commands leftover from years ago.
REM 4.0.11.aws.39 = fixed bug in collecting read_temp_iops, write_temp_iops
REM 4.0.11.aws.40 = address edge case where user has unusual SQLPlus settings. capture NLS_SORT and NLS_COMP

set termout on
prompt 
prompt 
prompt 
prompt 

Prompt This is the DBCSI data collection script for AWR version &AWR_MINER_VER
Prompt
Prompt NOTICE1: You Must Run this via SQL*PLUS.  Do not use TOAD or SQLDEVELOPER or anything else as they will corrupt the output file formatting.
Prompt NOTICE2: Please run this script as a SCRIPT via @aws_awr_miner.sql or START aws_awr_miner.sql.  Do not paste the contents of this script interactively into sqlplus or you will corrupt the output file format.
prompt NOTICE3: This script is being maintained and enhanced by a database specialist solutions architect and is not officially supported by AWS. No warranty or guarantee is expressed or implied.

prompt 
prompt 
prompt 
prompt 







define NUM_DAYS = 30
define CAPTURE_HOST_NAMES = 'YES'
define OPTIONAL_SECTIONS = 'YES'





-- ############################################################
REM This next section sets up SQL*Plus parameters so that the output file is formatted exactly as expected/needed.

clear breaks
clear columns
clear computes
set recsep off
ttitle off
btitle off
set underline '-'
set define '&'
set concat '~'
set colsep " "
set pagesize 50000
SET ARRAYSIZE 5000
SET echo off
SET termout off
SET tab off
REPHEADER OFF
REPFOOTER OFF





-- ############################################################
REM This next section asks the human to confirm that they are licensed to use Diagnostics Pack.  We require human confirmation.
REM This is because Oracle's rules are that you can not query dba_hist_* tables if you don't have the Diag Pack license.

set termout on
PROMPT
PROMPT ##################### YOUR INPUT IS NEEDED TO CONTINUE  ##################### 
Prompt
Prompt PLEASE READ: This script assumes that you have a valid license for Diagnostics Pack.  Do not continue with this script if you do not.
Prompt If you do not have a Diagnostic Pack license, you can download a STATSPACK-based version of this script from https://dbcsi.d29q8g3b9hzyur.amplifyapp.com/aws_statspack_miner.sql


PROMPT
PROMPT IN ORDER TO PROCEED, we need your authorization to use Diagnostic Pack features to continue.  
PROMPT
PROMPT To provide authorization, please type in the following exact phrase: 
PROMPT dba_hist
PROMPT
ACCEPT diagpackprefix CHAR PROMPT '> '
PROMPT You entered: &diagpackprefix
PROMPT


set termout on
set serveroutput on
set verify off
set linesize 1000
prompt Confirming that Diagnostics Pack is licensed.
prompt

whenever sqlerror exit
declare
   IS_OK char(3) := 'YES';
Begin
    if (nvl(lower('&diagpackprefix'),'x') != 'dba_hist') then
        dbms_output.put_line('WARNING: This script is expecting to be able to use the DBA_HIST tables which require the Diagnostics Pack.');
        dbms_output.put_line('To authorize the script to use the DBA_HIST tables, we needed you to enter the phrase: dba_hist');
        dbms_output.put_line('However, it seems that you did not.');
        dbms_output.put_line('Ask your AWS contact for the STATSPACK version of the data collection script.');
        dbms_output.put_line('The script will now exit (you can ignore the invalid SQL statement error message used to force the exit).');
        dbms_output.put_line('.');
        --RAISE_APPLICATION_ERROR(-20000, 'Exiting Script');
        execute immediate 'exit';
      
    end if;
    
    FOR cPA in (select name, value from v$parameter
      where name in ('control_management_pack_access')
        order by name)
    loop
        if (cPA.value = 'NONE') then
          IS_OK:='NO';
        end if;
    end loop;

    if IS_OK = 'NO'  then
        dbms_output.put_line('WARNING: This script is expecting to be able to use the DBA_HIST tables which require the Diagnostics Pack.');
        dbms_output.put_line('However, CONTROL_MANAGEMENT_PACK_ACCESS is set to NONE.');
        dbms_output.put_line('Ask your AWS contact for the STATSPACK version of the data collection script.');
        dbms_output.put_line('The script will now exit (you can ignore the invalid SQL statement error message used to force the exit).');
        dbms_output.put_line('.');
        --RAISE_APPLICATION_ERROR(-20000, 'Exiting Script');
        execute immediate 'exit';

    end if;
end;
/
set termout off
set serveroutput off
whenever sqlerror continue





-- ############################################################
REM This next section identifies the Oracle version (as we need to change parts of certain queries based on the version due to changes in data dictionary views)
REM This section also sets up some general SQL*Plus settings and session tuning parameters (largely copied from the original AWR miner script)

define DB_VERSION = 0
column :DB_VERSION_1 new_value DB_VERSION noprint
variable DB_VERSION_1 number

declare
	version_gte_11_2	varchar2(30);
	l_sql				varchar2(32767);
	l_variables	        varchar2(1000) := ' ';
begin
	:DB_VERSION_1 :=  dbms_db_version.version + (dbms_db_version.release / 10);
	--l_variables := l_variables||'ver_gte_11_2:TRUE';
	
	if :DB_VERSION_1  >= 11.2 then
		l_variables := l_variables||'ver_gte_11_2:TRUE';
	else
		l_variables := l_variables||'ver_gte_11_2:FALSE';
	end if;
	
	if :DB_VERSION_1  >= 11.1 then
		l_variables := l_variables||',ver_gte_11_1:TRUE';
	else
		l_variables := l_variables||',ver_gte_11_1:FALSE';
	end if;
	
	--alter session set plsql_ccflags = 'debug_flag:true';
	l_sql := q'[alter session set plsql_ccflags =']'||l_variables||q'[']';
	execute immediate l_sql;
end;
/


select :DB_VERSION_1 from dual;

define T_WAITED_MICRO_COL = 'TIME_WAITED_MICRO' 
column :T_WAITED_MICRO_COL_1 new_value T_WAITED_MICRO_COL noprint
variable T_WAITED_MICRO_COL_1 varchar2(30)

define COMPRESS_FOR_COL = 'COMPRESS_FOR' 
column :COMPRESS_FOR_COL_1 new_value COMPRESS_FOR_COL noprint
variable COMPRESS_FOR_COL_1 varchar2(30)


begin
	if :DB_VERSION_1  >= 11.1 then
		:T_WAITED_MICRO_COL_1 := 'TIME_WAITED_MICRO_FG';
		:COMPRESS_FOR_COL_1 := 'COMPRESS_FOR';
	else
		:T_WAITED_MICRO_COL_1 := 'TIME_WAITED_MICRO';
		:COMPRESS_FOR_COL_1 := '''BASIC''';
	end if;

end;
/

select :T_WAITED_MICRO_COL_1, :COMPRESS_FOR_COL_1 from dual;

define CDB_OR_DBA_COL = 'DBA' 
column :CDB_OR_DBA_COL_1 new_value CDB_OR_DBA_COL noprint
variable CDB_OR_DBA_COL_1 varchar2(30)
define DISK_SIZE_12C = ' ' 
column :DISK_SIZE_12C_1 new_value DISK_SIZE_12C noprint
variable DISK_SIZE_12C_1 varchar2(30)
define DISK_SIZE_12C_WHERE = ' ' 
column :DISK_SIZE_12C_WHERE_1 new_value DISK_SIZE_12C_WHERE noprint
variable DISK_SIZE_12C_WHERE_1 varchar2(30)
define DISK_SIZE_12C_TABLE = ' ' 
column :DISK_SIZE_12C_TABLE_1 new_value DISK_SIZE_12C_TABLE noprint
variable DISK_SIZE_12C_TABLE_1 varchar2(30)
define CDB_PDB_VIEW = 'dual' 
column :CDB_PDB_VIEW_1 new_value CDB_PDB_VIEW noprint
variable CDB_PDB_VIEW_1 varchar2(30)
define CDB_PDB_VIEW2 = 'dual' 
column :CDB_PDB_VIEW2_1 new_value CDB_PDB_VIEW2 noprint
variable CDB_PDB_VIEW2_1 varchar2(50)
define CDB_PDB_EXPR = 'null' 
column :CDB_PDB_EXPR_1 new_value CDB_PDB_EXPR noprint
variable CDB_PDB_EXPR_1 varchar2(50)
variable SPOOL_BASE_FILE varchar2(80)
variable IS_PDB varchar2(10)
variable PDB_DBID varchar2(30)
variable PDB_NAME varchar2(30)
variable CON_ID varchar2(10)
define PDB_IOPS_QUERY = ' ' 
column :PDB_IOPS_QUERY_1 new_value PDB_IOPS_QUERY noprint
variable PDB_IOPS_QUERY_1 varchar2(2000)
define PDB_AWR_PREFIX = '' 
column :PDB_AWR_PREFIX_1 new_value PDB_AWR_PREFIX noprint
variable PDB_AWR_PREFIX_1 varchar2(10)
define PDB_AWR_SYSMETRIC_SUMM = '_sysmetric_summary' 
column :PDB_AWR_SYSMETRIC_SUMM_1 new_value PDB_AWR_SYSMETRIC_SUMM noprint
variable PDB_AWR_SYSMETRIC_SUMM_1 varchar2(30)
column :NEW_SNAP_ID_MIN new_value SNAP_ID_MIN noprint
variable NEW_SNAP_ID_MIN number;

whenever sqlerror continue

REM next 2 lines were left over from original awr_miner.sql.  Now commented out as we dont think they are universally needed
REM ALTER SESSION SET WORKAREA_SIZE_POLICY = manual;
REM ALTER SESSION SET SORT_AREA_SIZE = 268435456;

alter session set nls_numeric_characters='. ';



set timing off
set autotrace off
set serveroutput on
set verify off




-- ############################################################
REM This next section identifies the DBID.  There could be multiple DBIDs hanging out in the AWR tables for a variety of reasons, so we need to get the current one.


column cnt_dbid_1 new_value CNT_DBID noprint


alter session set cursor_sharing = exact;

SELECT count(DISTINCT dbid) cnt_dbid_1
FROM &diagpackprefix~_database_instance
where dbid in (select dbid from v$database);
 --where rownum = 1;

define DBID = ' ' 
column :DBID_1 new_value DBID noprint
variable DBID_1 varchar2(30)

begin

	if to_number(&CNT_DBID) > 1 then
		:DBID_1 := ' ';
	else
		
		SELECT DISTINCT dbid into :DBID_1
					 FROM &diagpackprefix~_database_instance
					where dbid in (select dbid from v$database);
	end if;	

end;
/
select :DBID_1 from dual;

REM set heading off
set feedback off

REM select '&DBID' a from dual;

set termout on
column db_name1 new_value DBNAME
prompt Will export subset of AWR metrics for the following Database:

SELECT dbid,db_name db_name1, substr(sys_context('USERENV', 'DB_NAME'),1,9) db_name2
FROM &diagpackprefix~_database_instance
where dbid = '&DBID'
and rownum = 1;

prompt
set termout off






-- ############################################################
REM This next section identifies the start and end snapshot to collect

column snap_min1 new_value SNAP_ID_MIN noprint
SELECT min(snap_id) - 1 snap_min1
  FROM &diagpackprefix~_snapshot
  WHERE dbid = &DBID 
    and begin_interval_time > (
		SELECT max(begin_interval_time) - &NUM_DAYS
		  FROM &diagpackprefix~_snapshot 
		  where dbid = &DBID);
		  
column snap_max1 new_value SNAP_ID_MAX noprint
SELECT max(snap_id) snap_max1
  FROM &diagpackprefix~_snapshot
  WHERE dbid = &DBID;
  
REM if you want to run for a specific range of snapshots, uncomment then edit the following line appropriately.  
REM select 13320 snap_min1, 13330 snap_max1 from dual;





-- ############################################################
REM This next section validates that we are running against the CDB (which is required to get the full set of metrics needed)

set termout on
set serveroutput on
prompt Checking if we are connected to a PDB.
prompt

whenever sqlerror exit
declare
   CON_ID number  := 0;
   IS_CDB char(3) := 'NO';
   pdb_name varchar2(40);
   pdb_dbid number;
   
Begin
    :SPOOL_BASE_FILE := '&DBNAME'||'-'||'&DBID';

    :NEW_SNAP_ID_MIN := &SNAP_ID_MIN;    
    :PDB_AWR_SYSMETRIC_SUMM_1 := '_SYSMETRIC_SUMMARY';
    :PDB_AWR_PREFIX_1 := '';
    :IS_PDB := 'NO';
    if :DB_VERSION_1 >= 12.0 then
       SELECT SYS_CONTEXT('USERENV','CON_ID') INTO CON_ID FROM dual;
       execute immediate 'SELECT CDB FROM V$DATABASE' into is_cdb;
       :CON_ID := CON_ID;

    end if; 

    
    if :DB_VERSION_1 < 12.2 AND IS_CDB = 'YES' AND CON_ID != 1 then
        dbms_output.put_line('This is a container database and less than 12.2 and looks like we are connected to the PDB not the CDB.');
        dbms_output.put_line('This script will abort.  Please connect only to the CDB ROOT.');
        dbms_output.put_line('.');
        RAISE_APPLICATION_ERROR(-20000, 'Exiting Script');
        execute immediate 'exit';

    elsif :DB_VERSION_1 >= 12.2 AND IS_CDB = 'YES' AND CON_ID != 1 then
        dbms_output.put_line('This is a container database and looks like we are connected to the PDB not the CDB.');
        dbms_output.put_line('This script will continue using the PDB-based collection algorithms.');
        dbms_output.put_line('.');
        dbms_output.put_line('IMPORTANT: We STRONGLY suggest that you also run this script against the CDB itself and upload both outputs to DBCSI.');
        dbms_output.put_line('Data collected by also running against the CDB will be used by DBCSI to improve sizing results for your PDB.');
        dbms_output.put_line('.');
        dbms_output.put_line('.');
        execute immediate 'SELECT name, dbid FROM V$PDBS where con_id = sys_context(''USERENV'',''CON_ID'')' into pdb_name, pdb_dbid;
        execute immediate 'SELECT min(snap_id) FROM &diagpackprefix~_RSRC_PDB_METRIC where dbid= &DBID' into :NEW_SNAP_ID_MIN;
        :CDB_OR_DBA_COL_1      := 'DBA';
        :DISK_SIZE_12C_1       := ' ';
        :DISK_SIZE_12C_WHERE_1 := ' ';
        :DISK_SIZE_12C_TABLE_1 := ' &diagpackprefix~_tablespace ';
        :CDB_PDB_VIEW_1        := 'dual';
        :CDB_PDB_VIEW2_1       := 'dual';
        :CDB_PDB_EXPR_1        := 'null';
        :SPOOL_BASE_FILE       := '&DBNAME'||'-'||pdb_name||'-'||'&DBID'||'-'||pdb_dbid;
        :IS_PDB := 'YES';
        :PDB_NAME := pdb_name;
        :PDB_DBID := pdb_dbid;
        :PDB_AWR_SYSMETRIC_SUMM_1 := '_CON_SYSMETRIC_SUMM';
        :PDB_AWR_PREFIX_1 := '_CON';
        :CON_ID := CON_ID;

        
        :PDB_IOPS_QUERY_1 := ' union all select snap_id,null num_interval,to_char(end_time,''YY/MM/DD HH24:MI'') end_time,instance_number inst, metric_name,round(metric_value,1) average,
  null maxval,null standard_deviation from
(  
select snap_id, dbid, end_time,instance_number, ''PDB_IOPS'' metric_name, IOPS metric_value from &diagpackprefix~_RSRC_PDB_METRIC 
union all
select snap_id, dbid, end_time,instance_number, ''PDB_IOMBPS'' metric_name, IOMBPS metric_value from &diagpackprefix~_RSRC_PDB_METRIC 
union all
select snap_id, dbid, end_time,instance_number, ''PDB_SGA'' metric_name, SGA_BYTES metric_value from &diagpackprefix~_RSRC_PDB_METRIC 
union all
select snap_id, dbid, end_time,instance_number, ''PDB_PGA'' metric_name, PGA_BYTES metric_value from &diagpackprefix~_RSRC_PDB_METRIC 
union all
select snap_id, dbid, end_time,instance_number, ''PDB_CPU_USAGE_PER_S'' metric_name, CPU_CONSUMED_TIME/INTSIZE_CSEC/10 metric_value from &diagpackprefix~_RSRC_PDB_METRIC 
)
where dbid = &DBID
 and snap_id between '||:NEW_SNAP_ID_MIN||' and &SNAP_ID_MAX
 and snap_id -1 not in 
    (select max(snap_id) last_snap_before_seq_chg from &diagpackprefix~_RSRC_PDB_METRIC
      where dbid = &DBID
        and snap_id between '||:NEW_SNAP_ID_MIN||' and &SNAP_ID_MAX
      group by sequence#)
 ';
-- BUG: PDB_IOPS and PDB_IOMBPS figures are wrong when sequence# changes in DBA_HIST_RSRC_PDB_METRIC
-- for now, just remove those snapshot right after a change in sequence# (this is the "snap_id -1 not in" subquery)
        

    elsif :DB_VERSION_1 >= 12.0 AND IS_CDB = 'YES' AND CON_ID = 1 then

        dbms_output.put_line('This is a container database and we are connected to the CDB ROOT.');        
        :CDB_OR_DBA_COL_1      := 'CDB';
        :DISK_SIZE_12C_1       := ' con_id, ';
        :DISK_SIZE_12C_WHERE_1 := ' and f.con_id = sp.con_id ';
        :DISK_SIZE_12C_TABLE_1 := ' &diagpackprefix~_tablespace ';
        :CDB_PDB_VIEW_1        := 'v$pdbs';
        :CDB_PDB_VIEW2_1       := 'v$containers where dbid=&DBID';
        :CDB_PDB_EXPR_1        := 'sys_context(''USERENV'', ''con_name'')';
    else

        dbms_output.put_line('This is a non-container database.');   
        :CDB_OR_DBA_COL_1      := 'DBA';
        :DISK_SIZE_12C_1       := ' ';
        :DISK_SIZE_12C_WHERE_1 := ' ';
        :DISK_SIZE_12C_TABLE_1 := ' &diagpackprefix~_datafile ';
        :CDB_PDB_VIEW_1        := 'dual';
        :CDB_PDB_VIEW2_1       := 'dual';
        :CDB_PDB_EXPR_1        := 'null';
        
        if :DB_VERSION_1 >= 12.0 then
          :DISK_SIZE_12C_TABLE_1 := ' &diagpackprefix~_tablespace ';
        end if;
    end if;
end;
/

REM define a few version-sensitive or pdb-sensitive query strings
set termout off
select :CDB_OR_DBA_COL_1, :DISK_SIZE_12C_WHERE_1, :DISK_SIZE_12C_1, :DISK_SIZE_12C_TABLE_1, :CDB_PDB_VIEW_1, :CDB_PDB_VIEW2_1, :CDB_PDB_EXPR_1,
  :PDB_IOPS_QUERY_1, :PDB_AWR_PREFIX_1, :PDB_AWR_SYSMETRIC_SUMM_1, :NEW_SNAP_ID_MIN from dual;







-- ############################################################
REM This next section opens up the output file and starts spooling to it

whenever sqlerror continue

set termout on

Prompt
Prompt Now starting to retrieve metrics.  This may take a few minutes.
Prompt
prompt Please be patient while we collect data.
prompt

set termout off



-- ############################################################
REM Uncomment the follow two lines if you need to debug a long-running script
SET TIMING ON
REM SET AUTOTRACE ON STATISTICS



column FILE_NAME new_value SPOOL_FILE_NAME noprint
select 'awr-hist-'||:SPOOL_BASE_FILE||'-'||ltrim('&SNAP_ID_MIN')||'-'||ltrim('&SNAP_ID_MAX')||'.out' FILE_NAME from dual;
spool &SPOOL_FILE_NAME

REPHEADER ON
REPFOOTER ON 

set linesize 1500 
set numwidth 10
set numformat ""
set wrap off
set heading on
set trimspool on
set feedback off
set long 600





-- ############################################################
REM This next section gathers General Information about the database- this data maps to the General Information section in DBCSI.
REM The code prints out a series of key/value lines via dbms_output.

set serveroutput on
DECLARE
    l_pad_length number :=60;
	l_hosts	varchar2(4000);

BEGIN

    dbms_output.put_line('~~BEGIN-OS-INFORMATION~~');
    dbms_output.put_line(rpad('STAT_NAME',l_pad_length)||' '||'STAT_VALUE');
    dbms_output.put_line(rpad('-',l_pad_length,'-')||' '||rpad('-',l_pad_length,'-'));

    dbms_output.put_line(rpad('AWR_MINER_VER',l_pad_length)||' &AWR_MINER_VER');
  
  begin
	FOR c2 IN (SELECT 
						$IF $$VER_GTE_11_2 $THEN
							REPLACE(platform_name,' ','_') platform_name,
						$ELSE
							'None' platform_name,
						$END
						VERSION,db_name,DBID FROM &diagpackprefix~_database_instance 
						WHERE dbid = &DBID  
						and startup_time = (select max(startup_time) from &diagpackprefix~_database_instance WHERE dbid = &DBID )
						AND ROWNUM = 1)
    loop
        if :IS_PDB='YES' then
          dbms_output.put_line(rpad('DB_NAME',l_pad_length)||' '||c2.db_name||'-'||:PDB_NAME);
          dbms_output.put_line(rpad('DBID',l_pad_length)||' '||c2.DBID||'-'||:PDB_DBID);
          dbms_output.put_line(rpad('IS_PDB',l_pad_length)||' '||'YES');
          dbms_output.put_line(rpad('PDB_NAME',l_pad_length)||' '||:PDB_NAME);
          dbms_output.put_line(rpad('PDB_DBID',l_pad_length)||' '||:PDB_DBID);
          dbms_output.put_line(rpad('CON_ID',l_pad_length)||' '||:CON_ID);
        else
          dbms_output.put_line(rpad('DB_NAME',l_pad_length)||' '||c2.db_name);
          dbms_output.put_line(rpad('DBID',l_pad_length)||' '||c2.DBID);
        end if;  
        dbms_output.put_line(rpad('PLATFORM_NAME',l_pad_length)||' '||c2.platform_name);
        dbms_output.put_line(rpad('VERSION',l_pad_length)||' '||c2.VERSION);
    end loop; --c2
  exception
    when others then
      dbms_output.put_line(rpad('ERROR:C2',l_pad_length)||' '||sqlerrm);
  end;    
  
  
  begin
	FOR c2a IN (SELECT 
                       banner from v$version where banner like 'Oracle Database%')
    loop
        dbms_output.put_line(rpad('BANNER',l_pad_length)||' '||c2a.banner);
    end loop; --c2a
  exception
    when others then
      dbms_output.put_line(rpad('ERROR:C2A',l_pad_length)||' '||sqlerrm);
  end;      



  begin
    FOR c3 IN (SELECT count(distinct i.instance_number) instances
			     FROM &diagpackprefix~_database_instance i
			     where (dbid, instance_number, startup_time) in 
(select s0.dbid, s0.instance_number, max(s0.startup_time) startup_time  from &diagpackprefix~_snapshot s0
				WHERE s0.dbid = &DBID
				  AND s0.snap_id BETWEEN &SNAP_ID_MIN AND &SNAP_ID_MAX
				GROUP BY s0.dbid, s0.instance_number)  )
    loop
        dbms_output.put_line(rpad('INSTANCES',l_pad_length)||' '||c3.instances);
    end loop; --c3           
  exception
    when others then
      dbms_output.put_line(rpad('ERROR:C3',l_pad_length)||' '||sqlerrm);
  end;      



  
  begin	
    FOR c3a IN (SELECT count(distinct i.instance_number) instances
			     FROM gv$instance i)
    loop
        dbms_output.put_line(rpad('INSTANCES_CURRENT',l_pad_length)||' '||c3a.instances);
    end loop; --c3a           
  exception
    when others then
      dbms_output.put_line(rpad('ERROR:C3A',l_pad_length)||' '||sqlerrm);
  end;      



  begin
    FOR c3b IN (SELECT instance_number, regexp_replace(host_name,'^([[:alnum:]\-]+)\..*$','\1') host_name
			     FROM v$instance i)
    loop
        dbms_output.put_line(rpad('HOST_CONNECTED',l_pad_length)||' '||c3b.host_name);
        dbms_output.put_line(rpad('INSTANCE#_CONNECTED',l_pad_length)||' '||c3b.instance_number);
    end loop; --c3b           
  exception
    when others then
      dbms_output.put_line(rpad('ERROR:C3B',l_pad_length)||' '||sqlerrm);
  end;      



  begin
	
	FOR c4 IN (SELECT distinct regexp_replace(host_name,'^([[:alnum:]\-]+)\..*$','\1')  host_name 
			     FROM &diagpackprefix~_database_instance i
			     where (dbid, instance_number, startup_time) in 
(select s0.dbid, s0.instance_number, max(s0.startup_time) startup_time  from &diagpackprefix~_snapshot s0
				WHERE s0.dbid = &DBID
				  AND s0.snap_id BETWEEN &SNAP_ID_MIN AND &SNAP_ID_MAX
				GROUP BY s0.dbid, s0.instance_number)  
			    order by 1)
    loop
		if '&CAPTURE_HOST_NAMES' = 'YES' then
			l_hosts := l_hosts || c4.host_name ||',';	
		end if;
	end loop; --c4
	l_hosts := rtrim(l_hosts,',');
	dbms_output.put_line(rpad('HOSTS',l_pad_length)||' '||l_hosts);
  exception
    when others then
      dbms_output.put_line(rpad('ERROR:C4',l_pad_length)||' '||sqlerrm);
  end;      



  begin

    l_hosts := '';
	FOR c4a IN (SELECT distinct regexp_replace(host_name,'^([[:alnum:]\-]+)\..*$','\1')  host_name 
			     FROM gv$instance i
			    order by 1)
    loop
		if '&CAPTURE_HOST_NAMES' = 'YES' then
			l_hosts := l_hosts || c4a.host_name ||',';	
		end if;
	end loop; --c4a
	l_hosts := rtrim(l_hosts,',');
	dbms_output.put_line(rpad('HOSTS_CURRENT',l_pad_length)||' '||l_hosts);
  exception
    when others then
      dbms_output.put_line(rpad('ERROR:C4A',l_pad_length)||' '||sqlerrm);
  end;      



  begin


    FOR c1 IN (
			with inst as (
		select min(instance_number) inst_num
		  from &diagpackprefix~_snapshot
		  where dbid = &DBID
			and snap_id BETWEEN to_number(&SNAP_ID_MIN) and to_number(&SNAP_ID_MAX))
	SELECT 
                      CASE WHEN stat_name = 'PHYSICAL_MEMORY_BYTES' THEN 'PHYSICAL_MEMORY_GB' ELSE stat_name END stat_name,
                      CASE WHEN stat_name IN ('PHYSICAL_MEMORY_BYTES') THEN round(VALUE/1024/1024/1024,2) ELSE VALUE END stat_value
                  FROM &diagpackprefix~_osstat 
                 WHERE dbid = &DBID 
                   AND snap_id = (SELECT MAX(snap_id) FROM &diagpackprefix~_osstat WHERE dbid = &DBID AND instance_number = (select inst_num from inst))
				   AND instance_number = (select inst_num from inst)
                   AND (stat_name LIKE 'NUM_CPU%'
                   OR stat_name IN ('PHYSICAL_MEMORY_BYTES')))
    loop
        dbms_output.put_line(rpad(c1.stat_name,l_pad_length)||' '||c1.stat_value);
    end loop; --c1
  exception
    when others then
      dbms_output.put_line(rpad('ERROR:C1',l_pad_length)||' '||sqlerrm);
  end;      



  begin
    
    if :IS_PDB='YES' then
      --calculate GLOBAL_CPU_COUNT from DBA_HIST_OSSTAT
        FOR c1 IN (
    			with inst as (
    		select min(instance_number) inst_num
    		  from &diagpackprefix~_snapshot
    		  where dbid = &DBID
    			and snap_id BETWEEN to_number(&SNAP_ID_MIN) and to_number(&SNAP_ID_MAX))
    	SELECT 
                          stat_name,
                          sum(value) stat_value
                      FROM &diagpackprefix~_osstat 
                     WHERE dbid = &DBID 
                       AND snap_id = (SELECT MAX(snap_id) FROM &diagpackprefix~_osstat WHERE dbid = &DBID AND instance_number = (select inst_num from inst))
                       AND (stat_name LIKE 'NUM_CPU%')
                     GROUP BY stat_name)  
        loop
            dbms_output.put_line(rpad('GLOBAL_'||c1.stat_name,l_pad_length)||' '||c1.stat_value);
        end loop; --c1
        
    else  
        -- for non-PDBs, calculate GLOBAL_CPU_COUNT from DBA_CPU_USAGE_STATISTICS (for historical reasons)
    	for c1 in (SELECT CPU_COUNT,CPU_CORE_COUNT,CPU_SOCKET_COUNT
    				 FROM DBA_CPU_USAGE_STATISTICS 
    				where dbid = &DBID
    				  and TIMESTAMP = (select max(TIMESTAMP) from DBA_CPU_USAGE_STATISTICS where dbid = &DBID )
    				  AND ROWNUM = 1)
    	loop
    		dbms_output.put_line(rpad('GLOBAL_CPU_COUNT',l_pad_length)||' '||c1.CPU_COUNT);
    		dbms_output.put_line(rpad('GLOBAL_CPU_CORE_COUNT',l_pad_length)||' '||c1.CPU_CORE_COUNT);
    		dbms_output.put_line(rpad('GLOBAL_CPU_SOCKET_COUNT',l_pad_length)||' '||c1.CPU_SOCKET_COUNT);
    	end loop;
	end if;
	/* for c1 in (SELECT distinct platform_name FROM sys.GV_$DATABASE 
				where dbid = &DBID
				and rownum = 1)
	loop
		dbms_output.put_line(rpad('!PLATFORM_NAME',l_pad_length)||' '||c1.platform_name);
	end loop; */

  exception
    when others then
      dbms_output.put_line(rpad('ERROR:C1global',l_pad_length)||' '||sqlerrm);
  end;      



  begin

	
	FOR c6 IN (select /*+ inline */ round(sum(bytes)/1024/1024/1024) Total_DB_size_in_Gb from (select /*+ inline */ bytes from &CDB_OR_DBA_COL~_data_files where status !='INVALID' union all select /*+ inline */ bytes from &CDB_OR_DBA_COL~_temp_files where status in ('ONLINE','AVAILABLE')))
    loop
        dbms_output.put_line(rpad('TOTAL_DB_SIZE_GB',l_pad_length)||' '||c6.Total_DB_size_in_Gb);
    end loop; --c6  
  exception
    when others then
      dbms_output.put_line(rpad('ERROR:C6',l_pad_length)||' '||sqlerrm);
  end;      



  begin

	FOR c6b IN (select round(sum(bytes)/1024/1024/1024) Total_DB_size_in_Gb from &CDB_OR_DBA_COL~_data_files where status !='INVALID' )
    loop
        dbms_output.put_line(rpad('TOTAL_DATAFILE_SIZE_GB',l_pad_length)||' '||c6b.Total_DB_size_in_Gb);
    end loop; --c6b  
  exception
    when others then
      dbms_output.put_line(rpad('ERROR:C6b',l_pad_length)||' '||sqlerrm);
  end;      

  begin

	FOR c6c IN (select round(sum(bytes)/1024/1024/1024) Total_DB_size_in_Gb from &CDB_OR_DBA_COL~_temp_files where status in ('ONLINE','AVAILABLE') )
    loop
        dbms_output.put_line(rpad('TOTAL_TEMPFILE_SIZE_GB',l_pad_length)||' '||c6c.Total_DB_size_in_Gb);
    end loop; --c6c  
  exception
    when others then
      dbms_output.put_line(rpad('ERROR:C6c',l_pad_length)||' '||sqlerrm);
  end;      


  begin
	
	FOR c7 IN (select round(sum(bytes)/1024/1024/1024) Used_DB_size_in_Gb from &CDB_OR_DBA_COL~_segments)
    loop
        dbms_output.put_line(rpad('USED_DB_SIZE_GB',l_pad_length)||' '||c7.Used_DB_size_in_Gb);
    end loop; --c7  
  exception
    when others then
      dbms_output.put_line(rpad('ERROR:C7',l_pad_length)||' '||sqlerrm);
  end;      



  begin



   --Now gather some summary metrics.
   --To do so, we will re-use the detail queries from later in this script, but we will wrap them with statistical queries to get just the summaries we want.
   --First lets grap some metrics from the Main-Metrics section
   
   for cMain in (
with main_metrics as 
(
 select snap_id "snap",max(num_interval) "dur_m", max(end_time) "end",inst "inst",
nvl(max(decode(metric_name,'Host CPU Utilization (%)',					average,null)),0) "os_cpu",
nvl(max(decode(metric_name,'Host CPU Utilization (%)',					maxval,null)),0) "os_cpu_max",
nvl(max(decode(metric_name,'Host CPU Utilization (%)',					STANDARD_DEVIATION,null)),0) "os_cpu_sd",
nvl(max(decode(metric_name,'Database Wait Time Ratio',                   round(average,1),null)),0) "db_wait_ratio",
nvl(max(decode(metric_name,'Database CPU Time Ratio',                   round(average,1),null)),0) "db_cpu_ratio",
nvl(max(decode(metric_name,'CPU Usage Per Sec',                   round(average/100,3),null)),0) "cpu_per_s",
nvl(max(decode(metric_name,'CPU Usage Per Sec',   round(maxval/100,3),null)),0) "cpu_per_s_max",
nvl(max(decode(metric_name,'CPU Usage Per Sec',                   round(STANDARD_DEVIATION/100,3),null)),0) "cpu_per_s_sd",
nvl(max(decode(metric_name,'Average Active Sessions',                   average,null)),0) "aas",
nvl(max(decode(metric_name,'Average Active Sessions',                   STANDARD_DEVIATION,null)),0) "aas_sd",
nvl(max(decode(metric_name,'Average Active Sessions',                   maxval,null)),0) "aas_max",
nvl(max(decode(metric_name,'Database Time Per Sec',					average,null)),0) "db_time",
nvl(max(decode(metric_name,'Database Time Per Sec',					STANDARD_DEVIATION,null)),0) "db_time_sd",
nvl(max(decode(metric_name,'SQL Service Response Time',                   average,null)),0) "sql_res_t_cs",
nvl(max(decode(metric_name,'Background Time Per Sec',                   average,null)),0) "bkgd_t_per_s",
nvl(max(decode(metric_name,'Logons Per Sec',                            average,null)),0) "logons_s",
nvl(max(decode(metric_name,'Current Logons Count',                      average,null)),0) "logons_total",
nvl(max(decode(metric_name,'Executions Per Sec',                        average,null)),0) "exec_s",
nvl(max(decode(metric_name,'Hard Parse Count Per Sec',                  average,null)),0) "hard_p_s",
nvl(max(decode(metric_name,'Logical Reads Per Sec',                     average,null)),0) "l_reads_s",
nvl(max(decode(metric_name,'User Commits Per Sec',                      average,null)),0) "commits_s",
nvl(max(decode(metric_name,'Physical Read Total Bytes Per Sec',         round((average)/1024/1024,1),null)),0) "read_mb_s",
nvl(max(decode(metric_name,'Physical Read Total Bytes Per Sec',         round((maxval)/1024/1024,1),null)),0) "read_mb_s_max",
nvl(max(decode(metric_name,'Physical Read Total IO Requests Per Sec',   average,null)),0) "read_iops",
nvl(max(decode(metric_name,'Physical Read Total IO Requests Per Sec',   maxval,null)),0) "read_iops_max",
nvl(max(decode(metric_name,'Physical Reads Per Sec',  			average,null)),0) "read_bks",
nvl(max(decode(metric_name,'Physical Reads Direct Per Sec',  			average,null)),0) "read_bks_direct",
nvl(max(decode(metric_name,'Physical Write Total Bytes Per Sec',        round((average)/1024/1024,1),null)),0) "write_mb_s",
nvl(max(decode(metric_name,'Physical Write Total Bytes Per Sec',        round((maxval)/1024/1024,1),null)),0) "write_mb_s_max",
nvl(max(decode(metric_name,'Physical Write Total IO Requests Per Sec',  average,null)),0) "write_iops",
nvl(max(decode(metric_name,'Physical Write Total IO Requests Per Sec',  maxval,null)),0) "write_iops_max",
nvl(max(decode(metric_name,'Physical Writes Per Sec',  			average,null)),0) "write_bks",
nvl(max(decode(metric_name,'Physical Writes Direct Per Sec',  			average,null)),0) "write_bks_direct",
nvl(max(decode(metric_name,'Physical Read Bytes Per Sec',         round((average)/1024/1024,1),null)),0) "read_nt_mb_s",
nvl(max(decode(metric_name,'Physical Read Bytes Per Sec',         round((maxval)/1024/1024,1),null)),0) "read_nt_mb_s_max",
nvl(max(decode(metric_name,'Physical Read IO Requests Per Sec',   average,null)),0) "read_nt_iops",
nvl(max(decode(metric_name,'Physical Read IO Requests Per Sec',   maxval,null)),0) "read_nt_iops_max",
nvl(max(decode(metric_name,'Physical Write Bytes Per Sec',        round((average)/1024/1024,1),null)),0) "write_nt_mb_s",
nvl(max(decode(metric_name,'Physical Write Bytes Per Sec',        round((maxval)/1024/1024,1),null)),0) "write_nt_mb_s_max",
nvl(max(decode(metric_name,'Physical Write IO Requests Per Sec',  average,null)),0) "write_nt_iops",
nvl(max(decode(metric_name,'Physical Write IO Requests Per Sec',  maxval,null)),0) "write_nt_iops_max",
nvl(max(decode(metric_name,'Redo Generated Per Sec',                    round((average)/1024/1024,1),null)),0) "redo_mb_s",
nvl(max(decode(metric_name,'DB Block Gets Per Sec',                     average,null)),0) "db_block_gets_s",
nvl(max(decode(metric_name,'DB Block Changes Per Sec',                   average,null)),0) "db_block_changes_s",
nvl(max(decode(metric_name,'GC CR Block Received Per Second',            average,null)),0) "gc_cr_rec_s",
nvl(max(decode(metric_name,'GC Current Block Received Per Second',       average,null)),0) "gc_cu_rec_s",
nvl(max(decode(metric_name,'Global Cache Average CR Get Time',           average,null)),0) "gc_cr_get_cs",
nvl(max(decode(metric_name,'Global Cache Average Current Get Time',      average,null)),0) "gc_cu_get_cs",
nvl(max(decode(metric_name,'Global Cache Blocks Corrupted',              average,null)),0) "gc_bk_corrupted",
nvl(max(decode(metric_name,'Global Cache Blocks Lost',                   average,null)),0) "gc_bk_lost",
nvl(max(decode(metric_name,'Active Parallel Sessions',                   average,null)),0) "px_sess",
nvl(max(decode(metric_name,'Active Serial Sessions',                     average,null)),0) "se_sess",
nvl(max(decode(metric_name,'Average Synchronous Single-Block Read Latency', average,null)),0) "s_blk_r_lat",
nvl(max(decode(metric_name,'Host CPU Usage Per Sec',                   round(average/100,3),null)),0) "h_cpu_per_s",
nvl(max(decode(metric_name,'Host CPU Usage Per Sec',                   round(maxval/100,3),null)),0) "h_cpu_per_s_max",
nvl(max(decode(metric_name,'Host CPU Usage Per Sec',                   round(STANDARD_DEVIATION/100,3),null)),0) "h_cpu_per_s_sd",
nvl(max(decode(metric_name,'Cell Physical IO Interconnect Bytes',         round((average)/1024/1024,1),null)),0) "cell_io_int_mb",
nvl(max(decode(metric_name,'Cell Physical IO Interconnect Bytes',         round((maxval)/1024/1024,1),null)),0) "cell_io_int_mb_max",
 --the cell physical IO bytes metrics are for 1 minute, so remember to divide them by 60 if you are expecting bytes per second
max(decode(metric_name,'PDB_IOPS',                     average,null)) "PDB_IOPS",
max(decode(metric_name,'PDB_IOMBPS',                     average,null)) "PDB_IOMBPS",
max(decode(metric_name,'PDB_SGA',                     round(average / 1024 / 1024 / 1024, 1),null)) "PDB_SGA",
max(decode(metric_name,'PDB_PGA',                     round(average / 1024 / 1024 / 1024, 1),null)) "PDB_PGA",
max(decode(metric_name,'PDB_CPU_USAGE_PER_S',                     average,null)) "PDB_CPU_USAGE_PER_S"
  from(
  select  snap_id,num_interval,to_char(end_time,'YY/MM/DD HH24:MI') end_time,instance_number inst,metric_name,round(average,1) average,
  round(maxval,1) maxval,round(standard_deviation,1) standard_deviation
 from &diagpackprefix~&PDB_AWR_SYSMETRIC_SUMM
where dbid = &DBID
 and snap_id between &SNAP_ID_MIN and &SNAP_ID_MAX
 --and snap_id = 920
 --and instance_number = 4
 and metric_name in ('Host CPU Utilization (%)','CPU Usage Per Sec','Host CPU Usage Per Sec','Average Active Sessions','Database Time Per Sec',
 'Executions Per Sec','Hard Parse Count Per Sec','Logical Reads Per Sec','Logons Per Sec',
 'Physical Read Total Bytes Per Sec','Physical Read Total IO Requests Per Sec','Physical Reads Per Sec','Physical Write Total Bytes Per Sec',
 'Redo Generated Per Sec','User Commits Per Sec','Current Logons Count','DB Block Gets Per Sec','DB Block Changes Per Sec',
 'Database Wait Time Ratio','Database CPU Time Ratio','SQL Service Response Time','Background Time Per Sec',
 'Physical Write Total IO Requests Per Sec','Physical Writes Per Sec','Physical Writes Direct Per Sec','Physical Writes Direct Lobs Per Sec',
 'Physical Reads Direct Per Sec','Physical Reads Direct Lobs Per Sec',
 'GC CR Block Received Per Second','GC Current Block Received Per Second','Global Cache Average CR Get Time','Global Cache Average Current Get Time',
 'Global Cache Blocks Corrupted','Global Cache Blocks Lost',
 'Active Parallel Sessions','Active Serial Sessions','Average Synchronous Single-Block Read Latency','Cell Physical IO Interconnect Bytes',
 'Physical Read Bytes Per Sec','Physical Read IO Requests Per Sec','Physical Write Bytes Per Sec','Physical Write IO Requests Per Sec'
    )
 &PDB_IOPS_QUERY     --merge in PDB query against DBA_HIST_RSRC_PDB_METRIC if running in PDB
 )
 group by snap_id, inst
 order by snap_id, inst
),
 main_metrics_rw AS
 (
 select sum("cpu_per_s") "cpu_per_s",
        sum("cpu_per_s_max") "cpu_per_s_max",
        sum("h_cpu_per_s") "h_cpu_per_s",
        sum("h_cpu_per_s_max") "h_cpu_per_s_max", 
        sum("read_iops"+"write_iops") IOPS,
        sum("read_iops_max"+"write_iops_max") IOPS_MAX,        
        sum("read_mb_s"+"write_mb_s") IOMB,
        sum("read_mb_s_max"+"write_mb_s_max") IOMB_MAX,
        sum(PDB_IOPS) PDB_IOPS,
        sum(PDB_IOMBPS) PDB_IOMBPS,
        sum(PDB_SGA+PDB_PGA) PDB_SGAPGA_TOTAL
   from main_metrics
   group by "snap"
 )
 --
 select
     PERCENTILE_DISC(0.9900) WITHIN GROUP (ORDER BY "cpu_per_s")  DB_CPU_THREADS_AVERAGE_P99,
     PERCENTILE_DISC(0.5000) WITHIN GROUP (ORDER BY "cpu_per_s_max")  DB_CPU_THREADS_PEAKS_50,
     PERCENTILE_DISC(0.9000) WITHIN GROUP (ORDER BY "cpu_per_s_max")  DB_CPU_THREADS_PEAKS_90,
     PERCENTILE_DISC(0.9900) WITHIN GROUP (ORDER BY "h_cpu_per_s")  DB_HOST_CPU_THREADS_AVG_P99,
     PERCENTILE_DISC(0.5000) WITHIN GROUP (ORDER BY "h_cpu_per_s_max")  DB_HOST_CPU_THREADS_PEAKS_50,
     PERCENTILE_DISC(0.9000) WITHIN GROUP (ORDER BY "h_cpu_per_s_max")  DB_HOST_CPU_THREADS_PEAKS_90,
     PERCENTILE_DISC(0.9900) WITHIN GROUP (ORDER BY IOPS)  DB_IOPS_AVERAGE_P99,
     PERCENTILE_DISC(0.5000) WITHIN GROUP (ORDER BY IOPS_MAX)  DB_IOPS_PEAKS_P50,
     PERCENTILE_DISC(0.9000) WITHIN GROUP (ORDER BY IOPS_MAX)  DB_IOPS_PEAKS_P90,
     PERCENTILE_DISC(0.9900) WITHIN GROUP (ORDER BY IOMB)  DB_IOMB_AVERAGE_P99,
     PERCENTILE_DISC(0.5000) WITHIN GROUP (ORDER BY IOMB_MAX)  DB_IOMB_PEAKS_P50,
     PERCENTILE_DISC(0.9000) WITHIN GROUP (ORDER BY IOMB_MAX)  DB_IOMB_PEAKS_P90,
     PERCENTILE_DISC(0.9900) WITHIN GROUP (ORDER BY PDB_IOPS)  PDB_IOPS_AVERAGE_P99,
     PERCENTILE_DISC(0.9900) WITHIN GROUP (ORDER BY PDB_IOMBPS)  PDB_IOMBPS_AVERAGE_P99,
     max(PDB_SGAPGA_TOTAL)  PDB_SGAPGA_TOTAL_MAX
   from main_metrics_rw
   )
   loop
        dbms_output.put_line(rpad('DB_CPU_THREADS_AVERAGE_P99',l_pad_length)||' '||cMain.DB_CPU_THREADS_AVERAGE_P99);
        dbms_output.put_line(rpad('DB_CPU_THREADS_PEAKS_50',l_pad_length)||' '||cMain.DB_CPU_THREADS_PEAKS_50);
        dbms_output.put_line(rpad('DB_CPU_THREADS_PEAKS_90',l_pad_length)||' '||cMain.DB_CPU_THREADS_PEAKS_90);
        dbms_output.put_line(rpad('DB_HOST_CPU_THREADS_AVERAGE_P99',l_pad_length)||' '||cMain.DB_HOST_CPU_THREADS_AVG_P99);
        dbms_output.put_line(rpad('DB_HOST_CPU_THREADS_PEAKS_50',l_pad_length)||' '||cMain.DB_HOST_CPU_THREADS_PEAKS_50);
        dbms_output.put_line(rpad('DB_HOST_CPU_THREADS_PEAKS_90',l_pad_length)||' '||cMain.DB_HOST_CPU_THREADS_PEAKS_90);
        if :IS_PDB='YES' then
          dbms_output.put_line(rpad('DB_IOPS_AVERAGE_P99',l_pad_length)||' '||cMain.PDB_IOPS_AVERAGE_P99);
        else
          dbms_output.put_line(rpad('DB_IOPS_AVERAGE_P99',l_pad_length)||' '||cMain.DB_IOPS_AVERAGE_P99);
        end if;
        dbms_output.put_line(rpad('DB_IOPS_PEAKS_P50',l_pad_length)||' '||cMain.DB_IOPS_PEAKS_P50);
        dbms_output.put_line(rpad('DB_IOPS_PEAKS_P90',l_pad_length)||' '||cMain.DB_IOPS_PEAKS_P90);
        dbms_output.put_line(rpad('DB_IOMB_AVERAGE_P99',l_pad_length)||' '||cMain.DB_IOMB_AVERAGE_P99);
        dbms_output.put_line(rpad('DB_IOMB_PEAKS_P50',l_pad_length)||' '||cMain.DB_IOMB_PEAKS_P50);
        dbms_output.put_line(rpad('DB_IOMB_PEAKS_P90',l_pad_length)||' '||cMain.DB_IOMB_PEAKS_P90);
        if :IS_PDB='YES' then
          dbms_output.put_line(rpad('DB_SGAPGA_TOTAL',l_pad_length)||' '||cMain.PDB_SGAPGA_TOTAL_MAX);
        end if;   
   end loop;
  exception
    when others then
      dbms_output.put_line(rpad('ERROR:CMAIN',l_pad_length)||' '||sqlerrm);
  end;      



  begin
   
   
   
   --Now continue gathering summary metrics, this time from MEMORY detail section
   for cMemory in (
with memory AS
(
--
SELECT snap_id,
    instance_number,
    NVL(MAX (DECODE (stat_name, 'SGA', stat_value, NULL)),0) "SGA",
    NVL(MAX (DECODE (stat_name, 'PGA', stat_value, NULL)),0) "PGA",
    NVL(MAX (DECODE (stat_name, 'SGA', stat_value, NULL)),0) + MAX (DECODE (stat_name, 'PGA', stat_value,
    NULL)) "TOTAL"
   FROM
    (SELECT snap_id,
        instance_number,
        ROUND (SUM (bytes) / 1024 / 1024 / 1024, 1) stat_value,
        MAX ('SGA') stat_name
       FROM &diagpackprefix~_sgastat
      WHERE dbid = &DBID
        AND snap_id BETWEEN &SNAP_ID_MIN AND &SNAP_ID_MAX
   GROUP BY snap_id,
        instance_number
  UNION ALL
     SELECT snap_id,
        instance_number,
        ROUND (value / 1024 / 1024 / 1024, 1) stat_value,
        'PGA' stat_name
       FROM &diagpackprefix~_pgastat
      WHERE dbid = &DBID
        AND snap_id BETWEEN &SNAP_ID_MIN AND &SNAP_ID_MAX
        AND NAME = 'total PGA allocated'
    )
GROUP BY snap_id,
    instance_number
ORDER BY snap_id,
    instance_number
--    
),
memory_cluster AS
(
select
    snap_id,
    sum("TOTAL") SGAPGA
  from memory
  group by snap_id
)
--
select
     round(avg(SGAPGA),1) DB_SGAPGA_TOTAL
  from memory_cluster
)
   loop
     if nvl(:IS_PDB,'NO')!='YES' then
        dbms_output.put_line(rpad('DB_SGAPGA_TOTAL',l_pad_length)||' '||cMemory.DB_SGAPGA_TOTAL);
     end if;    
   end loop;
   
  exception
    when others then
      dbms_output.put_line(rpad('ERROR:CMEMORY',l_pad_length)||' '||sqlerrm);
  end;      



  begin


   --Now continue gathering summary metrics, this time from SYSSTAT detail section
   for cSysstat in 
(
   WITH sysmetric AS 
(
SELECT SNAP_ID,
  MAX(DECODE(event_name,'cell flash cache read hits', event_val_diff,NULL)) "cell_flash_hits",
  MAX(DECODE(event_name,'physical read total IO requests', event_val_diff,NULL)) "read_iops",
  MAX(DECODE(event_name,'physical write total IO requests', event_val_diff,NULL)) "write_iops",
  ROUND(MAX(DECODE(event_name,'physical read total bytes', event_val_diff,NULL))                                 /1024/1024,1) "read_mb",
  ROUND(MAX(DECODE(event_name,'physical read total bytes optimized', event_val_diff,NULL))                       /1024/1024,1) "read_mb_opt",
  MAX(DECODE(event_name,'physical read IO requests', event_val_diff,NULL)) "read_nt_iops",
  MAX(DECODE(event_name,'physical write IO requests', event_val_diff,NULL)) "write_nt_iops",
  ROUND(MAX(DECODE(event_name,'physical read bytes', event_val_diff,NULL))                                 /1024/1024,1) "read_nt_mb",
  ROUND(MAX(DECODE(event_name,'physical write bytes', event_val_diff,NULL))                       /1024/1024,1) "write_nt_mb",
  ROUND(MAX(DECODE(event_name,'cell physical IO interconnect bytes', event_val_diff,NULL))                       /1024/1024,1) "cell_int_mb",
  ROUND(MAX(DECODE(event_name,'cell physical IO interconnect bytes returned by smart scan', event_val_diff,NULL))/1024/1024,1) "cell_int_ss_mb",
  ROUND(MAX(DECODE(event_name,'cell physical IO bytes saved by storage index', event_val_diff,NULL))/1024/1024,1) "cell_si_save_mb",
  ROUND(MAX(DECODE(event_name,'cell physical IO bytes eligible for predicate offload', event_val_diff,NULL))/1024/1024,1) "cell_bytes_elig_mb",
  ROUND(MAX(DECODE(event_name,'HCC scan cell bytes decompressed', event_val_diff,NULL))/1024/1024,1) "cell_hcc_bytes_mb",
  ROUND(MAX(DECODE(event_name,'physical read total multi block requests', event_val_diff,NULL)) ,1) "read_multi_iops",
  ROUND(MAX(DECODE(event_name,'physical reads direct temporary tablespace', event_val_diff,NULL))  ,1) "read_temp_iops",
  ROUND(MAX(DECODE(event_name,'physical writes direct temporary tablespace', event_val_diff,NULL))  ,1) "write_temp_iops"
FROM
  (SELECT snap_id,
    event_name,
    ROUND(SUM(val_per_s),1) event_val_diff
  FROM
    (SELECT snap_id,
      instance_number,
      event_name,
      event_val_diff,
      (event_val_diff/ela) val_per_s
    FROM
      (SELECT (CAST (s.end_interval_time AS DATE) - CAST (s.begin_interval_time AS DATE)) * 24 * 3600 ela,
        s.snap_id,
        s.instance_number,
        t.stat_name wait_class,
        t.stat_name event_name,
        CASE
          WHEN s.begin_interval_time = s.startup_time
          THEN t.value
          ELSE t.value - lag (value) over (partition BY stat_id, t.dbid, t.instance_number, s.startup_time order by t.snap_id)
        END event_val_diff
      FROM &diagpackprefix~_snapshot s,
        &diagpackprefix~&PDB_AWR_PREFIX~_sysstat t
      WHERE s.dbid = t.dbid
      AND s.dbid   = &DBID
      AND s.instance_number = t.instance_number
      AND s.snap_id         = t.snap_id
      AND s.snap_id BETWEEN &SNAP_ID_MIN AND &SNAP_ID_MAX
      AND t.snap_id BETWEEN &SNAP_ID_MIN AND &SNAP_ID_MAX
      AND t.stat_name IN ('cell flash cache read hits','physical read total IO requests', 'physical write total IO requests', 'cell physical IO bytes saved by storage index',
      'cell physical IO interconnect bytes','cell physical IO interconnect bytes returned by smart scan', 
      'physical read total bytes','physical read total bytes optimized' , 'cell physical IO bytes eligible for predicate offload','HCC scan cell bytes decompressed',
      'physical read bytes','physical write bytes','physical read IO requests','physical write IO requests',
      'physical reads direct temporary tablespace', 'physical writes direct temporary tablespace', 'physical read total multi block requests')
      )
    WHERE event_val_diff IS NOT NULL
    )
  GROUP BY snap_id,
    event_name
  )
GROUP BY snap_id
ORDER BY SNAP_ID ASC
)
--
select 
       PERCENTILE_DISC(0.9900) WITHIN GROUP (ORDER BY "cell_bytes_elig_mb")  DB_EXA_CELL_BYTES_ELIG_MB_P99,
       PERCENTILE_DISC(0.9900) WITHIN GROUP (ORDER BY "cell_si_save_mb")  DB_EXA_CELL_SI_SAVE_MB_P99,
       PERCENTILE_DISC(0.9900) WITHIN GROUP (ORDER BY "cell_int_mb")  DB_EXA_CELL_INT_MB_P99,
       PERCENTILE_DISC(0.9900) WITHIN GROUP (ORDER BY "cell_int_ss_mb")  DB_EXA_CELL_INT_SS_MB_P99,
       PERCENTILE_DISC(0.9900) WITHIN GROUP (ORDER BY "cell_hcc_bytes_mb")  DB_EXA_CELL_HCC_BYTES_MB_P99,
       PERCENTILE_DISC(0.9900) WITHIN GROUP (ORDER BY "read_mb")  DB_EXA_READ_MB_P99,
       PERCENTILE_DISC(0.9900) WITHIN GROUP (ORDER BY "read_mb_opt")  DB_EXA_READ_MB_OPT_P99,
       PERCENTILE_DISC(0.9900) WITHIN GROUP (ORDER BY "read_multi_iops")  DB_EXA_READ_MULTI_P99,
       PERCENTILE_DISC(0.9900) WITHIN GROUP (ORDER BY "read_temp_iops")  DB_EXA_READ_TEMP_P99,
       PERCENTILE_DISC(0.9900) WITHIN GROUP (ORDER BY "write_temp_iops")  DB_EXA_WRITE_TEMP_P99
  from sysmetric
)
   loop
        dbms_output.put_line(rpad('DB_EXA_CELL_BYTES_ELIG_MB_P99',l_pad_length)||' '||cSysstat.DB_EXA_CELL_BYTES_ELIG_MB_P99);
        dbms_output.put_line(rpad('DB_EXA_CELL_SI_SAVE_MB_P99',l_pad_length)||' '||cSysstat.DB_EXA_CELL_SI_SAVE_MB_P99);
        dbms_output.put_line(rpad('DB_EXA_CELL_INT_MB_P99',l_pad_length)||' '||cSysstat.DB_EXA_CELL_INT_MB_P99);
        dbms_output.put_line(rpad('DB_EXA_CELL_INT_SS_MB_P99',l_pad_length)||' '||cSysstat.DB_EXA_CELL_INT_SS_MB_P99);
        dbms_output.put_line(rpad('DB_EXA_CELL_HCC_BYTES_MB_P99',l_pad_length)||' '||cSysstat.DB_EXA_CELL_HCC_BYTES_MB_P99);
        dbms_output.put_line(rpad('DB_EXA_READ_MB_P99',l_pad_length)||' '||cSysstat.DB_EXA_READ_MB_P99);
        dbms_output.put_line(rpad('DB_EXA_READ_MB_OPT_P99',l_pad_length)||' '||cSysstat.DB_EXA_READ_MB_OPT_P99);
        dbms_output.put_line(rpad('DB_EXA_READ_MULTI_P99',l_pad_length)||' '||cSysstat.DB_EXA_READ_MULTI_P99);
        dbms_output.put_line(rpad('DB_EXA_READ_TEMP_P99',l_pad_length)||' '||cSysstat.DB_EXA_READ_TEMP_P99);
        dbms_output.put_line(rpad('DB_EXA_WRITE_TEMP_P99',l_pad_length)||' '||cSysstat.DB_EXA_WRITE_TEMP_P99);
   end loop;
   
  exception
    when others then
      dbms_output.put_line(rpad('ERROR:CSYSSTAT',l_pad_length)||' '||sqlerrm);
  end;      



  begin
   
   
   --Now count number of various schema objects.  This can be used for an initial (rough) estimate of complexity in terms of converting to other platforms (such as PostgreSQL perhaps)
   --
	FOR c8 IN (select count(*) num_links from &CDB_OR_DBA_COL~_db_links)
    loop
        dbms_output.put_line(rpad('COUNT_DB_LINKS',l_pad_length)||' '||c8.num_links);
    end loop; --c8  

	FOR c9 IN (select nvl(count(line),0) line_total from &CDB_OR_DBA_COL~_source where owner not in ('RDSADMIN','SYS','SYSTEM','XDB','X$NULL','SYSMAN','SYSBACKUP','SPATIAL%','SI_INFORMTN_SCHEMA','ORDSYS','ORDDATA','OUTLN','OJVMSYS','OWB%','MDSYS','ORACLE_OCM','OLAPSYS','APEX_040200','APEX_030200','AUDSYS','APPQOSSYS','CTXSYS','DBSNMP','DVSYS','FLOWS_FILES','GSMADMIN_INTERNAL','LBACSYS','ORDPLUGINS','OWBSYS','OWBSYS_AUDIT','WMSYS','APEX_050000','REMOTE_SCHEDULER_AGENT','DVF','DBSFWUSER','SYSDG','SYSKM','XS$NULL','GSMUSER','DIP','ANONYMOUS','GSMCATUSER','MDDATA','APEX_PUBLIC_USER','SYSRAC','SYS$UMF','GGSYS','SPATIAL_CSW_ADMIN_USR') and owner not like 'APEX%' )
    loop
        dbms_output.put_line(rpad('COUNT_LINES_PLSQL',l_pad_length)||' '||c9.line_total);
    end loop; --c9  

	FOR c10 IN (select count(username) num_schemas from &CDB_OR_DBA_COL~_users where username not in ('RDSADMIN','SYS','SYSTEM','XDB','X$NULL','SYSMAN','SYSBACKUP','SPATIAL%','SI_INFORMTN_SCHEMA','ORDSYS','ORDDATA','OUTLN','OJVMSYS','OWB%','MDSYS','ORACLE_OCM','OLAPSYS','APEX_040200','APEX_030200','AUDSYS','APPQOSSYS','CTXSYS','DBSNMP','DVSYS','FLOWS_FILES','GSMADMIN_INTERNAL','LBACSYS','ORDPLUGINS','OWBSYS','OWBSYS_AUDIT','WMSYS','APEX_050000','REMOTE_SCHEDULER_AGENT','DVF','DBSFWUSER','SYSDG','SYSKM','XS$NULL','GSMUSER','DIP','ANONYMOUS','GSMCATUSER','MDDATA','APEX_PUBLIC_USER','SYSRAC','SYS$UMF','GGSYS','SPATIAL_CSW_ADMIN_USR') and username not like 'APEX%' )
    loop
        dbms_output.put_line(rpad('COUNT_SCHEMAS',l_pad_length)||' '||c10.num_schemas);
    end loop; --c10  
  exception
    when others then
      dbms_output.put_line(rpad('ERROR:C8-10',l_pad_length)||' '||sqlerrm);
  end;      



  begin

	FOR c11 IN (select count(*) num_pdbs from &CDB_PDB_VIEW )
    loop
        dbms_output.put_line(rpad('COUNT_PDBS',l_pad_length)||' '||(c11.num_pdbs-1));
    end loop; --c11
  exception
    when others then
      dbms_output.put_line(rpad('ERROR:C11',l_pad_length)||' '||sqlerrm);
  end;      



  begin

    FOR c12 in (select object_type, count(*) num_objs from &CDB_OR_DBA_COL~_objects
      where owner not in ('RDSADMIN','SYS','SYSTEM','XDB','X$NULL','SYSMAN','SYSBACKUP','SPATIAL%','SI_INFORMTN_SCHEMA','ORDSYS','ORDDATA','OUTLN','OJVMSYS','OWB%','MDSYS','ORACLE_OCM','OLAPSYS','APEX_040200','APEX_030200','AUDSYS','APPQOSSYS','CTXSYS','DBSNMP','DVSYS','FLOWS_FILES','GSMADMIN_INTERNAL','LBACSYS','ORDPLUGINS','OWBSYS','OWBSYS_AUDIT','WMSYS','APEX_050000','REMOTE_SCHEDULER_AGENT','DVF','DBSFWUSER','SYSDG','SYSKM','XS$NULL','GSMUSER','DIP','ANONYMOUS','GSMCATUSER','MDDATA','APEX_PUBLIC_USER','SYSRAC','SYS$UMF','GGSYS','SPATIAL_CSW_ADMIN_USR') 
      and owner not like 'APEX%'
      and object_type in ('TABLE','TABLE PARTITION','INDEX','INDEX PARTITION','CONSTRAINT','VIEW','MATERIALIZED VIEW','SEQUENCE','PACKAGE','PROCEDURE','FUNCTION','TRIGGER','TYPE','TYPE BODY','LOB')
      group by object_type
      order by object_type)
    loop
        dbms_output.put_line(rpad('COUNT_'||c12.object_type,l_pad_length)||' '||(c12.num_objs));
    end loop;
  exception
    when others then
      dbms_output.put_line(rpad('ERROR:C12',l_pad_length)||' '||sqlerrm);
  end;      


  begin

    FOR c12a in (select count(*) num_objs from &CDB_OR_DBA_COL~_tables
      where owner not in ('RDSADMIN','SYS','SYSTEM','XDB','X$NULL','SYSMAN','SYSBACKUP','SPATIAL%','SI_INFORMTN_SCHEMA','ORDSYS','ORDDATA','OUTLN','OJVMSYS','OWB%','MDSYS','ORACLE_OCM','OLAPSYS','APEX_040200','APEX_030200','AUDSYS','APPQOSSYS','CTXSYS','DBSNMP','DVSYS','FLOWS_FILES','GSMADMIN_INTERNAL','LBACSYS','ORDPLUGINS','OWBSYS','OWBSYS_AUDIT','WMSYS','APEX_050000','REMOTE_SCHEDULER_AGENT','DVF','DBSFWUSER','SYSDG','SYSKM','XS$NULL','GSMUSER','DIP','ANONYMOUS','GSMCATUSER','MDDATA','APEX_PUBLIC_USER','SYSRAC','SYS$UMF','GGSYS','SPATIAL_CSW_ADMIN_USR') 
      and owner not like 'APEX%'
      and compression='ENABLED'
      and &COMPRESS_FOR_COL not in ('BASIC','ADVANCED'))
    loop
        dbms_output.put_line(rpad('COUNT_TABLES_HCC',l_pad_length)||' '||(c12a.num_objs));
    end loop;
  exception
    when others then
      dbms_output.put_line(rpad('ERROR:C12a',l_pad_length)||' '||sqlerrm);
  end;      

  begin

    FOR c12b in (select count(*) num_objs from &CDB_OR_DBA_COL~_indexes
      where owner not in ('RDSADMIN','SYS','SYSTEM','XDB','X$NULL','SYSMAN','SYSBACKUP','SPATIAL%','SI_INFORMTN_SCHEMA','ORDSYS','ORDDATA','OUTLN','OJVMSYS','OWB%','MDSYS','ORACLE_OCM','OLAPSYS','APEX_040200','APEX_030200','AUDSYS','APPQOSSYS','CTXSYS','DBSNMP','DVSYS','FLOWS_FILES','GSMADMIN_INTERNAL','LBACSYS','ORDPLUGINS','OWBSYS','OWBSYS_AUDIT','WMSYS','APEX_050000','REMOTE_SCHEDULER_AGENT','DVF','DBSFWUSER','SYSDG','SYSKM','XS$NULL','GSMUSER','DIP','ANONYMOUS','GSMCATUSER','MDDATA','APEX_PUBLIC_USER','SYSRAC','SYS$UMF','GGSYS','SPATIAL_CSW_ADMIN_USR') 
      and owner not like 'APEX%'
      and index_type='BITMAP')
    loop
        dbms_output.put_line(rpad('COUNT_BITMAP_INDEX',l_pad_length)||' '||(c12b.num_objs));
    end loop;

    FOR c12c in (select count(*) num_objs from &CDB_OR_DBA_COL~_mviews
      where owner not in ('RDSADMIN','SYS','SYSTEM','XDB','X$NULL','SYSMAN','SYSBACKUP','SPATIAL%','SI_INFORMTN_SCHEMA','ORDSYS','ORDDATA','OUTLN','OJVMSYS','OWB%','MDSYS','ORACLE_OCM','OLAPSYS','APEX_040200','APEX_030200','AUDSYS','APPQOSSYS','CTXSYS','DBSNMP','DVSYS','FLOWS_FILES','GSMADMIN_INTERNAL','LBACSYS','ORDPLUGINS','OWBSYS','OWBSYS_AUDIT','WMSYS','APEX_050000','REMOTE_SCHEDULER_AGENT','DVF','DBSFWUSER','SYSDG','SYSKM','XS$NULL','GSMUSER','DIP','ANONYMOUS','GSMCATUSER','MDDATA','APEX_PUBLIC_USER','SYSRAC','SYS$UMF','GGSYS','SPATIAL_CSW_ADMIN_USR') 
      and owner not like 'APEX%'
      and rewrite_enabled='Y')
    loop
        dbms_output.put_line(rpad('COUNT_MATVIEWS_REWRITE_ENABLED',l_pad_length)||' '||(c12c.num_objs));
    end loop;

    FOR c12d in (select count(*) num_objs from &CDB_OR_DBA_COL~_policies
      where object_owner not in ('RDSADMIN','SYS','SYSTEM','XDB','X$NULL','SYSMAN','SYSBACKUP','SPATIAL%','SI_INFORMTN_SCHEMA','ORDSYS','ORDDATA','OUTLN','OJVMSYS','OWB%','MDSYS','ORACLE_OCM','OLAPSYS','APEX_040200','APEX_030200','AUDSYS','APPQOSSYS','CTXSYS','DBSNMP','DVSYS','FLOWS_FILES','GSMADMIN_INTERNAL','LBACSYS','ORDPLUGINS','OWBSYS','OWBSYS_AUDIT','WMSYS','APEX_050000','REMOTE_SCHEDULER_AGENT','DVF','DBSFWUSER','SYSDG','SYSKM','XS$NULL','GSMUSER','DIP','ANONYMOUS','GSMCATUSER','MDDATA','APEX_PUBLIC_USER','SYSRAC','SYS$UMF','GGSYS','SPATIAL_CSW_ADMIN_USR') 
      and object_owner not like 'APEX%'
      and enable='YES')
    loop
        dbms_output.put_line(rpad('COUNT_VPD_POLICIES',l_pad_length)||' '||(c12d.num_objs));
    end loop;
  exception
    when others then
      dbms_output.put_line(rpad('ERROR:C12bcd',l_pad_length)||' '||sqlerrm);
  end;      



  begin



    --Now query dba_featue_usage_statistics for certain EE feature usage.  This can help with recommendations about potential use of Standard Edition2
    --
    FOR c13 in (select distinct name from &CDB_OR_DBA_COL~_feature_usage_statistics
      where currently_used ='TRUE'
        and name in ('Active Data Guard','Active Data Guard - Real-Time Query on Physical Standby','Application Express','Data Mining','Data Redaction','Editioning Views','Exadata','Fine Grained Audit','GoldenGate','In-Memory Column Store','Label Security','Oracle In-Database Hadoop','Java Virtual Machine (user)','Oracle Multitenant','Partitioning (user)','One Node','RAC','Real Application Security','Real Application Clusters (RAC)','Real Application Cluster One Node','Resource Manager','Shard Database','Spatial','Transparent Data Encryption','Virtual Private Database (VPD)','Hybrid Columnar Compression','Parallel SQL Query Execution','Online Redefinition','Data Guard')
        and dbid = &DBID
        order by name)
    loop
        dbms_output.put_line(rpad('FEATURE_'||c13.name,l_pad_length)||' '||'Yes');
    end loop;

  exception
    when others then
      dbms_output.put_line(rpad('ERROR:C13',l_pad_length)||' '||sqlerrm);
  end;      



  begin


   --Now add a few other items to help in case the script does not run as expected.
   --
	FOR c5 IN (SELECT regexp_replace(sys_context('USERENV', 'MODULE'),'([[:alnum:]\-]+)\@.*$','\1') module, &CDB_PDB_EXPR con_name, '&_sqlplus_release' sqlplus_version FROM DUAL)
    loop
        dbms_output.put_line(rpad('DEBUG_MODULE',l_pad_length)||' '||c5.module);
        dbms_output.put_line(rpad('DEBUG_CONTAINER',l_pad_length)||' '||c5.con_name);
        dbms_output.put_line(rpad('DEBUG_SQLPLUS',l_pad_length)||' '||c5.sqlplus_version);
    end loop; --c5  
  exception
    when others then
      dbms_output.put_line(rpad('ERROR:C5',l_pad_length)||' '||sqlerrm);
  end;      



  begin
	
    FOR c14 in (select name, value from v$parameter
      where name in ('statistics_level','timed_statistics','control_management_pack_access','MAX_IOPS','MAX_MBPS','awr_pdb_autoflush_enabled', 'nls_comp', 'nls_sort')
        order by name)
    loop
        if c14.name in ('nls_comp','nls_sort') then
          dbms_output.put_line(upper(rpad(c14.name,l_pad_length)) ||' '||c14.value);
        else        
          dbms_output.put_line(rpad('DEBUG_'||c14.name,l_pad_length)||' '||c14.value);
        end if;  
    end loop;
  exception
    when others then
      dbms_output.put_line(rpad('ERROR:C14',l_pad_length)||' '||sqlerrm);
  end;      





    dbms_output.put_line('~~END-OS-INFORMATION~~');
END;
/


prompt
prompt 





-- ############################################################
REM This next section gathers Memory usage information.

REPHEADER PAGE LEFT '~~BEGIN-MEMORY~~'
REPFOOTER PAGE LEFT '~~END-MEMORY~~'

SELECT snap_id,
    instance_number,
    NVL(MAX (DECODE (stat_name, 'SGA', stat_value, NULL)),0) "SGA",
    NVL(MAX (DECODE (stat_name, 'PGA', stat_value, NULL)),0) "PGA",
    NVL(MAX (DECODE (stat_name, 'SGA', stat_value, NULL)),0) + MAX (DECODE (stat_name, 'PGA', stat_value,
    NULL)) "TOTAL"
   FROM
    (SELECT snap_id,
        instance_number,
        ROUND (SUM (bytes) / 1024 / 1024 / 1024, 1) stat_value,
        MAX ('SGA') stat_name
       FROM &diagpackprefix~_sgastat
      WHERE dbid = &DBID
        AND snap_id BETWEEN &SNAP_ID_MIN AND &SNAP_ID_MAX
   GROUP BY snap_id,
        instance_number
  UNION ALL
     SELECT snap_id,
        instance_number,
        ROUND (value / 1024 / 1024 / 1024, 1) stat_value,
        'PGA' stat_name
       FROM &diagpackprefix~_pgastat
      WHERE dbid = &DBID
        AND snap_id BETWEEN &SNAP_ID_MIN AND &SNAP_ID_MAX
        AND NAME = 'total PGA allocated'
    )
GROUP BY snap_id,
    instance_number
ORDER BY snap_id,
    instance_number;

prompt 
prompt 





-- ############################################################
REM This next section gathers database disk space size over time.

-- With CDB, we want to use the con_id field to join tables
-- 11.2.0.4 may or may not have &diagpackprefix~_tablespace.  Best to try to use &diagpackprefix~_datafile with 11.2?

REPHEADER PAGE LEFT '~~BEGIN-SIZE-ON-DISK~~'
REPFOOTER PAGE LEFT '~~END-SIZE-ON-DISK~~'
 WITH ts_info as (
select dbid, &DISK_SIZE_12C ts#, tsname, max(block_size) block_size
from &DISK_SIZE_12C_TABLE
-- was &diagpackprefix~_tablespace
where dbid = &DBID
group by dbid, &DISK_SIZE_12C ts#, tsname),
-- Get the maximum snaphsot id for each day from &diagpackprefix~_snapshot
snap_info as (
select dbid,to_char(trunc(end_interval_time,'DD'),'MM/DD/YY') dd, max(s.snap_id) snap_id
FROM &diagpackprefix~_snapshot s
where s.snap_id between &SNAP_ID_MIN and &SNAP_ID_MAX
and dbid = &DBID
group by dbid,trunc(end_interval_time,'DD'))
-- Sum up the sizes of all the tablespaces for the last snapshot of each day
select s.snap_id, round(sum(tablespace_size*f.block_size)/1024/1024/1024,2) size_gb
from &diagpackprefix~_tbspc_space_usage sp,
ts_info f,
snap_info s
WHERE s.dbid = sp.dbid
AND s.dbid = &DBID
 and s.snap_id between &SNAP_ID_MIN and &SNAP_ID_MAX
and s.snap_id = sp.snap_id
and sp.dbid = f.dbid
AND sp.tablespace_id = f.ts#  &DISK_SIZE_12C_WHERE
GROUP BY  s.snap_id,s.dd, s.dbid
order by  s.snap_id;

prompt 
prompt   





-- ############################################################
REM This next section gathers the Main Metrics used by DBCSI.  This is the most important section.
REM
REM The key dictionary view is dba_hist_sysmetric_summary.
REM The query gathers multiple metrics and in different forms (for instance, it may gather an average for each snapshot interval as well as a peak for each interval).
REM We have largely kept the same metrics from the original AWR Miner script, but DBCSI doesn't currently use all of them.
REM The most important metrics are:
REM
REM CPU Usage Per Sec - this is the CPU metric in DBCSI
REM Physical Read Total Bytes Per Sec (and Writes) - this is the IO Throughput metric in DBCSI
REM Physical Read Total IO Requests Per Sec (and Writes) - this is the IOPS metric in DBCSI


REPHEADER PAGE LEFT '~~BEGIN-MAIN-METRICS~~'
REPFOOTER PAGE LEFT '~~END-MAIN-METRICS~~'

 select snap_id "snap",max(num_interval) "dur_m", max(end_time) "end",inst "inst",
nvl(max(decode(metric_name,'Host CPU Utilization (%)',					average,null)),0) "os_cpu",
nvl(max(decode(metric_name,'Host CPU Utilization (%)',					maxval,null)),0) "os_cpu_max",
nvl(max(decode(metric_name,'Host CPU Utilization (%)',					STANDARD_DEVIATION,null)),0) "os_cpu_sd",
nvl(max(decode(metric_name,'Database Wait Time Ratio',                   round(average,1),null)),0) "db_wait_ratio",
nvl(max(decode(metric_name,'Database CPU Time Ratio',                   round(average,1),null)),0) "db_cpu_ratio",
nvl(max(decode(metric_name,'CPU Usage Per Sec',                   round(average/100,3),null)),0) "cpu_per_s",
nvl(max(decode(metric_name,'CPU Usage Per Sec',   round(maxval/100,3),null)),0) "cpu_per_s_max",
nvl(max(decode(metric_name,'CPU Usage Per Sec',                   round(STANDARD_DEVIATION/100,3),null)),0) "cpu_per_s_sd",
nvl(max(decode(metric_name,'Average Active Sessions',                   average,null)),0) "aas",
nvl(max(decode(metric_name,'Average Active Sessions',                   STANDARD_DEVIATION,null)),0) "aas_sd",
nvl(max(decode(metric_name,'Average Active Sessions',                   maxval,null)),0) "aas_max",
nvl(max(decode(metric_name,'Database Time Per Sec',					average,null)),0) "db_time",
nvl(max(decode(metric_name,'Database Time Per Sec',					STANDARD_DEVIATION,null)),0) "db_time_sd",
nvl(max(decode(metric_name,'SQL Service Response Time',                   average,null)),0) "sql_res_t_cs",
nvl(max(decode(metric_name,'Background Time Per Sec',                   average,null)),0) "bkgd_t_per_s",
nvl(max(decode(metric_name,'Logons Per Sec',                            average,null)),0) "logons_s",
nvl(max(decode(metric_name,'Current Logons Count',                      average,null)),0) "logons_total",
nvl(max(decode(metric_name,'Executions Per Sec',                        average,null)),0) "exec_s",
nvl(max(decode(metric_name,'Hard Parse Count Per Sec',                  average,null)),0) "hard_p_s",
nvl(max(decode(metric_name,'Logical Reads Per Sec',                     average,null)),0) "l_reads_s",
nvl(max(decode(metric_name,'User Commits Per Sec',                      average,null)),0) "commits_s",
nvl(max(decode(metric_name,'Physical Read Total Bytes Per Sec',         round((average)/1024/1024,1),null)),0) "read_mb_s",
nvl(max(decode(metric_name,'Physical Read Total Bytes Per Sec',         round((maxval)/1024/1024,1),null)),0) "read_mb_s_max",
nvl(max(decode(metric_name,'Physical Read Total IO Requests Per Sec',   average,null)),0) "read_iops",
nvl(max(decode(metric_name,'Physical Read Total IO Requests Per Sec',   maxval,null)),0) "read_iops_max",
nvl(max(decode(metric_name,'Physical Reads Per Sec',  			average,null)),0) "read_bks",
nvl(max(decode(metric_name,'Physical Reads Direct Per Sec',  			average,null)),0) "read_bks_direct",
nvl(max(decode(metric_name,'Physical Write Total Bytes Per Sec',        round((average)/1024/1024,1),null)),0) "write_mb_s",
nvl(max(decode(metric_name,'Physical Write Total Bytes Per Sec',        round((maxval)/1024/1024,1),null)),0) "write_mb_s_max",
nvl(max(decode(metric_name,'Physical Write Total IO Requests Per Sec',  average,null)),0) "write_iops",
nvl(max(decode(metric_name,'Physical Write Total IO Requests Per Sec',  maxval,null)),0) "write_iops_max",
nvl(max(decode(metric_name,'Physical Writes Per Sec',  			average,null)),0) "write_bks",
nvl(max(decode(metric_name,'Physical Writes Direct Per Sec',  			average,null)),0) "write_bks_direct",
nvl(max(decode(metric_name,'Physical Read Bytes Per Sec',         round((average)/1024/1024,1),null)),0) "read_nt_mb_s",
nvl(max(decode(metric_name,'Physical Read Bytes Per Sec',         round((maxval)/1024/1024,1),null)),0) "read_nt_mb_s_max",
nvl(max(decode(metric_name,'Physical Read IO Requests Per Sec',   average,null)),0) "read_nt_iops",
nvl(max(decode(metric_name,'Physical Read IO Requests Per Sec',   maxval,null)),0) "read_nt_iops_max",
nvl(max(decode(metric_name,'Physical Write Bytes Per Sec',        round((average)/1024/1024,1),null)),0) "write_nt_mb_s",
nvl(max(decode(metric_name,'Physical Write Bytes Per Sec',        round((maxval)/1024/1024,1),null)),0) "write_nt_mb_s_max",
nvl(max(decode(metric_name,'Physical Write IO Requests Per Sec',  average,null)),0) "write_nt_iops",
nvl(max(decode(metric_name,'Physical Write IO Requests Per Sec',  maxval,null)),0) "write_nt_iops_max",
nvl(max(decode(metric_name,'Redo Generated Per Sec',                    round((average)/1024/1024,1),null)),0) "redo_mb_s",
nvl(max(decode(metric_name,'DB Block Gets Per Sec',                     average,null)),0) "db_block_gets_s",
nvl(max(decode(metric_name,'DB Block Changes Per Sec',                   average,null)),0) "db_block_changes_s",
nvl(max(decode(metric_name,'GC CR Block Received Per Second',            average,null)),0) "gc_cr_rec_s",
nvl(max(decode(metric_name,'GC Current Block Received Per Second',       average,null)),0) "gc_cu_rec_s",
nvl(max(decode(metric_name,'Global Cache Average CR Get Time',           average,null)),0) "gc_cr_get_cs",
nvl(max(decode(metric_name,'Global Cache Average Current Get Time',      average,null)),0) "gc_cu_get_cs",
nvl(max(decode(metric_name,'Global Cache Blocks Corrupted',              average,null)),0) "gc_bk_corrupted",
nvl(max(decode(metric_name,'Global Cache Blocks Lost',                   average,null)),0) "gc_bk_lost",
nvl(max(decode(metric_name,'Active Parallel Sessions',                   average,null)),0) "px_sess",
nvl(max(decode(metric_name,'Active Serial Sessions',                     average,null)),0) "se_sess",
nvl(max(decode(metric_name,'Average Synchronous Single-Block Read Latency', average,null)),0) "s_blk_r_lat",
nvl(max(decode(metric_name,'Host CPU Usage Per Sec',                   round(average/100,3),null)),0) "h_cpu_per_s",
nvl(max(decode(metric_name,'Host CPU Usage Per Sec',                   round(maxval/100,3),null)),0) "h_cpu_per_s_max",
nvl(max(decode(metric_name,'Host CPU Usage Per Sec',                   round(STANDARD_DEVIATION/100,3),null)),0) "h_cpu_per_s_sd",
nvl(max(decode(metric_name,'Cell Physical IO Interconnect Bytes',         round((average)/1024/1024,1),null)),0) "cell_io_int_mb",
nvl(max(decode(metric_name,'Cell Physical IO Interconnect Bytes',         round((maxval)/1024/1024,1),null)),0) "cell_io_int_mb_max",
 --the cell physical IO bytes metrics are for 1 minute, so remember to divide them by 60 if you are expecting bytes per second
max(decode(metric_name,'PDB_IOPS',                     average,null)) "PDB_IOPS",
max(decode(metric_name,'PDB_IOMBPS',                     average,null)) "PDB_IOMBPS",
max(decode(metric_name,'PDB_SGA',                     round(average / 1024 / 1024 / 1024, 1),null)) "PDB_SGA",
max(decode(metric_name,'PDB_PGA',                     round(average / 1024 / 1024 / 1024, 1),null)) "PDB_PGA",
max(decode(metric_name,'PDB_CPU_USAGE_PER_S',                     average,null)) "PDB_CPU_USAGE_PER_S"
  from(
  select  snap_id,num_interval,to_char(end_time,'YY/MM/DD HH24:MI') end_time,instance_number inst,metric_name,round(average,1) average,
  round(maxval,1) maxval,round(standard_deviation,1) standard_deviation
 from &diagpackprefix~&PDB_AWR_SYSMETRIC_SUMM
where dbid = &DBID
 and snap_id between &SNAP_ID_MIN and &SNAP_ID_MAX
 --and snap_id = 920
 --and instance_number = 4
 and metric_name in ('Host CPU Utilization (%)','CPU Usage Per Sec','Host CPU Usage Per Sec','Average Active Sessions','Database Time Per Sec',
 'Executions Per Sec','Hard Parse Count Per Sec','Logical Reads Per Sec','Logons Per Sec',
 'Physical Read Total Bytes Per Sec','Physical Read Total IO Requests Per Sec','Physical Reads Per Sec','Physical Write Total Bytes Per Sec',
 'Redo Generated Per Sec','User Commits Per Sec','Current Logons Count','DB Block Gets Per Sec','DB Block Changes Per Sec',
 'Database Wait Time Ratio','Database CPU Time Ratio','SQL Service Response Time','Background Time Per Sec',
 'Physical Write Total IO Requests Per Sec','Physical Writes Per Sec','Physical Writes Direct Per Sec','Physical Writes Direct Lobs Per Sec',
 'Physical Reads Direct Per Sec','Physical Reads Direct Lobs Per Sec',
 'GC CR Block Received Per Second','GC Current Block Received Per Second','Global Cache Average CR Get Time','Global Cache Average Current Get Time',
 'Global Cache Blocks Corrupted','Global Cache Blocks Lost',
 'Active Parallel Sessions','Active Serial Sessions','Average Synchronous Single-Block Read Latency','Cell Physical IO Interconnect Bytes',
 'Physical Read Bytes Per Sec','Physical Read IO Requests Per Sec','Physical Write Bytes Per Sec','Physical Write IO Requests Per Sec'
    )
 &PDB_IOPS_QUERY     --merge in PDB query against DBA_HIST_RSRC_PDB_METRIC if running in PDB
 )
 group by snap_id, inst
 order by snap_id, inst;
 
-- http://www.oaktable.net/content/oracle-cpu-time
-- https://pavandba.files.wordpress.com/2009/11/owp_awr_historical_analysis.pdf
-- https://kkdba.com/Understand-DB-time.html

prompt 
prompt 






-- ############################################################
REM This next section gathers Average Active Sessions. 
REM It is leftover from the original AWR Miner script, but the data is not currently used by DBCSI.

REPHEADER PAGE LEFT '~~BEGIN-AVERAGE-ACTIVE-SESSIONS~~'
REPFOOTER PAGE LEFT '~~END-AVERAGE-ACTIVE-SESSIONS~~'
column wait_class format a20

 SELECT snap_id,
    wait_class,
    ROUND (SUM (pSec), 2) avg_sess
   FROM
    (SELECT snap_id,
        wait_class,
        p_tmfg / 1000000 / ela pSec
       FROM
        (SELECT (CAST (s.end_interval_time AS DATE) - CAST (s.begin_interval_time AS DATE)) * 24 *
            3600 ela,
            s.snap_id,
            wait_class,
            e.event_name,
            CASE WHEN s.begin_interval_time = s.startup_time
			-- compare to e.time_waited_micro_fg for 10.2?
                THEN e.&T_WAITED_MICRO_COL
                ELSE e.&T_WAITED_MICRO_COL - lag (e.&T_WAITED_MICRO_COL) over (partition BY
                    event_id, e.dbid, e.instance_number, s.startup_time order by e.snap_id)
            END p_tmfg
           FROM &diagpackprefix~_snapshot s,
            &diagpackprefix~&PDB_AWR_PREFIX~_system_event e
          WHERE s.dbid = e.dbid
            AND s.dbid = to_number(&DBID)
            AND e.dbid = to_number(&DBID)
            AND s.instance_number = e.instance_number
            AND s.snap_id = e.snap_id
            AND s.snap_id BETWEEN to_number(&SNAP_ID_MIN) and to_number(&SNAP_ID_MAX)
            AND e.snap_id BETWEEN to_number(&SNAP_ID_MIN) and to_number(&SNAP_ID_MAX)
            AND e.wait_class != 'Idle'
      UNION ALL
         SELECT (CAST (s.end_interval_time AS DATE) - CAST (s.begin_interval_time AS DATE)) * 24 *
            3600 ela,
            s.snap_id,
            t.stat_name wait_class,
            t.stat_name event_name,
            CASE WHEN s.begin_interval_time = s.startup_time
                THEN t.value
                ELSE t.value - lag (value) over (partition BY stat_id, t.dbid, t.instance_number,
                    s.startup_time order by t.snap_id)
            END p_tmfg
           FROM &diagpackprefix~_snapshot s,
            &diagpackprefix~&PDB_AWR_PREFIX~_sys_time_model t
          WHERE s.dbid = t.dbid
            AND s.dbid = to_number(&DBID)
            AND s.instance_number = t.instance_number
            AND s.snap_id = t.snap_id
            AND s.snap_id BETWEEN to_number(&SNAP_ID_MIN) and to_number(&SNAP_ID_MAX)
			AND t.snap_id BETWEEN to_number(&SNAP_ID_MIN) and to_number(&SNAP_ID_MAX)
            AND t.stat_name = 'DB CPU'
        )
		where p_tmfg is not null
    )
    WHERE '&OPTIONAL_SECTIONS'='YES'
GROUP BY snap_id,
    wait_class
ORDER BY snap_id,
    wait_class; 

prompt 
prompt 





-- ############################################################
REM This next section gathers Wait Events.
REM DBCSI uses this information to create the Wait Events chart.

column EVENT_NAME format a60
REPHEADER PAGE LEFT '~~BEGIN-TOP-N-TIMED-EVENTS~~'
REPFOOTER PAGE LEFT '~~END-TOP-N-TIMED-EVENTS~~'

SELECT snap_id,
  wait_class,
  event_name,
  pctdbt,
  total_time_s
FROM
  (SELECT a.snap_id,
    wait_class,
    event_name,
    b.dbt,
    ROUND(SUM(a.ttm) /b.dbt*100,2) pctdbt,
    SUM(a.ttm) total_time_s,
    dense_rank() over (partition BY a.snap_id order by SUM(a.ttm)/b.dbt*100 DESC nulls last) rnk
  FROM
    (SELECT snap_id,
      wait_class,
      event_name,
      ttm
    FROM
      (SELECT
        /*+ qb_name(systemevents) */
        (CAST (s.end_interval_time AS DATE) - CAST (s.begin_interval_time AS DATE)) * 24 * 3600 ela,
        s.snap_id,
        wait_class,
        e.event_name,
        CASE
          WHEN s.begin_interval_time = s.startup_time
          THEN e.time_waited_micro
          ELSE e.time_waited_micro - lag (e.time_waited_micro ) over (partition BY e.instance_number,e.event_name order by e.snap_id)
        END ttm
      FROM &diagpackprefix~_snapshot s,
        &diagpackprefix~&PDB_AWR_PREFIX~_system_event e
      WHERE s.dbid          = e.dbid
      AND s.dbid            = &DBID
      AND s.instance_number = e.instance_number
      AND s.snap_id         = e.snap_id
      AND s.snap_id BETWEEN &SNAP_ID_MIN and &SNAP_ID_MAX
      AND e.wait_class != 'Idle'
      UNION ALL
      SELECT
        /*+ qb_name(dbcpu) */
        (CAST (s.end_interval_time AS DATE) - CAST (s.begin_interval_time AS DATE)) * 24 * 3600 ela,
        s.snap_id,
        t.stat_name wait_class,
        t.stat_name event_name,
        CASE
          WHEN s.begin_interval_time = s.startup_time
          THEN t.value
          ELSE t.value - lag (t.value ) over (partition BY s.instance_number order by s.snap_id)
        END ttm
      FROM &diagpackprefix~_snapshot s,
        &diagpackprefix~&PDB_AWR_PREFIX~_sys_time_model t
      WHERE s.dbid          = t.dbid
      AND s.dbid            = &DBID
      AND s.instance_number = t.instance_number
      AND s.snap_id         = t.snap_id
      AND s.snap_id BETWEEN &SNAP_ID_MIN and &SNAP_ID_MAX
      AND t.stat_name = 'DB CPU'
      )
    ) a,
    (SELECT snap_id,
      SUM(dbt) dbt
    FROM
      (SELECT
        /*+ qb_name(dbtime) */
        s.snap_id,
        t.instance_number,
        t.stat_name nm,
        CASE
          WHEN s.begin_interval_time = s.startup_time
          THEN t.value
          ELSE t.value - lag (t.value ) over (partition BY s.instance_number order by s.snap_id)
        END dbt
      FROM &diagpackprefix~_snapshot s,
        &diagpackprefix~&PDB_AWR_PREFIX~_sys_time_model t
      WHERE s.dbid          = t.dbid
      AND s.dbid            = &DBID
      AND s.instance_number = t.instance_number
      AND s.snap_id         = t.snap_id
      AND s.snap_id BETWEEN &SNAP_ID_MIN and &SNAP_ID_MAX
      AND t.stat_name = 'DB time'
      ORDER BY s.snap_id,
        s.instance_number
      )
    GROUP BY snap_id
    HAVING SUM(dbt) > 0
    ) b
  WHERE a.snap_id = b.snap_id
  GROUP BY a.snap_id,
    a.wait_class,
    a.event_name,
    b.dbt
  )
WHERE pctdbt > 0
AND rnk     <= 5
ORDER BY snap_id,
  pctdbt DESC; 

REPHEADER OFF
REPFOOTER OFF

prompt 
prompt 






-- ############################################################
REM This next section gathers various system metrics that pertain to Exadata.  

REM Unlike the MAIN METRICS section (which is able to gather both average and peak for each snapshot interval), this only gathers averages.
REM This section uses the dba_hist_sysstat view.
REM
REM We use this section to get some metrics that are not available via dba_hist_sysmetric_summary.
REM
REM DBCSI uses this information to create the Exadata charts and to apply post-Exadata sizing logic in the auto-right-sizer.


REPHEADER PAGE LEFT '~~BEGIN-SYSSTAT~~'
REPFOOTER PAGE LEFT '~~END-SYSSTAT~~'
SELECT SNAP_ID,
  MAX(DECODE(event_name,'cell flash cache read hits', event_val_diff,NULL)) "cell_flash_hits",
  MAX(DECODE(event_name,'physical read total IO requests', event_val_diff,NULL)) "read_iops",
  MAX(DECODE(event_name,'physical write total IO requests', event_val_diff,NULL)) "write_iops",
  ROUND(MAX(DECODE(event_name,'physical read total bytes', event_val_diff,NULL))                                 /1024/1024,1) "read_mb",
  ROUND(MAX(DECODE(event_name,'physical read total bytes optimized', event_val_diff,NULL))                       /1024/1024,1) "read_mb_opt",
  MAX(DECODE(event_name,'physical read IO requests', event_val_diff,NULL)) "read_nt_iops",
  MAX(DECODE(event_name,'physical write IO requests', event_val_diff,NULL)) "write_nt_iops",
  ROUND(MAX(DECODE(event_name,'physical read bytes', event_val_diff,NULL))                                 /1024/1024,1) "read_nt_mb",
  ROUND(MAX(DECODE(event_name,'physical write bytes', event_val_diff,NULL))                       /1024/1024,1) "write_nt_mb",
  ROUND(MAX(DECODE(event_name,'cell physical IO interconnect bytes', event_val_diff,NULL))                       /1024/1024,1) "cell_int_mb",
  ROUND(MAX(DECODE(event_name,'cell physical IO interconnect bytes returned by smart scan', event_val_diff,NULL))/1024/1024,1) "cell_int_ss_mb",
  ROUND(MAX(DECODE(event_name,'cell physical IO bytes saved by storage index', event_val_diff,NULL))/1024/1024,1) "cell_si_save_mb",
  ROUND(MAX(DECODE(event_name,'cell physical IO bytes eligible for predicate offload', event_val_diff,NULL))/1024/1024,1) "cell_bytes_elig_mb",
  ROUND(MAX(DECODE(event_name,'HCC scan cell bytes decompressed', event_val_diff,NULL))/1024/1024,1) "cell_hcc_bytes_mb",
  ROUND(MAX(DECODE(event_name,'physical read total multi block requests', event_val_diff,NULL)) ,1) "read_multi_iops",
  ROUND(MAX(DECODE(event_name,'physical reads direct temporary tablespace', event_val_diff,NULL)) ,1) "read_temp_iops",
  ROUND(MAX(DECODE(event_name,'physical writes direct temporary tablespace', event_val_diff,NULL)) ,1) "write_temp_iops"
FROM
  (SELECT snap_id,
    event_name,
    ROUND(SUM(val_per_s),1) event_val_diff
  FROM
    (SELECT snap_id,
      instance_number,
      event_name,
      event_val_diff,
      (event_val_diff/ela) val_per_s
    FROM
      (SELECT (CAST (s.end_interval_time AS DATE) - CAST (s.begin_interval_time AS DATE)) * 24 * 3600 ela,
        s.snap_id,
        s.instance_number,
        t.stat_name wait_class,
        t.stat_name event_name,
        CASE
          WHEN s.begin_interval_time = s.startup_time
          THEN t.value
          ELSE t.value - lag (value) over (partition BY stat_id, t.dbid, t.instance_number, s.startup_time order by t.snap_id)
        END event_val_diff
      FROM &diagpackprefix~_snapshot s,
        &diagpackprefix~&PDB_AWR_PREFIX~_sysstat t
      WHERE s.dbid = t.dbid
      AND s.dbid   = &DBID
      AND s.instance_number = t.instance_number
      AND s.snap_id         = t.snap_id
      AND s.snap_id BETWEEN &SNAP_ID_MIN AND &SNAP_ID_MAX
      AND t.snap_id BETWEEN &SNAP_ID_MIN AND &SNAP_ID_MAX
      AND t.stat_name IN ('cell flash cache read hits','physical read total IO requests', 'physical write total IO requests', 'cell physical IO bytes saved by storage index',
      'cell physical IO interconnect bytes','cell physical IO interconnect bytes returned by smart scan', 
      'physical read total bytes','physical read total bytes optimized' , 'cell physical IO bytes eligible for predicate offload','HCC scan cell bytes decompressed',
      'physical read bytes','physical write bytes','physical read IO requests','physical write IO requests',
      'physical reads direct temporary tablespace', 'physical writes direct temporary tablespace', 'physical read total multi block requests')
      )
    WHERE event_val_diff IS NOT NULL
    )
  GROUP BY snap_id,
    event_name
  )
GROUP BY snap_id
ORDER BY SNAP_ID ASC;

prompt 
prompt 







-- ############################################################
REM This next section gathers feature usage details.  This information is used by DBCSI to make Standard Edition2 recommendations.  

REPHEADER PAGE LEFT '~~BEGIN-FEATURES~~'
REPFOOTER PAGE LEFT '~~END-FEATURES~~'
col feature_info format a600 tru
col name format a64
select name,detected_usages, total_samples, currently_used,aux_count, to_char(LAST_SAMPLE_DATE,'DD-MON-YYYY') last_sample_date,
replace(substr(feature_info,1,600),'
',' ') feature_info from dba_feature_usage_statistics
where currently_used='TRUE'
  and dbid = &DBID
order by name;

prompt 
prompt 




-- ############################################################
REM This next section gathers IO by function data
REM This data is not currently used by the DBCSI UI

REPHEADER PAGE LEFT '~~BEGIN-IOSTAT-FUNCTION~~'
REPFOOTER PAGE LEFT '~~END-IOSTAT-FUNCTION~~'
col function_name format a20
SELECT SNAP_ID,
  function_name,
  MAX(megabytes_val_per_s) "megabytes_val_per_s"
  -- MAX(reqs_val_per_s) "reqs_val_per_s"
FROM
  (SELECT snap_id, function_name,
    ROUND(SUM(megabytes_val_per_s),1) megabytes_val_per_s,
    ROUND(SUM(reqs_val_per_s),1) reqs_val_per_s
  FROM
    (SELECT snap_id,
      instance_number,
      function_name,
      megabytes_val_diff,
      (megabytes_val_diff/ela) megabytes_val_per_s,
      reqs_val_diff,
      (reqs_val_diff/ela) reqs_val_per_s
    FROM
      (SELECT (CAST (s.end_interval_time AS DATE) - CAST (s.begin_interval_time AS DATE)) * 24 * 3600 ela,
        s.snap_id,
        s.instance_number,
        t.function_name,
        CASE
          WHEN s.begin_interval_time = s.startup_time
          THEN t.megabytes
          ELSE t.megabytes - lag (megabytes) over (partition BY function_name, t.dbid, t.instance_number, s.startup_time order by t.snap_id)
        END megabytes_val_diff,
        CASE
          WHEN s.begin_interval_time = s.startup_time
          THEN t.reqs
          ELSE t.reqs - lag (reqs) over (partition BY function_name, t.dbid, t.instance_number, s.startup_time order by t.snap_id)
        END reqs_val_diff
      FROM &diagpackprefix~_snapshot s,
        ( select snap_id, instance_number, dbid, function_name,
                 (SMALL_READ_MEGABYTES + SMALL_WRITE_MEGABYTES + LARGE_READ_MEGABYTES + LARGE_WRITE_MEGABYTES) MEGABYTES,
                 (SMALL_READ_REQS + SMALL_WRITE_REQS + LARGE_READ_REQS + LARGE_WRITE_REQS) REQS
            from &diagpackprefix~_iostat_function) t
      WHERE s.dbid = t.dbid
      AND s.dbid   = &DBID
      AND s.instance_number = t.instance_number
      AND s.snap_id         = t.snap_id
      AND s.snap_id BETWEEN &SNAP_ID_MIN AND &SNAP_ID_MAX
      AND t.snap_id BETWEEN &SNAP_ID_MIN AND &SNAP_ID_MAX
       )
    WHERE megabytes_val_diff > 0.1
    )
  GROUP BY snap_id, function_name
  )
  WHERE megabytes_val_per_s>=0.1
GROUP BY snap_id, function_name
ORDER BY SNAP_ID ASC;





-- ############################################################
REM This next section gathers CPU usage information reported by percentiles. 
REM If you use the DBCSI web app, it will calculate/display percentiles on the charts for you without needing this data.
REM This section exists as a way to quickly look at the CPU percentiles even without loading the output file into DBCSI.
REM
REM This query is courtesy of Yves Colin and Bertrand Drouvot, and has been included as-is.


REPHEADER PAGE LEFT '~~BEGIN-PERCENT-CPU~~'
REPFOOTER PAGE LEFT '~~END-PERCENT-CPU~~'
column METRIC format a20
WITH 
cpu_per_inst_and_sample AS (
SELECT /*+ 
       FULL(h.INT$&diagpackprefix~_ACT_SESS_HISTORY.sn) 
       FULL(h.INT$&diagpackprefix~_ACT_SESS_HISTORY.ash) 
       FULL(h.INT$&diagpackprefix~_ACT_SESS_HISTORY.evt) 
       USE_HASH(h.INT$&diagpackprefix~_ACT_SESS_HISTORY.sn h.INT$&diagpackprefix~_ACT_SESS_HISTORY.ash h.INT$&diagpackprefix~_ACT_SESS_HISTORY.evt)
       FULL(h.sn) 
       FULL(h.ash) 
       FULL(h.evt) 
       USE_HASH(h.sn h.ash h.evt)
       */
       h.snap_id,
       h.dbid,
       h.instance_number,
       h.sample_id,
       COUNT(*) aas_on_cpu_and_resmgr,
       SUM(CASE h.session_state WHEN 'ON CPU' THEN 1 ELSE 0 END) aas_on_cpu,
       SUM(CASE h.event WHEN 'resmgr:cpu quantum' THEN 1 ELSE 0 END) aas_resmgr_cpu_quantum,
       MIN(s.begin_interval_time) begin_interval_time,
       MAX(s.end_interval_time) end_interval_time      
  FROM &diagpackprefix~_active_sess_history h,
       &diagpackprefix~_snapshot s
 WHERE (h.session_state = 'ON CPU' OR h.event = 'resmgr:cpu quantum')
   AND s.snap_id = h.snap_id
   AND s.dbid = h.dbid
   AND s.dbid = &DBID
   AND s.instance_number = h.instance_number
   AND s.snap_id BETWEEN &SNAP_ID_MIN AND &SNAP_ID_MAX
   AND '&OPTIONAL_SECTIONS'='YES'
 GROUP BY
       h.snap_id,
       h.dbid,
       h.instance_number,
       h.sample_id
),
cpu_per_db_and_inst AS (
SELECT dbid,
       instance_number,
       MIN(begin_interval_time)                                               begin_interval_time,
       MAX(end_interval_time)                                                 end_interval_time,
       COUNT(DISTINCT snap_id)                                                snap_shots,        
       MAX(aas_on_cpu_and_resmgr)                                             aas_on_cpu_and_resmgr_max,
       MAX(aas_on_cpu)                                                        aas_on_cpu_max,
       MAX(aas_resmgr_cpu_quantum)                                            aas_resmgr_cpu_quantum_max,
       PERCENTILE_DISC(0.9999) WITHIN GROUP (ORDER BY aas_on_cpu_and_resmgr)  aas_on_cpu_and_resmgr_9999,
       PERCENTILE_DISC(0.9999) WITHIN GROUP (ORDER BY aas_on_cpu)             aas_on_cpu_9999,
       PERCENTILE_DISC(0.9999) WITHIN GROUP (ORDER BY aas_resmgr_cpu_quantum) aas_resmgr_cpu_quantum_9999,
       PERCENTILE_DISC(0.9990) WITHIN GROUP (ORDER BY aas_on_cpu_and_resmgr)  aas_on_cpu_and_resmgr_999,
       PERCENTILE_DISC(0.9990) WITHIN GROUP (ORDER BY aas_on_cpu)             aas_on_cpu_999,
       PERCENTILE_DISC(0.9990) WITHIN GROUP (ORDER BY aas_resmgr_cpu_quantum) aas_resmgr_cpu_quantum_999,
       PERCENTILE_DISC(0.9900) WITHIN GROUP (ORDER BY aas_on_cpu_and_resmgr)  aas_on_cpu_and_resmgr_99,
       PERCENTILE_DISC(0.9900) WITHIN GROUP (ORDER BY aas_on_cpu)             aas_on_cpu_99,
       PERCENTILE_DISC(0.9900) WITHIN GROUP (ORDER BY aas_resmgr_cpu_quantum) aas_resmgr_cpu_quantum_99,
       PERCENTILE_DISC(0.9700) WITHIN GROUP (ORDER BY aas_on_cpu_and_resmgr)  aas_on_cpu_and_resmgr_97,
       PERCENTILE_DISC(0.9700) WITHIN GROUP (ORDER BY aas_on_cpu)             aas_on_cpu_97,
       PERCENTILE_DISC(0.9700) WITHIN GROUP (ORDER BY aas_resmgr_cpu_quantum) aas_resmgr_cpu_quantum_97,
       PERCENTILE_DISC(0.9500) WITHIN GROUP (ORDER BY aas_on_cpu_and_resmgr)  aas_on_cpu_and_resmgr_95,
       PERCENTILE_DISC(0.9500) WITHIN GROUP (ORDER BY aas_on_cpu)             aas_on_cpu_95,
       PERCENTILE_DISC(0.9500) WITHIN GROUP (ORDER BY aas_resmgr_cpu_quantum) aas_resmgr_cpu_quantum_95,
       PERCENTILE_DISC(0.9000) WITHIN GROUP (ORDER BY aas_on_cpu_and_resmgr)  aas_on_cpu_and_resmgr_90,
       PERCENTILE_DISC(0.9000) WITHIN GROUP (ORDER BY aas_on_cpu)             aas_on_cpu_90,
       PERCENTILE_DISC(0.9000) WITHIN GROUP (ORDER BY aas_resmgr_cpu_quantum) aas_resmgr_cpu_quantum_90,
       PERCENTILE_DISC(0.7500) WITHIN GROUP (ORDER BY aas_on_cpu_and_resmgr)  aas_on_cpu_and_resmgr_75,
       PERCENTILE_DISC(0.7500) WITHIN GROUP (ORDER BY aas_on_cpu)             aas_on_cpu_75,
       PERCENTILE_DISC(0.7500) WITHIN GROUP (ORDER BY aas_resmgr_cpu_quantum) aas_resmgr_cpu_quantum_75,
       MEDIAN(aas_on_cpu_and_resmgr)                                          aas_on_cpu_and_resmgr_med,
       MEDIAN(aas_on_cpu)                                                     aas_on_cpu_med,
       MEDIAN(aas_resmgr_cpu_quantum)                                         aas_resmgr_cpu_quantum_med,
       ROUND(AVG(aas_on_cpu_and_resmgr), 1)                                   aas_on_cpu_and_resmgr_avg,
       ROUND(AVG(aas_on_cpu), 1)                                              aas_on_cpu_avg,
       ROUND(AVG(aas_resmgr_cpu_quantum), 1)                                  aas_resmgr_cpu_quantum_avg
  FROM cpu_per_inst_and_sample
 GROUP BY
       dbid,
       instance_number
),
cpu_per_inst_and_perc AS (
SELECT dbid, 01 order_by, 'Maximum_or_peak' metric, instance_number, aas_on_cpu_max  on_cpu, aas_on_cpu_and_resmgr_max  on_cpu_and_resmgr, aas_resmgr_cpu_quantum_max  resmgr_cpu_quantum, begin_interval_time, end_interval_time, snap_shots FROM cpu_per_db_and_inst
UNION ALL
SELECT dbid, 02 order_by, '99.99th_percntl' metric, instance_number, aas_on_cpu_9999 on_cpu, aas_on_cpu_and_resmgr_9999 on_cpu_and_resmgr, aas_resmgr_cpu_quantum_9999 resmgr_cpu_quantum, begin_interval_time, end_interval_time, snap_shots FROM cpu_per_db_and_inst
UNION ALL
SELECT dbid, 03 order_by, '99.9th_percentl' metric, instance_number, aas_on_cpu_999  on_cpu, aas_on_cpu_and_resmgr_999  on_cpu_and_resmgr, aas_resmgr_cpu_quantum_999  resmgr_cpu_quantum, begin_interval_time, end_interval_time, snap_shots FROM cpu_per_db_and_inst
UNION ALL
SELECT dbid, 04 order_by, '99th_percentile' metric, instance_number, aas_on_cpu_99   on_cpu, aas_on_cpu_and_resmgr_99   on_cpu_and_resmgr, aas_resmgr_cpu_quantum_99   resmgr_cpu_quantum, begin_interval_time, end_interval_time, snap_shots FROM cpu_per_db_and_inst
UNION ALL
SELECT dbid, 05 order_by, '97th_percentile' metric, instance_number, aas_on_cpu_97   on_cpu, aas_on_cpu_and_resmgr_97   on_cpu_and_resmgr, aas_resmgr_cpu_quantum_97   resmgr_cpu_quantum, begin_interval_time, end_interval_time, snap_shots FROM cpu_per_db_and_inst
UNION ALL
SELECT dbid, 06 order_by, '95th_percentile' metric, instance_number, aas_on_cpu_95   on_cpu, aas_on_cpu_and_resmgr_95   on_cpu_and_resmgr, aas_resmgr_cpu_quantum_95   resmgr_cpu_quantum, begin_interval_time, end_interval_time, snap_shots FROM cpu_per_db_and_inst
UNION ALL
SELECT dbid, 07 order_by, '90th_percentile' metric, instance_number, aas_on_cpu_90   on_cpu, aas_on_cpu_and_resmgr_90   on_cpu_and_resmgr, aas_resmgr_cpu_quantum_90   resmgr_cpu_quantum, begin_interval_time, end_interval_time, snap_shots FROM cpu_per_db_and_inst
UNION ALL
SELECT dbid, 08 order_by, '75th_percentile' metric, instance_number, aas_on_cpu_75   on_cpu, aas_on_cpu_and_resmgr_75   on_cpu_and_resmgr, aas_resmgr_cpu_quantum_75   resmgr_cpu_quantum, begin_interval_time, end_interval_time, snap_shots FROM cpu_per_db_and_inst
UNION ALL
SELECT dbid, 09 order_by, 'Median'          metric, instance_number, aas_on_cpu_med  on_cpu, aas_on_cpu_and_resmgr_med  on_cpu_and_resmgr, aas_resmgr_cpu_quantum_med  resmgr_cpu_quantum, begin_interval_time, end_interval_time, snap_shots FROM cpu_per_db_and_inst
UNION ALL
SELECT dbid, 10 order_by, 'Average'         metric, instance_number, aas_on_cpu_avg  on_cpu, aas_on_cpu_and_resmgr_avg  on_cpu_and_resmgr, aas_resmgr_cpu_quantum_avg  resmgr_cpu_quantum, begin_interval_time, end_interval_time, snap_shots FROM cpu_per_db_and_inst
),
cpu_per_db_and_perc AS (
SELECT dbid,
       order_by,
       metric,
       TO_NUMBER(NULL) instance_number,
       SUM(on_cpu) on_cpu,
       SUM(on_cpu_and_resmgr) on_cpu_and_resmgr,
       SUM(resmgr_cpu_quantum) resmgr_cpu_quantum,
       MIN(begin_interval_time) begin_interval_time,
       MAX(end_interval_time) end_interval_time,
       SUM(snap_shots) snap_shots
  FROM cpu_per_inst_and_perc
 GROUP BY
       dbid,
       order_by,
       metric
)
SELECT dbid,
       order_by,
       metric,
       instance_number,
       on_cpu,
       on_cpu_and_resmgr,
       resmgr_cpu_quantum,
       TO_CHAR(CAST(begin_interval_time AS DATE), 'YYYY-MM-DD HH24:MI') begin_interval_time,
       TO_CHAR(CAST(end_interval_time AS DATE), 'YYYY-MM-DD HH24:MI') end_interval_time,
       snap_shots,
       ROUND(CAST(end_interval_time AS DATE) - CAST(begin_interval_time AS DATE), 1) days,
       ROUND(snap_shots / (CAST(end_interval_time AS DATE) - CAST(begin_interval_time AS DATE)), 1) avg_snaps_per_day
  FROM cpu_per_inst_and_perc
 UNION ALL
SELECT dbid,
       order_by,
       metric,
       instance_number,
       on_cpu,
       on_cpu_and_resmgr,
       resmgr_cpu_quantum,
       TO_CHAR(CAST(begin_interval_time AS DATE), 'YYYY-MM-DD HH24:MI') begin_interval_time,
       TO_CHAR(CAST(end_interval_time AS DATE), 'YYYY-MM-DD HH24:MI') end_interval_time,
       snap_shots,
       ROUND(CAST(end_interval_time AS DATE) - CAST(begin_interval_time AS DATE), 1) days,
       ROUND(snap_shots / (CAST(end_interval_time AS DATE) - CAST(begin_interval_time AS DATE)), 1) avg_snaps_per_day
  FROM cpu_per_db_and_perc
 ORDER BY
       dbid,
       order_by,
       instance_number NULLS LAST
/

prompt 
prompt 









-- ############################################################
REM This next section gathers IO information reported by percentiles. 
REM If you use the DBCSI web app, it will calculate/display percentiles on the charts for you without needing this data.
REM This section exists as a way to quickly look at the IO percentiles even without loading the output file into DBCSI.
REM
REM This query is courtesy of Yves Colin and Bertrand Drouvot, and has been included as-is.

REPHEADER PAGE LEFT '~~BEGIN-PERCENT-IO~~'
REPFOOTER PAGE LEFT '~~END-PERCENT-IO~~'
WITH
sysstat_io AS (
SELECT /*+ 
       MATERIALIZE 
       NO_MERGE 
       FULL(h.INT$&diagpackprefix~_SYSSTAT.sn) 
       FULL(h.INT$&diagpackprefix~_SYSSTAT.s) 
       FULL(h.INT$&diagpackprefix~_SYSSTAT.nm) 
       USE_HASH(h.INT$&diagpackprefix~_SYSSTAT.sn h.INT$&diagpackprefix~_SYSSTAT.s h.INT$&diagpackprefix~_SYSSTAT.nm)
       FULL(h.sn) 
       FULL(h.s) 
       FULL(h.nm) 
       USE_HASH(h.sn h.s h.nm)
       FULL(s.INT$&diagpackprefix~_SNAPSHOT.WRM$_SNAPSHOT)
       FULL(s.WRM$_SNAPSHOT)
       USE_HASH(h s)
       LEADING(h.INT$&diagpackprefix~_SYSSTAT.nm h.INT$&diagpackprefix~_SYSSTAT.s h.INT$&diagpackprefix~_SYSSTAT.sn s.INT$&diagpackprefix~_SNAPSHOT.WRM$_SNAPSHOT)
       LEADING(h.nm h.s h.sn s.WRM$_SNAPSHOT)
       */
       h.snap_id,
       h.dbid,
       h.instance_number,
       SUM(CASE WHEN h.stat_name = 'physical read total IO requests' THEN value ELSE 0 END) r_reqs,
       SUM(CASE WHEN h.stat_name IN ('physical write total IO requests', 'redo writes') THEN value ELSE 0 END) w_reqs,
       SUM(CASE WHEN h.stat_name = 'physical read total bytes' THEN value ELSE 0 END) r_bytes,
       SUM(CASE WHEN h.stat_name IN ('physical write total bytes', 'redo size') THEN value ELSE 0 END) w_bytes
  FROM &diagpackprefix~&PDB_AWR_PREFIX~_sysstat h,
       &diagpackprefix~_snapshot s
 WHERE h.stat_name IN ('physical read total IO requests', 'physical write total IO requests', 'redo writes', 'physical read total bytes', 'physical write total bytes', 'redo size')
   AND s.snap_id(+) = h.snap_id
   AND s.dbid(+) = h.dbid
   AND s.instance_number(+) = h.instance_number
   AND s.dbid(+) = &DBID
   AND s.snap_id(+) BETWEEN &SNAP_ID_MIN AND &SNAP_ID_MAX
   AND '&OPTIONAL_SECTIONS'='YES'
 GROUP BY
       h.snap_id,
       h.dbid,
       h.instance_number
),
io_per_inst_and_snap_id AS (
SELECT /*+ 
       MATERIALIZE 
       NO_MERGE 
       FULL(s0.INT$&diagpackprefix~_SNAPSHOT.WRM$_SNAPSHOT)
       FULL(s0.WRM$_SNAPSHOT)
       FULL(s1.INT$&diagpackprefix~_SNAPSHOT.WRM$_SNAPSHOT)
       FULL(s1.WRM$_SNAPSHOT)
       USE_HASH(h0 s0 h1 s1)
       */
       h1.dbid,
       h1.instance_number,
       h1.snap_id,
       (h1.r_reqs - h0.r_reqs) r_reqs,
       (h1.w_reqs - h0.w_reqs) w_reqs,
       (h1.r_bytes - h0.r_bytes) r_bytes,
       (h1.w_bytes - h0.w_bytes) w_bytes,
       (CAST(s1.end_interval_time AS DATE) - CAST(s1.begin_interval_time AS DATE)) * 86400 elapsed_sec,
       CAST(s1.begin_interval_time AS DATE) begin_interval_time,
       CAST(s1.end_interval_time AS DATE) end_interval_time        
  FROM sysstat_io h0,
       &diagpackprefix~_snapshot s0,
       sysstat_io h1,
       &diagpackprefix~_snapshot s1
 WHERE s0.snap_id = h0.snap_id
   AND s0.dbid = h0.dbid
   AND s0.instance_number = h0.instance_number
   AND h1.snap_id = h0.snap_id + 1
   AND h1.dbid = h0.dbid
   AND h1.instance_number = h0.instance_number
   AND s1.snap_id = h1.snap_id
   AND s1.dbid = h1.dbid
   AND s1.instance_number = h1.instance_number
   AND s1.snap_id = s0.snap_id + 1
   AND s1.dbid = s0.dbid
   AND s1.instance_number = s0.instance_number
   AND s1.startup_time = s0.startup_time
   AND s0.dbid = &DBID
   AND s0.snap_id BETWEEN &SNAP_ID_MIN AND &SNAP_ID_MAX
   AND s1.dbid = &DBID
   AND s1.snap_id BETWEEN &SNAP_ID_MIN AND &SNAP_ID_MAX
   AND '&OPTIONAL_SECTIONS'='YES'
),
io_per_snap_id AS (
SELECT /*+ 
       MATERIALIZE 
       NO_MERGE 
       */
       dbid,
       snap_id,
       SUM(r_reqs) r_reqs,
       SUM(w_reqs) w_reqs,
       SUM(r_bytes) r_bytes,
       SUM(w_bytes) w_bytes,
       AVG(elapsed_sec) elapsed_sec,
       MIN(begin_interval_time) begin_interval_time,
       MAX(end_interval_time) end_interval_time
  FROM io_per_inst_and_snap_id
 GROUP BY
       dbid,
       snap_id
),
io_per_inst AS (
SELECT /*+ 
       MATERIALIZE 
       NO_MERGE 
       */
       dbid,
       instance_number,
       MIN(begin_interval_time) begin_interval_time,
       MAX(end_interval_time) end_interval_time,
       COUNT(DISTINCT snap_id) snap_shots,        
       ROUND(100 * SUM(r_reqs) / (SUM(r_reqs) + SUM(w_reqs)), 1) r_reqs_perc,
       ROUND(100 * SUM(w_reqs) / (SUM(r_reqs) + SUM(w_reqs)), 1) w_reqs_perc,
       ROUND(MAX((r_reqs + w_reqs) / elapsed_sec)) rw_iops_peak,
       ROUND(MAX(r_reqs / elapsed_sec)) r_iops_peak,
       ROUND(MAX(w_reqs / elapsed_sec)) w_iops_peak,
       ROUND(PERCENTILE_DISC(0.999) WITHIN GROUP (ORDER BY (r_reqs + w_reqs) / elapsed_sec)) rw_iops_999,
       ROUND(PERCENTILE_DISC(0.999) WITHIN GROUP (ORDER BY r_reqs / elapsed_sec)) r_iops_999,
       ROUND(PERCENTILE_DISC(0.999) WITHIN GROUP (ORDER BY w_reqs / elapsed_sec)) w_iops_999,
       ROUND(PERCENTILE_DISC(0.99) WITHIN GROUP (ORDER BY (r_reqs + w_reqs) / elapsed_sec)) rw_iops_99,
       ROUND(PERCENTILE_DISC(0.99) WITHIN GROUP (ORDER BY r_reqs / elapsed_sec)) r_iops_99,
       ROUND(PERCENTILE_DISC(0.99) WITHIN GROUP (ORDER BY w_reqs / elapsed_sec)) w_iops_99,
       ROUND(PERCENTILE_DISC(0.97) WITHIN GROUP (ORDER BY (r_reqs + w_reqs) / elapsed_sec)) rw_iops_97,
       ROUND(PERCENTILE_DISC(0.97) WITHIN GROUP (ORDER BY r_reqs / elapsed_sec)) r_iops_97,
       ROUND(PERCENTILE_DISC(0.97) WITHIN GROUP (ORDER BY w_reqs / elapsed_sec)) w_iops_97,
       ROUND(PERCENTILE_DISC(0.95) WITHIN GROUP (ORDER BY (r_reqs + w_reqs) / elapsed_sec)) rw_iops_95,
       ROUND(PERCENTILE_DISC(0.95) WITHIN GROUP (ORDER BY r_reqs / elapsed_sec)) r_iops_95,
       ROUND(PERCENTILE_DISC(0.95) WITHIN GROUP (ORDER BY w_reqs / elapsed_sec)) w_iops_95,
       ROUND(PERCENTILE_DISC(0.90) WITHIN GROUP (ORDER BY (r_reqs + w_reqs) / elapsed_sec)) rw_iops_90,
       ROUND(PERCENTILE_DISC(0.90) WITHIN GROUP (ORDER BY r_reqs / elapsed_sec)) r_iops_90,
       ROUND(PERCENTILE_DISC(0.90) WITHIN GROUP (ORDER BY w_reqs / elapsed_sec)) w_iops_90,
       ROUND(PERCENTILE_DISC(0.75) WITHIN GROUP (ORDER BY (r_reqs + w_reqs) / elapsed_sec)) rw_iops_75,
       ROUND(PERCENTILE_DISC(0.75) WITHIN GROUP (ORDER BY r_reqs / elapsed_sec)) r_iops_75,
       ROUND(PERCENTILE_DISC(0.75) WITHIN GROUP (ORDER BY w_reqs / elapsed_sec)) w_iops_75,
       ROUND(MEDIAN((r_reqs + w_reqs) / elapsed_sec)) rw_iops_med,
       ROUND(MEDIAN(r_reqs / elapsed_sec)) r_iops_med,
       ROUND(MEDIAN(w_reqs / elapsed_sec)) w_iops_med,
       ROUND(AVG((r_reqs + w_reqs) / elapsed_sec)) rw_iops_avg,
       ROUND(AVG(r_reqs / elapsed_sec)) r_iops_avg,
       ROUND(AVG(w_reqs / elapsed_sec)) w_iops_avg,
       ROUND(100 * SUM(r_bytes) / (SUM(r_bytes) + SUM(w_bytes)), 1) r_bytes_perc,
       ROUND(100 * SUM(w_bytes) / (SUM(r_bytes) + SUM(w_bytes)), 1) w_bytes_perc,
       ROUND(MAX((r_bytes + w_bytes) / POWER(10,6) / elapsed_sec)) rw_mbps_peak,
       ROUND(MAX(r_bytes / POWER(10,6) / elapsed_sec)) r_mbps_peak,
       ROUND(MAX(w_bytes / POWER(10,6) / elapsed_sec)) w_mbps_peak,
       ROUND(PERCENTILE_DISC(0.999) WITHIN GROUP (ORDER BY (r_bytes + w_bytes) / POWER(10,6) / elapsed_sec)) rw_mbps_999,
       ROUND(PERCENTILE_DISC(0.999) WITHIN GROUP (ORDER BY r_bytes / POWER(10,6) / elapsed_sec)) r_mbps_999,
       ROUND(PERCENTILE_DISC(0.999) WITHIN GROUP (ORDER BY w_bytes / POWER(10,6) / elapsed_sec)) w_mbps_999,
       ROUND(PERCENTILE_DISC(0.99) WITHIN GROUP (ORDER BY (r_bytes + w_bytes) / POWER(10,6) / elapsed_sec)) rw_mbps_99,
       ROUND(PERCENTILE_DISC(0.99) WITHIN GROUP (ORDER BY r_bytes / POWER(10,6) / elapsed_sec)) r_mbps_99,
       ROUND(PERCENTILE_DISC(0.99) WITHIN GROUP (ORDER BY w_bytes / POWER(10,6) / elapsed_sec)) w_mbps_99,
       ROUND(PERCENTILE_DISC(0.97) WITHIN GROUP (ORDER BY (r_bytes + w_bytes) / POWER(10,6) / elapsed_sec)) rw_mbps_97,
       ROUND(PERCENTILE_DISC(0.97) WITHIN GROUP (ORDER BY r_bytes / POWER(10,6) / elapsed_sec)) r_mbps_97,
       ROUND(PERCENTILE_DISC(0.97) WITHIN GROUP (ORDER BY w_bytes / POWER(10,6) / elapsed_sec)) w_mbps_97,
       ROUND(PERCENTILE_DISC(0.95) WITHIN GROUP (ORDER BY (r_bytes + w_bytes) / POWER(10,6) / elapsed_sec)) rw_mbps_95,
       ROUND(PERCENTILE_DISC(0.95) WITHIN GROUP (ORDER BY r_bytes / POWER(10,6) / elapsed_sec)) r_mbps_95,
       ROUND(PERCENTILE_DISC(0.95) WITHIN GROUP (ORDER BY w_bytes / POWER(10,6) / elapsed_sec)) w_mbps_95,
       ROUND(PERCENTILE_DISC(0.90) WITHIN GROUP (ORDER BY (r_bytes + w_bytes) / POWER(10,6) / elapsed_sec)) rw_mbps_90,
       ROUND(PERCENTILE_DISC(0.90) WITHIN GROUP (ORDER BY r_bytes / POWER(10,6) / elapsed_sec)) r_mbps_90,
       ROUND(PERCENTILE_DISC(0.90) WITHIN GROUP (ORDER BY w_bytes / POWER(10,6) / elapsed_sec)) w_mbps_90,
       ROUND(PERCENTILE_DISC(0.75) WITHIN GROUP (ORDER BY (r_bytes + w_bytes) / POWER(10,6) / elapsed_sec)) rw_mbps_75,
       ROUND(PERCENTILE_DISC(0.75) WITHIN GROUP (ORDER BY r_bytes / POWER(10,6) / elapsed_sec)) r_mbps_75,
       ROUND(PERCENTILE_DISC(0.75) WITHIN GROUP (ORDER BY w_bytes / POWER(10,6) / elapsed_sec)) w_mbps_75,
       ROUND(MEDIAN((r_bytes + w_bytes) / POWER(10,6) / elapsed_sec)) rw_mbps_med,
       ROUND(MEDIAN(r_bytes / POWER(10,6) / elapsed_sec)) r_mbps_med,
       ROUND(MEDIAN(w_bytes / POWER(10,6) / elapsed_sec)) w_mbps_med,
       ROUND(AVG((r_bytes + w_bytes) / POWER(10,6) / elapsed_sec)) rw_mbps_avg,
       ROUND(AVG(r_bytes / POWER(10,6) / elapsed_sec)) r_mbps_avg,
       ROUND(AVG(w_bytes / POWER(10,6) / elapsed_sec)) w_mbps_avg
  FROM io_per_inst_and_snap_id
 WHERE elapsed_sec > 60 -- ignore snaps too close
 GROUP BY
       dbid,
       instance_number
),
io_per_cluster AS ( -- combined
SELECT /*+ 
       MATERIALIZE 
       NO_MERGE 
       */
       dbid,
       TO_NUMBER(NULL) instance_number,
       MIN(begin_interval_time) begin_interval_time,
       MAX(end_interval_time) end_interval_time,
       COUNT(DISTINCT snap_id) snap_shots,        
       ROUND(100 * SUM(r_reqs) / (SUM(r_reqs) + SUM(w_reqs)), 1) r_reqs_perc,
       ROUND(100 * SUM(w_reqs) / (SUM(r_reqs) + SUM(w_reqs)), 1) w_reqs_perc,
       ROUND(MAX((r_reqs + w_reqs) / elapsed_sec)) rw_iops_peak,
       ROUND(MAX(r_reqs / elapsed_sec)) r_iops_peak,
       ROUND(MAX(w_reqs / elapsed_sec)) w_iops_peak,
       ROUND(PERCENTILE_DISC(0.999) WITHIN GROUP (ORDER BY (r_reqs + w_reqs) / elapsed_sec)) rw_iops_999,
       ROUND(PERCENTILE_DISC(0.999) WITHIN GROUP (ORDER BY r_reqs / elapsed_sec)) r_iops_999,
       ROUND(PERCENTILE_DISC(0.999) WITHIN GROUP (ORDER BY w_reqs / elapsed_sec)) w_iops_999,
       ROUND(PERCENTILE_DISC(0.99) WITHIN GROUP (ORDER BY (r_reqs + w_reqs) / elapsed_sec)) rw_iops_99,
       ROUND(PERCENTILE_DISC(0.99) WITHIN GROUP (ORDER BY r_reqs / elapsed_sec)) r_iops_99,
       ROUND(PERCENTILE_DISC(0.99) WITHIN GROUP (ORDER BY w_reqs / elapsed_sec)) w_iops_99,
       ROUND(PERCENTILE_DISC(0.97) WITHIN GROUP (ORDER BY (r_reqs + w_reqs) / elapsed_sec)) rw_iops_97,
       ROUND(PERCENTILE_DISC(0.97) WITHIN GROUP (ORDER BY r_reqs / elapsed_sec)) r_iops_97,
       ROUND(PERCENTILE_DISC(0.97) WITHIN GROUP (ORDER BY w_reqs / elapsed_sec)) w_iops_97,
       ROUND(PERCENTILE_DISC(0.95) WITHIN GROUP (ORDER BY (r_reqs + w_reqs) / elapsed_sec)) rw_iops_95,
       ROUND(PERCENTILE_DISC(0.95) WITHIN GROUP (ORDER BY r_reqs / elapsed_sec)) r_iops_95,
       ROUND(PERCENTILE_DISC(0.95) WITHIN GROUP (ORDER BY w_reqs / elapsed_sec)) w_iops_95,
       ROUND(PERCENTILE_DISC(0.90) WITHIN GROUP (ORDER BY (r_reqs + w_reqs) / elapsed_sec)) rw_iops_90,
       ROUND(PERCENTILE_DISC(0.90) WITHIN GROUP (ORDER BY r_reqs / elapsed_sec)) r_iops_90,
       ROUND(PERCENTILE_DISC(0.90) WITHIN GROUP (ORDER BY w_reqs / elapsed_sec)) w_iops_90,
       ROUND(PERCENTILE_DISC(0.75) WITHIN GROUP (ORDER BY (r_reqs + w_reqs) / elapsed_sec)) rw_iops_75,
       ROUND(PERCENTILE_DISC(0.75) WITHIN GROUP (ORDER BY r_reqs / elapsed_sec)) r_iops_75,
       ROUND(PERCENTILE_DISC(0.75) WITHIN GROUP (ORDER BY w_reqs / elapsed_sec)) w_iops_75,
       ROUND(MEDIAN((r_reqs + w_reqs) / elapsed_sec)) rw_iops_med,
       ROUND(MEDIAN(r_reqs / elapsed_sec)) r_iops_med,
       ROUND(MEDIAN(w_reqs / elapsed_sec)) w_iops_med,
       ROUND(AVG((r_reqs + w_reqs) / elapsed_sec)) rw_iops_avg,
       ROUND(AVG(r_reqs / elapsed_sec)) r_iops_avg,
       ROUND(AVG(w_reqs / elapsed_sec)) w_iops_avg,
       ROUND(100 * SUM(r_bytes) / (SUM(r_bytes) + SUM(w_bytes)), 1) r_bytes_perc,
       ROUND(100 * SUM(w_bytes) / (SUM(r_bytes) + SUM(w_bytes)), 1) w_bytes_perc,
       ROUND(MAX((r_bytes + w_bytes) / POWER(10,6) / elapsed_sec)) rw_mbps_peak,
       ROUND(MAX(r_bytes / POWER(10,6) / elapsed_sec)) r_mbps_peak,
       ROUND(MAX(w_bytes / POWER(10,6) / elapsed_sec)) w_mbps_peak,
       ROUND(PERCENTILE_DISC(0.999) WITHIN GROUP (ORDER BY (r_bytes + w_bytes) / POWER(10,6) / elapsed_sec)) rw_mbps_999,
       ROUND(PERCENTILE_DISC(0.999) WITHIN GROUP (ORDER BY r_bytes / POWER(10,6) / elapsed_sec)) r_mbps_999,
       ROUND(PERCENTILE_DISC(0.999) WITHIN GROUP (ORDER BY w_bytes / POWER(10,6) / elapsed_sec)) w_mbps_999,
       ROUND(PERCENTILE_DISC(0.99) WITHIN GROUP (ORDER BY (r_bytes + w_bytes) / POWER(10,6) / elapsed_sec)) rw_mbps_99,
       ROUND(PERCENTILE_DISC(0.99) WITHIN GROUP (ORDER BY r_bytes / POWER(10,6) / elapsed_sec)) r_mbps_99,
       ROUND(PERCENTILE_DISC(0.99) WITHIN GROUP (ORDER BY w_bytes / POWER(10,6) / elapsed_sec)) w_mbps_99,
       ROUND(PERCENTILE_DISC(0.97) WITHIN GROUP (ORDER BY (r_bytes + w_bytes) / POWER(10,6) / elapsed_sec)) rw_mbps_97,
       ROUND(PERCENTILE_DISC(0.97) WITHIN GROUP (ORDER BY r_bytes / POWER(10,6) / elapsed_sec)) r_mbps_97,
       ROUND(PERCENTILE_DISC(0.97) WITHIN GROUP (ORDER BY w_bytes / POWER(10,6) / elapsed_sec)) w_mbps_97,
       ROUND(PERCENTILE_DISC(0.95) WITHIN GROUP (ORDER BY (r_bytes + w_bytes) / POWER(10,6) / elapsed_sec)) rw_mbps_95,
       ROUND(PERCENTILE_DISC(0.95) WITHIN GROUP (ORDER BY r_bytes / POWER(10,6) / elapsed_sec)) r_mbps_95,
       ROUND(PERCENTILE_DISC(0.95) WITHIN GROUP (ORDER BY w_bytes / POWER(10,6) / elapsed_sec)) w_mbps_95,
       ROUND(PERCENTILE_DISC(0.90) WITHIN GROUP (ORDER BY (r_bytes + w_bytes) / POWER(10,6) / elapsed_sec)) rw_mbps_90,
       ROUND(PERCENTILE_DISC(0.90) WITHIN GROUP (ORDER BY r_bytes / POWER(10,6) / elapsed_sec)) r_mbps_90,
       ROUND(PERCENTILE_DISC(0.90) WITHIN GROUP (ORDER BY w_bytes / POWER(10,6) / elapsed_sec)) w_mbps_90,
       ROUND(PERCENTILE_DISC(0.75) WITHIN GROUP (ORDER BY (r_bytes + w_bytes) / POWER(10,6) / elapsed_sec)) rw_mbps_75,
       ROUND(PERCENTILE_DISC(0.75) WITHIN GROUP (ORDER BY r_bytes / POWER(10,6) / elapsed_sec)) r_mbps_75,
       ROUND(PERCENTILE_DISC(0.75) WITHIN GROUP (ORDER BY w_bytes / POWER(10,6) / elapsed_sec)) w_mbps_75,
       ROUND(MEDIAN((r_bytes + w_bytes) / POWER(10,6) / elapsed_sec)) rw_mbps_med,
       ROUND(MEDIAN(r_bytes / POWER(10,6) / elapsed_sec)) r_mbps_med,
       ROUND(MEDIAN(w_bytes / POWER(10,6) / elapsed_sec)) w_mbps_med,
       ROUND(AVG((r_bytes + w_bytes) / POWER(10,6) / elapsed_sec)) rw_mbps_avg,
       ROUND(AVG(r_bytes / POWER(10,6) / elapsed_sec)) r_mbps_avg,
       ROUND(AVG(w_bytes / POWER(10,6) / elapsed_sec)) w_mbps_avg
  FROM io_per_snap_id
 WHERE elapsed_sec > 60 -- ignore snaps too close
 GROUP BY
       dbid
),
io_per_inst_or_cluster AS (
SELECT dbid, 01 order_by, 'Maximum_or_peak' metric, instance_number, rw_iops_peak rw_iops, r_iops_peak r_iops, w_iops_peak w_iops, rw_mbps_peak rw_mbps, r_mbps_peak r_mbps, w_mbps_peak w_mbps, begin_interval_time, end_interval_time, snap_shots FROM io_per_inst
 UNION ALL
SELECT dbid, 02 order_by, '99.9th_percentl' metric, instance_number, rw_iops_999 rw_iops,  r_iops_999 r_iops,  w_iops_999 w_iops,  rw_mbps_999 rw_mbps,  r_mbps_999 r_mbps,  w_mbps_999 w_mbps,  begin_interval_time, end_interval_time, snap_shots FROM io_per_inst
 UNION ALL
SELECT dbid, 03 order_by, '99th_percentile' metric, instance_number, rw_iops_99 rw_iops,   r_iops_99 r_iops,   w_iops_99 w_iops,   rw_mbps_99 rw_mbps,   r_mbps_99 r_mbps,   w_mbps_99 w_mbps,   begin_interval_time, end_interval_time, snap_shots FROM io_per_inst
 UNION ALL
SELECT dbid, 04 order_by, '97th_percentile' metric, instance_number, rw_iops_97 rw_iops,   r_iops_97 r_iops,   w_iops_97 w_iops,   rw_mbps_97 rw_mbps,   r_mbps_97 r_mbps,   w_mbps_97 w_mbps,   begin_interval_time, end_interval_time, snap_shots FROM io_per_inst
 UNION ALL
SELECT dbid, 05 order_by, '95th_percentile' metric, instance_number, rw_iops_95 rw_iops,   r_iops_95 r_iops,   w_iops_95 w_iops,   rw_mbps_95 rw_mbps,   r_mbps_95 r_mbps,   w_mbps_95 w_mbps,   begin_interval_time, end_interval_time, snap_shots FROM io_per_inst
 UNION ALL
SELECT dbid, 06 order_by, '90th_percentile' metric, instance_number, rw_iops_90 rw_iops,   r_iops_90 r_iops,   w_iops_90 w_iops,   rw_mbps_90 rw_mbps,   r_mbps_90 r_mbps,   w_mbps_90 w_mbps,   begin_interval_time, end_interval_time, snap_shots FROM io_per_inst
 UNION ALL
SELECT dbid, 07 order_by, '75th_percentile' metric, instance_number, rw_iops_75 rw_iops,   r_iops_75 r_iops,   w_iops_75 w_iops,   rw_mbps_75 rw_mbps,   r_mbps_75 r_mbps,   w_mbps_75 w_mbps,   begin_interval_time, end_interval_time, snap_shots FROM io_per_inst
 UNION ALL
SELECT dbid, 08 order_by, 'Median'          metric, instance_number, rw_iops_med rw_iops,  r_iops_med r_iops,  w_iops_med w_iops,  rw_mbps_med rw_mbps,  r_mbps_med r_mbps,  w_mbps_med w_mbps,  begin_interval_time, end_interval_time, snap_shots FROM io_per_inst
 UNION ALL
SELECT dbid, 09 order_by, 'Average'         metric, instance_number, rw_iops_avg rw_iops,  r_iops_avg r_iops,  w_iops_avg w_iops,  rw_mbps_avg rw_mbps,  r_mbps_avg r_mbps,  w_mbps_avg w_mbps,  begin_interval_time, end_interval_time, snap_shots FROM io_per_inst
 UNION ALL
SELECT dbid, 01 order_by, 'Maximum_or_peak' metric, instance_number, rw_iops_peak rw_iops, r_iops_peak r_iops, w_iops_peak w_iops, rw_mbps_peak rw_mbps, r_mbps_peak r_mbps, w_mbps_peak w_mbps, begin_interval_time, end_interval_time, snap_shots FROM io_per_cluster
 UNION ALL
SELECT dbid, 02 order_by, '99.9th_percentl' metric, instance_number, rw_iops_999 rw_iops,  r_iops_999 r_iops,  w_iops_999 w_iops,  rw_mbps_999 rw_mbps,  r_mbps_999 r_mbps,  w_mbps_999 w_mbps,  begin_interval_time, end_interval_time, snap_shots FROM io_per_cluster
 UNION ALL
SELECT dbid, 03 order_by, '99th_percentile' metric, instance_number, rw_iops_99 rw_iops,   r_iops_99 r_iops,   w_iops_99 w_iops,   rw_mbps_99 rw_mbps,   r_mbps_99 r_mbps,   w_mbps_99 w_mbps,   begin_interval_time, end_interval_time, snap_shots FROM io_per_cluster
 UNION ALL
SELECT dbid, 04 order_by, '97th_percentile' metric, instance_number, rw_iops_97 rw_iops,   r_iops_97 r_iops,   w_iops_97 w_iops,   rw_mbps_97 rw_mbps,   r_mbps_97 r_mbps,   w_mbps_97 w_mbps,   begin_interval_time, end_interval_time, snap_shots FROM io_per_cluster
 UNION ALL
SELECT dbid, 05 order_by, '95th_percentile' metric, instance_number, rw_iops_95 rw_iops,   r_iops_95 r_iops,   w_iops_95 w_iops,   rw_mbps_95 rw_mbps,   r_mbps_95 r_mbps,   w_mbps_95 w_mbps,   begin_interval_time, end_interval_time, snap_shots FROM io_per_cluster
 UNION ALL
SELECT dbid, 06 order_by, '90th_percentile' metric, instance_number, rw_iops_90 rw_iops,   r_iops_90 r_iops,   w_iops_90 w_iops,   rw_mbps_90 rw_mbps,   r_mbps_90 r_mbps,   w_mbps_90 w_mbps,   begin_interval_time, end_interval_time, snap_shots FROM io_per_cluster
 UNION ALL
SELECT dbid, 07 order_by, '75th_percentile' metric, instance_number, rw_iops_75 rw_iops,   r_iops_75 r_iops,   w_iops_75 w_iops,   rw_mbps_75 rw_mbps,   r_mbps_75 r_mbps,   w_mbps_75 w_mbps,   begin_interval_time, end_interval_time, snap_shots FROM io_per_cluster
 UNION ALL
SELECT dbid, 08 order_by, 'Median'          metric, instance_number, rw_iops_med rw_iops,  r_iops_med r_iops,  w_iops_med w_iops,  rw_mbps_med rw_mbps,  r_mbps_med r_mbps,  w_mbps_med w_mbps,  begin_interval_time, end_interval_time, snap_shots FROM io_per_cluster
 UNION ALL
SELECT dbid, 09 order_by, 'Average'         metric, instance_number, rw_iops_avg rw_iops,  r_iops_avg r_iops,  w_iops_avg w_iops,  rw_mbps_avg rw_mbps,  r_mbps_avg r_mbps,  w_mbps_avg w_mbps,  begin_interval_time, end_interval_time, snap_shots FROM io_per_cluster
)
SELECT dbid,
       metric,
       instance_number,
       rw_iops,
       r_iops,
       w_iops,
       rw_mbps,
       r_mbps,
       w_mbps,
       TO_CHAR(CAST(begin_interval_time AS DATE), 'YYYY-MM-DD HH24:MI') begin_interval_time,
       TO_CHAR(CAST(end_interval_time AS DATE), 'YYYY-MM-DD HH24:MI') end_interval_time,
       snap_shots,
       ROUND(CAST(end_interval_time AS DATE) - CAST(begin_interval_time AS DATE), 1) days,
       ROUND(snap_shots / (CAST(end_interval_time AS DATE) - CAST(begin_interval_time AS DATE)), 1) avg_snaps_per_day
  FROM io_per_inst_or_cluster
 ORDER BY
       dbid,
       order_by,
       instance_number NULLS LAST
/

prompt 
prompt 









-- ############################################################
REM This next section gathers workload breakout information. 
REM This section can help one understand the different workloads running in the database
REM
REM This query is courtesy of Mattia Berlusconi, and has been included as-is.


DEFINE interval_mins = 120
DEFINE daysago = 1
DEFINE topn = 5

REPHEADER PAGE LEFT '~~BEGIN-WORKLOAD~~'
REPFOOTER PAGE LEFT '~~END-WORKLOAD~~'

select * from (
WITH xtimes (xdate) AS
  (SELECT to_date(trunc(sysdate-&&daysago)) xdate FROM dual
  UNION ALL
  SELECT xdate+(&&interval_mins/1440) FROM xtimes WHERE xdate+(&&interval_mins/1440) < trunc(sysdate+1-&&daysago)
  ),
raw_data as (
select row_number () over (partition by xdate order by dbtw desc) topn,
        to_char(xdate,'DD-MON-RR HH24:MI:SS') samplestart,
        to_char(xdate+&&interval_mins/1440,'DD-MON-RR HH24:MI:SS') sampleend,
        module, program,
       (sum(decode(event,null,0,dbtw)) over (partition by to_char(xdate,'DD-MON-RR HH24:MI:SS'))) smpcnt,
       (sum(decode(event,null,0,dbtw)) over (partition by to_char(xdate,'DD-MON-RR HH24:MI:SS')))/60/&&interval_mins aas,
       nvl(event,'*** IDLE *** ') tc,
       decode(event,null,0,dbtw) dbtw,
       decode(event,null,0,dbtw)/60/&&interval_mins aas_comp,
       DELTA_READ_IO_REQUESTS, DELTA_WRITE_IO_REQUESTS, DELTA_READ_IO_BYTES, DELTA_WRITE_IO_BYTES, session_type, wait_class
from (
        select s1.xdate,event,10*count(*) dbtw,count(ash.smpcnt) smpcnt, module, program,
        sum(DELTA_READ_IO_REQUESTS) DELTA_READ_IO_REQUESTS, sum(DELTA_WRITE_IO_REQUESTS) DELTA_WRITE_IO_REQUESTS, sum(DELTA_READ_IO_BYTES) DELTA_READ_IO_BYTES, sum(DELTA_WRITE_IO_BYTES) DELTA_WRITE_IO_BYTES,
        session_type, wait_class
          from (
                select  sample_id,
                        sample_time,
                        session_state,
                        module, program,
                        decode(session_state,'ON CPU','CPU + CPU Wait',event) event,
                        DELTA_READ_IO_REQUESTS, DELTA_WRITE_IO_REQUESTS, DELTA_READ_IO_BYTES, DELTA_WRITE_IO_BYTES,
                        10*(count(sample_id) over (partition by sample_id)) smpcnt,
                        session_type, wait_class
                from &diagpackprefix~_active_sess_history
                where to_date(to_char(sample_time,'DD-MON-RR HH24:MI:SS'),'DD-MON-RR HH24:MI:SS')
                        between trunc(sysdate-&&daysago) and trunc(sysdate+1-&&daysago) and session_type='FOREGROUND'
                )  ash,
                (select xdate
                from xtimes ) s1
        where 1=1
        AND '&OPTIONAL_SECTIONS'='YES'
        and ash.sample_time(+) between s1.xdate and s1.xdate+(&&interval_mins/1440)
        group by s1.xdate,event, module, program, session_type, wait_class))
,scoreboard as (select samplestart,
--samplestart, row_number () over (partition by samplestart order by dbtw desc) rn,
topn, module, program, tc event, --wait event
nvl(sum(dbtw) over (partition by samplestart),0) total_dbtime_sum, --total DB time
decode(smpcnt,0,0,dbtw/60/60) aas_comp, --aas due to currrent event, program, module
decode(smpcnt,0,0,dbtw/smpcnt) aas_contribution_pct, --PCT contribution over the measure AAS
nvl(sum(decode(smpcnt,0,0,dbtw/smpcnt)) over (partition by samplestart),0) tot_contributions, --sum of all contribution, it should always be 1,
session_type, --Background/Foreground - workload analysis whould take into account foreground only
wait_class
,nvl(DELTA_READ_IO_REQUESTS,0) DELTA_READ_IO_REQUESTS, nvl(DELTA_WRITE_IO_REQUESTS,0) DELTA_WRITE_IO_REQUESTS, nvl(DELTA_READ_IO_BYTES,0) DELTA_READ_IO_BYTES, nvl(DELTA_WRITE_IO_BYTES,0) DELTA_WRITE_IO_BYTES,
nvl(DELTA_READ_IO_REQUESTS/(sum(DELTA_READ_IO_REQUESTS) over (partition by samplestart)),0) rior_pct, --read IO requests PCT over the total read IO requests
nvl(DELTA_WRITE_IO_REQUESTS/(sum(DELTA_WRITE_IO_REQUESTS) over (partition by samplestart)),0) wior_pct, --write IO requests PCT over the total write IO requests
nvl(DELTA_READ_IO_BYTES/(sum(DELTA_READ_IO_BYTES) over (partition by samplestart)),0) riob_pct, --read IO throughput PCT over the total read IO throughput in bytes
nvl(DELTA_WRITE_IO_BYTES/(sum(DELTA_WRITE_IO_BYTES) over (partition by samplestart)),0) wiob_pct, --write IO throughput PCT over the total write IO throughput in bytes
nvl(sum(DELTA_READ_IO_REQUESTS) over (partition by samplestart),0) rior_tot,--total read IO requests in bytes for the snapshot
nvl(sum(DELTA_WRITE_IO_REQUESTS) over (partition by samplestart),0) wior_tot,--total write IO requests in bytes for the snapshot
nvl(sum(DELTA_READ_IO_BYTES) over (partition by samplestart),0) riob_tot, --total read IO throughput in bytes for the snapshot
nvl(sum(DELTA_WRITE_IO_BYTES) over (partition by samplestart),0) wiob_tot --total write IO throughput in bytes for the snapshot
from raw_data
)
select * 
from scoreboard
where topn<=&&topn
union all
select 
samplestart,
99 topn, 
'OTHER' module, 'OTHER' program, 'OTHER' event, --wait event
sum(total_dbtime_sum), --total DB time
sum(aas_comp), --aas due to currrent event, program, module
sum(aas_contribution_pct), --PCT contribution over the measure AAS
sum(tot_contributions), --sum of all contribution, it should always be 1,
'OTHER' session_type, --Background/Foreground - workload analysis whould take into account foreground only
'OTHER' wait_class
,sum(DELTA_READ_IO_REQUESTS), sum(DELTA_WRITE_IO_REQUESTS), sum(DELTA_READ_IO_BYTES), sum(DELTA_WRITE_IO_BYTES),
sum(rior_pct), --read IO requests PCT over the total read IO requests
sum(wior_pct), --write IO requests PCT over the total write IO requests
sum(riob_pct), --read IO throughput PCT over the total read IO throughput in bytes
sum(wiob_pct), --write IO throughput PCT over the total write IO throughput in bytes
sum(rior_tot),--total read IO requests in bytes for the snapshot
sum(wior_tot),--total write IO requests in bytes for the snapshot
sum(riob_tot), --total read IO throughput in bytes for the snapshot
sum(wiob_tot)
from scoreboard
where topn>&&topn
group by samplestart
)
where '&OPTIONAL_SECTIONS'='YES'
order by 1, 2 
/




prompt 
prompt 

REPHEADER OFF
REPFOOTER OFF
 
spool off
set termout on

prompt 
prompt 
prompt 
prompt 
prompt 
prompt 
prompt 
prompt 
prompt  Thank you for running the script.  Output is in the file: &SPOOL_FILE_NAME
prompt  We encourage you to review &SPOOL_FILE_NAME in a text editor.  
prompt  Do not share the file with AWS if you feel the file contains any customer-confidential data (there should not be, but we encourage you to check).
prompt 
prompt 
prompt 
prompt 

exit
