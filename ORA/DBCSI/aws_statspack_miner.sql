REM attempt at scripts to retrieve data from STATSPACK
REM 
REM Report issues/questions to dbayard@amazon.com
REM

REM You can download the latest version of this script from https://dbcsi.d29q8g3b9hzyur.amplifyapp.com/aws_statspack_miner.sql

define AWR_MINER_VER = 4.0.11.statspack.16

REM 4.0.11.statspack.06 = add STATSPACK_SNAPS metric reporting how many statspack snaps are in the database
REM 4.0.11.statspack.07 = fix issue where hostnames were reported incorrectly
REM 4.0.11.statspack.07 = fix feature usage query
REM 4.0.11.statspack.08 = fix issue where ELA=0 in main-metrics-query
REM 4.0.11.statspack.09 = added more instructions
REM 4.0.11.statspack.10 = fix for 10g databases (thanks Lanre S.)
REM 4.0.11.statspack.11 = Added HOSTS_CURRENT and INSTANCES_CURRENT.  Merged some changes from aws_awr_miner v24
REM 4.0.11.statspack.12 = Added DBID to dba_feature_usage_statistics query. Added SET tab off.  Added new DB_ metrics to general info section.  Fixed platform_name for pre 11.2 databases
REM 4.0.11.statspack.13 = handle unexpected exceptions in General Information plsql code block better
REM 4.0.11.statspack.14 = added some more help text
REM 4.0.11.statspack.15 = added set NUMFORMAT to ensure expected output. Comment out legacy ALTER SESSION WORKAREA,SORT_AREA commands leftover from years ago.
REM 4.0.11.statspack.16 = address edge case where user has unusual SQLPlus settings

REM  This script is based on the AWR Miner script originally created by Tyler Muth
REM  It combines some additional logic/code from Craig Silveira.
REM  In general, the modifications from the original AWR miner are to remove unneeded data collection items (such as no need to collect TOP SQL).
REM  Other modifications are to collect some statistics around the # of lines of plsql, # of tables, etc that might be useful for understanding complexity.


REM  At this point, you should have already installed STATSPACK in your database (typically by running $ORACLE_HOME/rdbms/admin/spcreate.sql)
REM  and setup automated regular STATSPACK data collection jobs (typically by running $ORACLE_HOME/rdbms/admin/spauto.sql, and do so on each instance if running RAC).
REM  For more details about STATSPACK, review $ORACLE_HOME/rdbms/admin/spdoc.txt

REM  Instructions: Use sql*plus to run the data collection script as an user (such as PERFSTAT) who has access to the STATSPACK STATS$ tables and the data dictionary (i.e. select_catalog_role).

set termout on
prompt 
prompt 
prompt 
prompt 

Prompt This is the DBCSI data collection script for STATSPACK version &AWR_MINER_VER
Prompt
Prompt NOTICE1: You Must Run this via SQL*PLUS.  Do not use TOAD or SQLDEVELOPER or anything else as they will corrupt the output file formatting.
Prompt NOTICE2: Please run this script as a SCRIPT via @aws_statspack_miner.sql or START aws_statspack_miner.sql.  Do not paste the contents of this script interactively into sqlplus or you will corrupt the output file format.
prompt NOTICE3: This script is being maintained and enhanced by a database specialist solutions architect and is not officially supported by AWS. No warranty or guarantee is expressed or implied.

prompt 
prompt 
prompt 
prompt 

whenever sqlerror continue

set termout off
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
set tab off
set pagesize 50000
SET ARRAYSIZE 5000
REPHEADER OFF
REPFOOTER OFF



REM ALTER SESSION SET WORKAREA_SIZE_POLICY = manual;
REM ALTER SESSION SET SORT_AREA_SIZE = 268435456;
alter session set container=cdb$root;
alter session set nls_numeric_characters='. ';

set timing off

set termout off
set serveroutput on
set verify off
column cnt_dbid_1 new_value CNT_DBID noprint

define NUM_DAYS = 30
define SQL_TOP_N = 100
define CAPTURE_HOST_NAMES = 'YES'


set line 99

alter session set cursor_sharing = exact;


REM  This assumes you are running this for the DBID as shown in v$database

whenever sqlerror exit
set termout on
SELECT count(DISTINCT dbid) cnt_dbid_1
FROM stats$database_instance
where dbid in (select dbid from v$database);
 --where rownum = 1;
set termout off
whenever sqlerror continue

define DBID = ' ' 
column :DBID_1 new_value DBID noprint
variable DBID_1 varchar2(30)

define DB_VERSION = 0
column :DB_VERSION_1 new_value DB_VERSION noprint
variable DB_VERSION_1 number


set feedback off
declare
	version_gte_11_2	varchar2(30);
	l_sql				varchar2(32767);
	l_variables	        varchar2(1000) := ' ';
	l_block_size		number;
begin
	:DB_VERSION_1 :=  dbms_db_version.version + (dbms_db_version.release / 10);
			
	if to_number(&CNT_DBID) > 1 then
		:DBID_1 := ' ';
	else
		
		SELECT DISTINCT dbid into :DBID_1
					 FROM stats$database_instance
					where dbid in (select dbid from v$database);
		

	end if;
	
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

select :DBID_1 from dual;
select :DB_VERSION_1 from dual;


REM set heading off

select '&DBID' a from dual;

set termout on
column db_name1 new_value DBNAME
prompt Will export STATSPACK data for the following Database:

SELECT dbid,db_name db_name1
FROM stats$database_instance
where dbid = '&DBID'
and rownum = 1;

set termout off
define T_WAITED_MICRO_COL = 'TIME_WAITED_MICRO' 
column :T_WAITED_MICRO_COL_1 new_value T_WAITED_MICRO_COL noprint
variable T_WAITED_MICRO_COL_1 varchar2(30)

begin
	if :DB_VERSION_1  >= 11.1 then
		:T_WAITED_MICRO_COL_1 := 'TIME_WAITED_MICRO_FG';
	else
		:T_WAITED_MICRO_COL_1 := 'TIME_WAITED_MICRO';
	end if;

end;
/

select :T_WAITED_MICRO_COL_1 from dual;

define CDB_OR_DBA_COL = 'DBA' 
column :CDB_OR_DBA_COL_1 new_value CDB_OR_DBA_COL noprint
variable CDB_OR_DBA_COL_1 varchar2(30)
define DISK_SIZE_12C = ' ' 
column :DISK_SIZE_12C_1 new_value DISK_SIZE_12C noprint
variable DISK_SIZE_12C_1 varchar2(30)
define DISK_SIZE_12C_WHERE = ' ' 
column :DISK_SIZE_12C_WHERE_1 new_value DISK_SIZE_12C_WHERE noprint
variable DISK_SIZE_12C_WHERE_1 varchar2(30)
define CDB_PDB_VIEW = 'dual' 
column :CDB_PDB_VIEW_1 new_value CDB_PDB_VIEW noprint
variable CDB_PDB_VIEW_1 varchar2(30)

whenever sqlerror exit
declare
 mycount number;
begin
	if :DB_VERSION_1  >= 12.0 then
		:CDB_OR_DBA_COL_1 := 'CDB';
        :DISK_SIZE_12C_1 := ' con_id, ';
        :DISK_SIZE_12C_WHERE_1 := ' and f.con_id = sp.con_id ';
        :CDB_PDB_VIEW_1 := 'v$pdbs';
        -- select count(dbid) into mycount from v$containers where dbid=&DBID;
        -- if (mycount=0) then
        --   dbms_output.put_line('This is unusual.  Looks like we are connected to the PDB not the CDB');
        --   execute immediate 'bogus statement to force exit';
        -- end if;
	else
		:CDB_OR_DBA_COL_1 := 'DBA';
        :DISK_SIZE_12C_1 := ' ';
        :DISK_SIZE_12C_WHERE_1 := ' ';
        :CDB_PDB_VIEW_1 := 'dual';
	end if;
end;
/
whenever sqlerror continue

select :CDB_OR_DBA_COL_1, :DISK_SIZE_12C_WHERE_1, :DISK_SIZE_12C_1, :CDB_PDB_VIEW_1 from dual;


define DB_BLOCK_SIZE = 0
column :DB_BLOCK_SIZE_1 new_value DB_BLOCK_SIZE noprint
variable DB_BLOCK_SIZE_1 number


set feedback off
begin

	:DB_BLOCK_SIZE_1 := 0;

	for c1 in (
		with inst as (
		select min(instance_number) inst_num
		  from stats$snapshot
		  where dbid = &DBID
			)
		SELECT VALUE the_block_size
			FROM stats$PARAMETER
			WHERE dbid = &DBID
			and NAME = 'db_block_size'
			AND snap_id = (SELECT MAX(snap_id) FROM stats$osstat WHERE dbid = &DBID AND instance_number = (select inst_num from inst))
		   AND instance_number = (select inst_num from inst))
	loop
		:DB_BLOCK_SIZE_1 := c1.the_block_size;
	end loop; --c1
	
	if :DB_BLOCK_SIZE_1 = 0 then
		:DB_BLOCK_SIZE_1 := 8192;
	end if;


end;
/

select :DB_BLOCK_SIZE_1 from dual;


column snap_min1 new_value SNAP_ID_MIN noprint
SELECT min(snap_id) - 1 snap_min1
  FROM stats$snapshot
  WHERE dbid = &DBID 
    and snap_time > (
		SELECT max(snap_time) - &NUM_DAYS
		  FROM stats$snapshot 
		  where dbid = &DBID);
		  
column snap_max1 new_value SNAP_ID_MAX noprint
SELECT max(snap_id) snap_max1
  FROM stats$snapshot
  WHERE dbid = &DBID;
  
column FILE_NAME new_value SPOOL_FILE_NAME noprint
select 'statspack-hist-'||'&DBNAME'||'-'||'&DBID'||'-'||ltrim('&SNAP_ID_MIN')||'-'||ltrim('&SNAP_ID_MAX')||'.out' FILE_NAME from dual;
spool &SPOOL_FILE_NAME


-- ##############################################################################################
REPHEADER ON
REPFOOTER ON 

set linesize 1000 
set numwidth 10
set numformat ""
set wrap off
set heading on
set trimspool on
set feedback off




set serveroutput on
DECLARE
    l_pad_length number :=60;
	l_hosts	varchar2(4000);


BEGIN

    dbms_output.put_line('~~BEGIN-OS-INFORMATION~~');
    dbms_output.put_line(rpad('STAT_NAME',l_pad_length)||' '||'STAT_VALUE');
    dbms_output.put_line(rpad('-',l_pad_length,'-')||' '||rpad('-',l_pad_length,'-'));

    dbms_output.put_line(rpad('STATSPACK_MINER_VER',l_pad_length)||' &AWR_MINER_VER');

  begin
    FOR c1 IN (
			with inst as (
		select min(instance_number) inst_num
		  from stats$snapshot
		  where dbid = &DBID
			and snap_id BETWEEN to_number(&SNAP_ID_MIN) and to_number(&SNAP_ID_MAX))
	SELECT 
                      CASE WHEN stat_name = 'PHYSICAL_MEMORY_BYTES' THEN 'PHYSICAL_MEMORY_GB' ELSE stat_name END stat_name,
                      CASE WHEN stat_name IN ('PHYSICAL_MEMORY_BYTES') THEN round(VALUE/1024/1024/1024,2) ELSE VALUE END stat_value
                  FROM 
                  (select snap_id, dbid, instance_number, n.stat_name, value
from stats$osstat s, stats$osstatname n
where n.osstat_id=s.osstat_id) osstat2
                 WHERE dbid = &DBID 
                   AND snap_id = (SELECT MAX(snap_id) FROM stats$osstat WHERE dbid = &DBID AND instance_number = (select inst_num from inst))
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

	
	FOR c2 IN (SELECT 
						$IF $$VER_GTE_11_2 $THEN
							REPLACE(platform_name,' ','_') platform_name,
						$ELSE
							'None' platform_name,
						$END
						VERSION,db_name,DBID FROM stats$database_instance 
						WHERE dbid = &DBID  
						and startup_time = (select max(startup_time) from stats$database_instance WHERE dbid = &DBID )
						AND ROWNUM = 1)
    loop
        $IF $$VER_GTE_11_2 $THEN
          dbms_output.put_line(rpad('PLATFORM_NAME',l_pad_length)||' '||c2.platform_name);
        $END  
        dbms_output.put_line(rpad('VERSION',l_pad_length)||' '||c2.VERSION);
        dbms_output.put_line(rpad('DB_NAME',l_pad_length)||' '||c2.db_name);
        dbms_output.put_line(rpad('DBID',l_pad_length)||' '||c2.DBID);
    end loop; --c2

   $IF $$VER_GTE_11_2 $THEN
     null;
   $ELSE   
  	 for c1b in (SELECT distinct platform_name FROM V$DATABASE 
  				where dbid = &DBID
  				and rownum = 1)
  	loop
  		dbms_output.put_line(rpad('PLATFORM_NAME',l_pad_length)||' '||replace(c1b.platform_name,' ','_'));
  	end loop; 
  $END
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
      dbms_output.put_line(rpad('ERROR:C2a',l_pad_length)||' '||sqlerrm);
  end;    
  
  
  begin
    
    FOR c3 IN (SELECT count(distinct s.instance_number) instances, count(distinct s.snap_id) snaps
			     FROM stats$database_instance i,stats$snapshot s
				WHERE i.dbid = s.dbid
				  and i.dbid = &DBID
				  AND s.snap_id BETWEEN &SNAP_ID_MIN AND &SNAP_ID_MAX)
    loop
        dbms_output.put_line(rpad('INSTANCES',l_pad_length)||' '||c3.instances);
        dbms_output.put_line(rpad('STATSPACK_SNAPSHOTS',l_pad_length)||' '||c3.snaps);        
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
      dbms_output.put_line(rpad('ERROR:C3a',l_pad_length)||' '||sqlerrm);
  end;    
  
  
  begin
	
	FOR c4 IN (SELECT distinct regexp_replace(host_name,'^([[:alnum:]\-]+)\..*$','\1')  host_name 
			     FROM stats$database_instance i,stats$snapshot s
				WHERE i.dbid = s.dbid
				  and i.dbid = &DBID
          and s.startup_time = i.startup_time
          and s.startup_time = (select max(startup_time) from stats$database_instance WHERE dbid = &DBID )
				  AND s.snap_id BETWEEN &SNAP_ID_MIN AND &SNAP_ID_MAX
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
      dbms_output.put_line(rpad('ERROR:C4a',l_pad_length)||' '||sqlerrm);
  end;    
  
  
  begin
	
	

	FOR c6 IN (select round(sum(bytes)/1024/1024/1024) Total_DB_size_in_Gb from (select bytes from &CDB_OR_DBA_COL~_data_files where status !='INVALID' union all select bytes from &CDB_OR_DBA_COL~_temp_files where status in ('ONLINE','AVAILABLE')))
    loop
        dbms_output.put_line(rpad('TOTAL_DB_SIZE_GB',l_pad_length)||' '||c6.Total_DB_size_in_Gb);
    end loop; --c6  

	FOR c6b IN (select round(sum(bytes)/1024/1024/1024) Total_DB_size_in_Gb from &CDB_OR_DBA_COL~_data_files where status !='INVALID')
    loop
        dbms_output.put_line(rpad('TOTAL_DATAFILE_SIZE_GB',l_pad_length)||' '||c6b.Total_DB_size_in_Gb);
    end loop; --c6b  

	FOR c7 IN (select round(sum(bytes)/1024/1024/1024) Used_DB_size_in_Gb from &CDB_OR_DBA_COL~_segments)
    loop
        dbms_output.put_line(rpad('USED_DB_SIZE_GB',l_pad_length)||' '||c7.Used_DB_size_in_Gb);
    end loop; --c7  
  exception
    when others then
      dbms_output.put_line(rpad('ERROR:C6-7',l_pad_length)||' '||sqlerrm);
  end;    
  
  
  begin
	
	
	
	
   --Now gather some summary metrics.
   --To do so, we will re-use the detail queries from later in this script, but we will wrap them with statistical queries to get just the summaries we want.
   --First lets grap some metrics from the Main-Metrics section
   
   for cMain in (
with main_metrics as 
(
--
select snap "snap", dur_m "dur_m", to_char(end,'YY/MM/DD HH24:MI') "end", inst "inst",
    max("cpu_per_s") "cpu_per_s",
    max("read_iops") "read_iops",
    max("read_mb_s") "read_mb_s",
    max("write_iops") "write_iops",
    max("write_mb_s") "write_mb_s"
from    
  (  
SELECT SNAP_ID snap,
  round(max(ela)/60,1) dur_m,
  snap_time end,
  instance_number inst,
  MAX(DECODE(event_name,'server CPU', event_val_diff,NULL)) "cpu_per_s",
  null "read_iops",
  null "read_mb_s",
  null "write_iops",
  null "write_mb_s"
FROM
  (SELECT snap_id, instance_number, snap_time,
    event_name,
    SUM(val_per_s) event_val_diff,
    --     ROUND(SUM(val_per_s),1) event_val_diff,
    max(ela) ela
  FROM
    (SELECT snap_id, snap_time,
      instance_number,
      event_name,
      ela,
      event_val_diff,
      (event_val_diff/ela) val_per_s
    FROM
      (SELECT s.ela,
      /*(CAST (s.end_interval_time AS DATE) - CAST (s.begin_interval_time AS DATE)) * 24 * 3600 ela,*/
        s.snap_id, s.snap_time,
        s.instance_number,
        t.name wait_class,
        t.name event_name,
        CASE
          WHEN s.snap_time = s.startup_time
          THEN t.value
          ELSE t.value - lag (value) over (partition BY statistic#, t.dbid, t.instance_number, s.startup_time order by t.snap_id)
        END event_val_diff
      FROM (SELECT s0.*, (s0.snap_time - lag (s0.snap_time) over (partition BY s0.dbid, s0.instance_number, s0.startup_time order by s0.snap_id)) * 24 *3600 ela
from stats$snapshot s0) s ,
            (SELECT
  dbid,
  snap_id, 
  instance_number,
  999 statistic#,
      'CPU',
      'server CPU' name,
      SUM (VALUE / 1000000) value
    FROM
      stats$sys_time_model
    WHERE
      stat_id IN (select stat_id from stats$time_model_statname where stat_name in ('background cpu time', 'DB CPU'))
      group by dbid, snap_id, instance_number   )  t 
      WHERE s.dbid = t.dbid
      AND s.dbid   = &&DBID /* DBID */
      AND s.instance_number = t.instance_number
      AND s.snap_id         = t.snap_id
      AND s.snap_id BETWEEN &&SNAP_ID_MIN AND &&SNAP_ID_MAX
     /* AND t.snap_id BETWEEN &SNAP_ID_MIN AND &SNAP_ID_MAX */
           )
    WHERE event_val_diff IS NOT NULL and ela !=0
    )
  GROUP BY snap_id, instance_number, snap_time,
    event_name
  )
GROUP BY snap_id, instance_number, snap_time
union all
--REM get read_iops, read_mb_s, write_iops, write_mb_s from stats$sysstat
SELECT SNAP_ID snap,
  round(max(ela)/60,1) dur_m,
  snap_time end,
  instance_number inst,
  null "cpu_per_s",
  MAX(DECODE(event_name,'physical read total IO requests', event_val_diff,NULL)) "read_iops",
  ROUND(MAX(DECODE(event_name,'physical read total bytes', event_val_diff,NULL)) /1024/1024,1) "read_mb_s",
  MAX(DECODE(event_name,'physical write total IO requests', event_val_diff,NULL)) "write_iops",
  ROUND(MAX(DECODE(event_name,'physical write total bytes', event_val_diff,NULL)) /1024/1024,1) "write_mb_s"
FROM
  (SELECT snap_id, instance_number, snap_time,
    event_name,
    ROUND(SUM(val_per_s),1) event_val_diff,
    max(ela) ela
  FROM
    (SELECT snap_id,
      instance_number, snap_time,
      event_name,
      ela,
      event_val_diff,
      (event_val_diff/ela) val_per_s
    FROM
      (SELECT s.ela,
      /*(CAST (s.end_interval_time AS DATE) - CAST (s.begin_interval_time AS DATE)) * 24 * 3600 ela,*/
        s.snap_id,
        s.instance_number, s.snap_time,
        t.name wait_class,
        t.name event_name,
        CASE
          WHEN s.snap_time = s.startup_time
          THEN t.value
          ELSE t.value - lag (value) over (partition BY statistic#, t.dbid, t.instance_number, s.startup_time order by t.snap_id)
        END event_val_diff
      FROM (SELECT s0.*, (s0.snap_time - lag (s0.snap_time) over (partition BY s0.dbid, s0.instance_number, s0.startup_time order by s0.snap_id)) * 24 *3600 ela
from stats$snapshot s0) s  ,
            stats$sysstat t 
      WHERE s.dbid = t.dbid
      AND s.dbid   = &&DBID /* DBID */
      AND s.instance_number = t.instance_number
      AND s.snap_id         = t.snap_id
      AND s.snap_id BETWEEN &SNAP_ID_MIN AND &SNAP_ID_MAX
     /* AND t.snap_id BETWEEN &SNAP_ID_MIN AND &SNAP_ID_MAX */
      AND t.name IN ('cell flash cache read hits','physical read total IO requests', 'physical write total IO requests', 'cell physical IO bytes saved by storage index',
      'cell physical IO interconnect bytes','cell physical IO interconnect bytes returned by smart scan', 
      'physical read total bytes','physical write total bytes', 'physical read total bytes optimized' , 'cell physical IO bytes eligible for predicate offload')
      )
    WHERE event_val_diff IS NOT NULL and ela !=0
    )
  GROUP BY snap_id, instance_number, snap_time,
    event_name
  )
GROUP BY snap_id, instance_number, snap_time
 )
group by snap, dur_m, end, inst
ORDER BY snap, inst
--
 ),
 main_metrics_rw AS
 (
 select "cpu_per_s",
        "read_iops"+"write_iops" IOPS,
        "read_mb_s"+"write_mb_s" IOMB
   from main_metrics
 )
 --
 select
     round(PERCENTILE_DISC(0.9900) WITHIN GROUP (ORDER BY "cpu_per_s"),2)  DB_CPU_THREADS_AVERAGE_P99,
     PERCENTILE_DISC(0.9900) WITHIN GROUP (ORDER BY IOPS)  DB_IOPS_AVERAGE_P99,
     PERCENTILE_DISC(0.9900) WITHIN GROUP (ORDER BY IOMB)  DB_IOMB_AVERAGE_P99
   from main_metrics_rw
   )
   loop
        dbms_output.put_line(rpad('DB_CPU_THREADS_AVERAGE_P99',l_pad_length)||' '||cMain.DB_CPU_THREADS_AVERAGE_P99);
        -- dbms_output.put_line(rpad('DB_CPU_THREADS_PEAKS_50',l_pad_length)||' '||cMain.DB_CPU_THREADS_PEAKS_50);
        -- dbms_output.put_line(rpad('DB_CPU_THREADS_PEAKS_90',l_pad_length)||' '||cMain.DB_CPU_THREADS_PEAKS_90);
        -- dbms_output.put_line(rpad('DB_HOST_CPU_THREADS_AVERAGE_P99',l_pad_length)||' '||cMain.DB_HOST_CPU_THREADS_AVG_P99);
        -- dbms_output.put_line(rpad('DB_HOST_CPU_THREADS_PEAKS_50',l_pad_length)||' '||cMain.DB_HOST_CPU_THREADS_PEAKS_50);
        -- dbms_output.put_line(rpad('DB_HOST_CPU_THREADS_PEAKS_90',l_pad_length)||' '||cMain.DB_HOST_CPU_THREADS_PEAKS_90);
        dbms_output.put_line(rpad('DB_IOPS_AVERAGE_P99',l_pad_length)||' '||cMain.DB_IOPS_AVERAGE_P99);
        -- dbms_output.put_line(rpad('DB_IOPS_PEAKS_P50',l_pad_length)||' '||cMain.DB_IOPS_PEAKS_P50);
        -- dbms_output.put_line(rpad('DB_IOPS_PEAKS_P90',l_pad_length)||' '||cMain.DB_IOPS_PEAKS_P90);
        dbms_output.put_line(rpad('DB_IOMB_AVERAGE_P99',l_pad_length)||' '||cMain.DB_IOMB_AVERAGE_P99);
        -- dbms_output.put_line(rpad('DB_IOMB_PEAKS_P50',l_pad_length)||' '||cMain.DB_IOMB_PEAKS_P50);
        -- dbms_output.put_line(rpad('DB_IOMB_PEAKS_P90',l_pad_length)||' '||cMain.DB_IOMB_PEAKS_P90);
   
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
    MAX (DECODE (stat_name, 'SGA', stat_value, NULL)) "SGA",
    MAX (DECODE (stat_name, 'PGA', stat_value, NULL)) "PGA",
    MAX (DECODE (stat_name, 'SGA', stat_value, NULL)) + MAX (DECODE (stat_name, 'PGA', stat_value,
    NULL)) "TOTAL"
   FROM
    (SELECT snap_id,
        instance_number,
        ROUND (SUM (bytes) / 1024 / 1024 / 1024, 1) stat_value,
        MAX ('SGA') stat_name
       FROM stats$sgastat
      WHERE dbid = &DBID
        AND snap_id BETWEEN &SNAP_ID_MIN+2 AND &SNAP_ID_MAX
   GROUP BY snap_id,
        instance_number
  UNION ALL
     SELECT snap_id,
        instance_number,
        ROUND (value / 1024 / 1024 / 1024, 1) stat_value,
        'PGA' stat_name
       FROM stats$pgastat
      WHERE dbid = &DBID
        AND snap_id BETWEEN &SNAP_ID_MIN+2 AND &SNAP_ID_MAX
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
        dbms_output.put_line(rpad('DB_SGAPGA_TOTAL',l_pad_length)||' '||cMemory.DB_SGAPGA_TOTAL);
   end loop;
  exception
    when others then
      dbms_output.put_line(rpad('ERROR:CMEMORY',l_pad_length)||' '||sqlerrm);
  end;    
  
  
  begin
   

	
	
	
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
      dbms_output.put_line(rpad('ERROR:C12',l_pad_length)||' '||sqlerrm);
  end;    
  
  
  begin


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

	FOR c5 IN (SELECT regexp_replace(sys_context('USERENV', 'MODULE'),'([[:alnum:]\-]+)\@.*$','\1') module,  '&_sqlplus_release' sqlplus_version FROM DUAL)
    loop
        dbms_output.put_line(rpad('DEBUG_MODULE',l_pad_length)||' '||c5.module);
        dbms_output.put_line(rpad('DEBUG_SQLPLUS',l_pad_length)||' '||c5.sqlplus_version);
    end loop; --c5  
  exception
    when others then
      dbms_output.put_line(rpad('ERROR:C5',l_pad_length)||' '||sqlerrm);
  end;    
  
  


	dbms_output.put_line('~~END-OS-INFORMATION~~');
END;
/



prompt 
prompt 


-- ##############################################################################################

REPHEADER PAGE LEFT '~~BEGIN-MEMORY~~'
REPFOOTER PAGE LEFT '~~END-MEMORY~~'

SELECT snap_id,
    instance_number,
    MAX (DECODE (stat_name, 'SGA', stat_value, NULL)) "SGA",
    MAX (DECODE (stat_name, 'PGA', stat_value, NULL)) "PGA",
    MAX (DECODE (stat_name, 'SGA', stat_value, NULL)) + MAX (DECODE (stat_name, 'PGA', stat_value,
    NULL)) "TOTAL"
   FROM
    (SELECT snap_id,
        instance_number,
        ROUND (SUM (bytes) / 1024 / 1024 / 1024, 1) stat_value,
        MAX ('SGA') stat_name
       FROM stats$sgastat
      WHERE dbid = &DBID
        AND snap_id BETWEEN &SNAP_ID_MIN+2 AND &SNAP_ID_MAX
   GROUP BY snap_id,
        instance_number
  UNION ALL
     SELECT snap_id,
        instance_number,
        ROUND (value / 1024 / 1024 / 1024, 1) stat_value,
        'PGA' stat_name
       FROM stats$pgastat
      WHERE dbid = &DBID
        AND snap_id BETWEEN &SNAP_ID_MIN+2 AND &SNAP_ID_MAX
        AND NAME = 'total PGA allocated'
    )
GROUP BY snap_id,
    instance_number
ORDER BY snap_id,
    instance_number;
prompt 
prompt 


-- ##############################################################################################


-- With CDB, we want to use the con_id field to join tables

REPHEADER PAGE LEFT '~~BEGIN-SIZE-ON-DISK~~'
REPFOOTER PAGE LEFT '~~END-SIZE-ON-DISK~~'

REM select s.snap_id, round(sum(tablespace_size*f.block_size)/1024/1024/1024,2) size_gb
select snap_id, round(sum(bytes)/1024/1024/1024) size_gb from &CDB_OR_DBA_COL~_data_files,
    (select distinct snap_id from stats$pgastat
      WHERE dbid = &DBID
        AND snap_id BETWEEN &SNAP_ID_MIN+2 AND &SNAP_ID_MAX
        AND NAME = 'total PGA allocated') snaps
group by snap_id  
order by snap_id;        

prompt 
prompt   
-- ##############################################################################################


REPHEADER PAGE LEFT '~~BEGIN-MAIN-METRICS~~'
REPFOOTER PAGE LEFT '~~END-MAIN-METRICS~~'
REM STATSPACK DOES NOT DO SYSMETRIC STATS, so we will get cpu_per_s uisng another technique
REM key metrics: cpu_per_s, read_iops, read_mb_s, write_iops, write_mb_s, 
REM Missing: read_iops_max, write_iops_max, read_mb_s_max, write_mb_s_max
REM Missing: os_cpu, os_cpu_max, h_cpu_per_s

REM select snap_id "snap",num_interval "dur_m", end_time "end",inst "inst",

REM get cpu_per_s from stats$time_model_statname
REM get read_iops, read_mb_s, write_iops, write_mb_s from stats$sysstat
select snap "snap", dur_m "dur_m", to_char(end,'YY/MM/DD HH24:MI') "end", inst "inst",
    max("cpu_per_s") "cpu_per_s",
    max("read_iops") "read_iops",
    max("read_mb_s") "read_mb_s",
    max("write_iops") "write_iops",
    max("write_mb_s") "write_mb_s"
from    
  (  
SELECT SNAP_ID snap,
  round(max(ela)/60,1) dur_m,
  snap_time end,
  instance_number inst,
  MAX(DECODE(event_name,'server CPU', event_val_diff,NULL)) "cpu_per_s",
  null "read_iops",
  null "read_mb_s",
  null "write_iops",
  null "write_mb_s"
FROM
  (SELECT snap_id, instance_number, snap_time,
    event_name,
    SUM(val_per_s) event_val_diff,
    --     ROUND(SUM(val_per_s),1) event_val_diff,
    max(ela) ela
  FROM
    (SELECT snap_id, snap_time,
      instance_number,
      event_name,
      ela,
      event_val_diff,
      (event_val_diff/ela) val_per_s
    FROM
      (SELECT s.ela,
      /*(CAST (s.end_interval_time AS DATE) - CAST (s.begin_interval_time AS DATE)) * 24 * 3600 ela,*/
        s.snap_id, s.snap_time,
        s.instance_number,
        t.name wait_class,
        t.name event_name,
        CASE
          WHEN s.snap_time = s.startup_time
          THEN t.value
          ELSE t.value - lag (value) over (partition BY statistic#, t.dbid, t.instance_number, s.startup_time order by t.snap_id)
        END event_val_diff
      FROM (SELECT s0.*, (s0.snap_time - lag (s0.snap_time) over (partition BY s0.dbid, s0.instance_number, s0.startup_time order by s0.snap_id)) * 24 *3600 ela
from stats$snapshot s0) s ,
            (SELECT
  dbid,
  snap_id, 
  instance_number,
  999 statistic#,
      'CPU',
      'server CPU' name,
      SUM (VALUE / 1000000) value
    FROM
      stats$sys_time_model
    WHERE
      stat_id IN (select stat_id from stats$time_model_statname where stat_name in ('background cpu time', 'DB CPU'))
      group by dbid, snap_id, instance_number   )  t 
      WHERE s.dbid = t.dbid
      AND s.dbid   = &&DBID /* DBID */
      AND s.instance_number = t.instance_number
      AND s.snap_id         = t.snap_id
      AND s.snap_id BETWEEN &&SNAP_ID_MIN AND &&SNAP_ID_MAX
     /* AND t.snap_id BETWEEN &SNAP_ID_MIN AND &SNAP_ID_MAX */
           )
    WHERE event_val_diff IS NOT NULL and ela !=0
    )
  GROUP BY snap_id, instance_number, snap_time,
    event_name
  )
GROUP BY snap_id, instance_number, snap_time
union all
--REM get read_iops, read_mb_s, write_iops, write_mb_s from stats$sysstat
SELECT SNAP_ID snap,
  round(max(ela)/60,1) dur_m,
  snap_time end,
  instance_number inst,
  null "cpu_per_s",
  MAX(DECODE(event_name,'physical read total IO requests', event_val_diff,NULL)) "read_iops",
  ROUND(MAX(DECODE(event_name,'physical read total bytes', event_val_diff,NULL)) /1024/1024,1) "read_mb_s",
  MAX(DECODE(event_name,'physical write total IO requests', event_val_diff,NULL)) "write_iops",
  ROUND(MAX(DECODE(event_name,'physical write total bytes', event_val_diff,NULL)) /1024/1024,1) "write_mb_s"
FROM
  (SELECT snap_id, instance_number, snap_time,
    event_name,
    ROUND(SUM(val_per_s),1) event_val_diff,
    max(ela) ela
  FROM
    (SELECT snap_id,
      instance_number, snap_time,
      event_name,
      ela,
      event_val_diff,
      (event_val_diff/ela) val_per_s
    FROM
      (SELECT s.ela,
      /*(CAST (s.end_interval_time AS DATE) - CAST (s.begin_interval_time AS DATE)) * 24 * 3600 ela,*/
        s.snap_id,
        s.instance_number, s.snap_time,
        t.name wait_class,
        t.name event_name,
        CASE
          WHEN s.snap_time = s.startup_time
          THEN t.value
          ELSE t.value - lag (value) over (partition BY statistic#, t.dbid, t.instance_number, s.startup_time order by t.snap_id)
        END event_val_diff
      FROM (SELECT s0.*, (s0.snap_time - lag (s0.snap_time) over (partition BY s0.dbid, s0.instance_number, s0.startup_time order by s0.snap_id)) * 24 *3600 ela
from stats$snapshot s0) s  ,
            stats$sysstat t 
      WHERE s.dbid = t.dbid
      AND s.dbid   = &&DBID /* DBID */
      AND s.instance_number = t.instance_number
      AND s.snap_id         = t.snap_id
      AND s.snap_id BETWEEN &SNAP_ID_MIN AND &SNAP_ID_MAX
     /* AND t.snap_id BETWEEN &SNAP_ID_MIN AND &SNAP_ID_MAX */
      AND t.name IN ('cell flash cache read hits','physical read total IO requests', 'physical write total IO requests', 'cell physical IO bytes saved by storage index',
      'cell physical IO interconnect bytes','cell physical IO interconnect bytes returned by smart scan', 
      'physical read total bytes','physical write total bytes', 'physical read total bytes optimized' , 'cell physical IO bytes eligible for predicate offload')
      )
    WHERE event_val_diff IS NOT NULL and ela !=0
    )
  GROUP BY snap_id, instance_number, snap_time,
    event_name
  )
GROUP BY snap_id, instance_number, snap_time
 )
group by snap, dur_m, end, inst
ORDER BY snap, inst;
 

prompt 
prompt 

-- ##############################################################################################
REPHEADER PAGE LEFT '~~BEGIN-AVERAGE-ACTIVE-SESSIONS~~'
REPFOOTER PAGE LEFT '~~END-AVERAGE-ACTIVE-SESSIONS~~'
REM This section is not currently used for any DBCSI charts, so we will skip it for STATSPACK for now

	
	
prompt 
prompt 

-- ##############################################################################################


column wait_class format a20
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
        /* (CAST (s.end_interval_time AS DATE) - CAST (s.snap_time AS DATE)) * 24 * 3600 ela,*/
        s.ela,
        s.snap_id,
        wc.wait_class,
        e.event event_name,
        CASE
          WHEN s.snap_time = s.startup_time
          THEN e.time_waited_micro
          ELSE e.time_waited_micro - lag (e.time_waited_micro ) over (partition BY e.instance_number,e.event order by e.snap_id)
        END ttm
      FROM (SELECT s0.*, (s0.snap_time - lag (s0.snap_time) over (partition BY s0.dbid, s0.instance_number, s0.startup_time order by s0.snap_id)) * 24 *3600 ela
from stats$snapshot s0) s,
        stats$system_event e,
        v$event_name wc
      WHERE s.dbid          = e.dbid
      AND s.dbid            = &DBID
      AND s.instance_number = e.instance_number
      AND s.snap_id         = e.snap_id
      AND s.snap_id BETWEEN &SNAP_ID_MIN and &SNAP_ID_MAX
      AND wc.name=e.event
      AND e.event not in (select event from stats$idle_event union all SELECT NAME FROM V$EVENT_NAME WHERE WAIT_CLASS='Idle')
      UNION ALL
      SELECT
        /*+ qb_name(dbcpu) */
        /* (CAST (s.end_interval_time AS DATE) - CAST (s.begin_interval_time AS DATE)) * 24 * 3600 ela,*/
        s.ela,
        s.snap_id,
        t0.stat_name wait_class,
        t0.stat_name event_name,
        CASE
          WHEN s.snap_time = s.startup_time
          THEN t.value
          ELSE t.value - lag (t.value ) over (partition BY s.instance_number order by s.snap_id)
        END ttm
      FROM (SELECT s0.*, (s0.snap_time - lag (s0.snap_time) over (partition BY s0.dbid, s0.instance_number, s0.startup_time order by s0.snap_id)) * 24 *3600 ela
from stats$snapshot s0) s,
        stats$sys_time_model t,
        stats$time_model_statname t0
      WHERE s.dbid          = t.dbid
      AND s.dbid            = &DBID
      AND s.instance_number = t.instance_number
      AND s.snap_id         = t.snap_id
      AND s.snap_id BETWEEN &SNAP_ID_MIN and &SNAP_ID_MAX
      AND t.stat_id = t0.stat_id and t0.stat_name = 'DB CPU'
      )
    ) a,
    (SELECT snap_id,
      SUM(dbt) dbt
    FROM
      (SELECT
        /*+ qb_name(dbtime) */
        s.snap_id,
        t.instance_number,
        t.stat_id stat_id,
        CASE
          WHEN s.snap_time = s.startup_time
          THEN t.value
          ELSE t.value - lag (t.value ) over (partition BY s.instance_number order by s.snap_id)
        END dbt
      FROM stats$snapshot s,
        stats$sys_time_model t
      WHERE s.dbid          = t.dbid
      AND s.dbid            = &DBID
      AND s.instance_number = t.instance_number
      AND s.snap_id         = t.snap_id
      AND s.snap_id BETWEEN &SNAP_ID_MIN and &SNAP_ID_MAX
      AND t.stat_id in (select stat_id from stats$time_model_statname where stat_name = 'DB time')
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

-- ##############################################################################################



REPHEADER PAGE LEFT '~~BEGIN-SYSSTAT~~'
REPFOOTER PAGE LEFT '~~END-SYSSTAT~~'
REM this section is only used by DBCSI for Exadata charts, so we will skip it for statspack for now
SELECT &SNAP_ID_MAX SNAP_ID,
  0 "cell_flash_hits"
 -- MAX(DECODE(event_name,'physical read total IO requests', event_val_diff,NULL)) "read_iops",
 -- ROUND(MAX(DECODE(event_name,'physical read total bytes', event_val_diff,NULL))                                 /1024/1024,1) "read_mb",
 -- ROUND(MAX(DECODE(event_name,'physical read total bytes optimized', event_val_diff,NULL))                       /1024/1024,1) "read_mb_opt",
 -- ROUND(MAX(DECODE(event_name,'cell physical IO interconnect bytes', event_val_diff,NULL))                       /1024/1024,1) "cell_int_mb",
 -- ROUND(MAX(DECODE(event_name,'cell physical IO interconnect bytes returned by smart scan', event_val_diff,NULL))/1024/1024,1) "cell_int_ss_mb",
 -- ROUND(MAX(DECODE(event_name,'cell physical IO bytes saved by storage index', event_val_diff,NULL))/1024/1024,1) "cell_si_save_mb",
 -- ROUND(MAX(DECODE(event_name,'cell physical IO bytes eligible for predicate offload', event_val_diff,NULL))/1024/1024,1) "cell_bytes_elig_mb"
from dual;


prompt 
prompt 




-- ############################################################
REM This next section gathers feature usage details.  This information is used by DBCSI to make Standard Edition2 recommendations.  

REPHEADER PAGE LEFT '~~BEGIN-FEATURES~'
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


REPHEADER OFF
REPFOOTER OFF
 
spool off
REM ALTER SESSION SET WORKAREA_SIZE_POLICY = AUTO;
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



  
