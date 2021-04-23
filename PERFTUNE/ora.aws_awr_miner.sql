REM  This script is based on the AWR Miner script originally created by Tyler Muth
REM  It combines some additional logic/code from Craig Silveira and percentile logic from Yves Colin and Bertrand Drouvot
REM  In general, the modifications from the original AWR Miner are to remove unneeded data collection items (such as no need to collect TOP SQL).
REM  Other modifications are to collect some statistics around the # of lines of plsql, # of tables, etc that might be useful for understanding complexity.
REM 

REM  We assume that you have a valid license for Diagnostics Pack.  Do not run this script if you do not.
REM  PLEASE READ THE ABOVE LINE  ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

REM. If you do not have a license for Diagnostics Pack, ask your AWS contact for the alternate version of this script that is based on STATSPACK.

REM
Prompt You Must Run this via SQL*PLUS.  Do not use TOAD or SQLDEVELOPER or anthing else as they will corrupt the output file formatting.
Prompt Please run this script as a SCRIPT via @aws_awr_miner.sql or START aws_awr_miner.sql.  Do not paste the contents of this script interactively into sqlplus or you will corrupt the output file format.
prompt 
prompt 

REM


whenever sqlerror continue
define AWR_MINER_VER = 4.0.11.aws.13

REM 4.0.11.aws.12 - added nls_numeric_characters='. ' to fix comma vs decimal point confusion
REM 4.0.11.aws.13 = fix issue where hostnames were reported incorrectly
REM 4.0.11.aws.13 = fix feature usage query
REM 4.0.11.aws.13 = add a HCC metric to sysstat query
REM 4.0.11.aws.13 = add check to confirm statistics_level

clear columns
clear breaks
set define '&'
set concat '~'
set colsep " "
set pagesize 50000
SET ARRAYSIZE 5000
SET echo off
SET termout off
REPHEADER OFF
REPFOOTER OFF


ALTER SESSION SET WORKAREA_SIZE_POLICY = manual;
ALTER SESSION SET SORT_AREA_SIZE = 268435456;
alter session set container=cdb$root;
alter session set nls_numeric_characters='. ';

set timing off

set serveroutput on
set verify off
column cnt_dbid_1 new_value CNT_DBID noprint

define NUM_DAYS = 30
define SQL_TOP_N = 100
define CAPTURE_HOST_NAMES = 'YES'

alter session set cursor_sharing = exact;


REM  This assumes you are running this for the DBID as shown in v$database


SELECT count(DISTINCT dbid) cnt_dbid_1
FROM dba_hist_database_instance
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
					 FROM dba_hist_database_instance
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
prompt Will export AWR data for the following Database:

SELECT dbid,db_name db_name1
FROM dba_hist_database_instance
where dbid = '&DBID'
and rownum = 1;

prompt
prompt Please be patient while we collect data.
prompt
set termout off


column snap_min1 new_value SNAP_ID_MIN noprint
SELECT min(snap_id) - 1 snap_min1
  FROM dba_hist_snapshot
  WHERE dbid = &DBID 
    and begin_interval_time > (
		SELECT max(begin_interval_time) - &NUM_DAYS
		  FROM dba_hist_snapshot 
		  where dbid = &DBID);
		  
column snap_max1 new_value SNAP_ID_MAX noprint
SELECT max(snap_id) snap_max1
  FROM dba_hist_snapshot
  WHERE dbid = &DBID;
  
-- ################################

REM if you want to run for a specific range of snapshots, edit/uncomment the following line.  (Note: DBCSI has a limit of 1000 at most snapshots.  Do not use a range greater than that)

REM select 13320 snap_min1, 13330 snap_max1 from dual;

-- ################################

define DB_VERSION = 0
column :DB_VERSION_1 new_value DB_VERSION noprint
variable DB_VERSION_1 number




declare
	version_gte_11_2	varchar2(30);
	l_sql				varchar2(32767);
	l_variables	        varchar2(1000) := ' ';
	l_block_size		number;
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
define DISK_SIZE_12C_TABLE = ' ' 
column :DISK_SIZE_12C_TABLE_1 new_value DISK_SIZE_12C_TABLE noprint
variable DISK_SIZE_12C_TABLE_1 varchar2(30)
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
        :DISK_SIZE_12C_TABLE_1 := ' dba_hist_tablespace ';
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
        :DISK_SIZE_12C_TABLE_1 := ' dba_hist_datafile ';
        :CDB_PDB_VIEW_1 := 'dual';
	end if;
end;
/
whenever sqlerror continue

select :CDB_OR_DBA_COL_1, :DISK_SIZE_12C_WHERE_1, :DISK_SIZE_12C_1, :DISK_SIZE_12C_TABLE_1, :CDB_PDB_VIEW_1 from dual;


define DB_BLOCK_SIZE = 0
column :DB_BLOCK_SIZE_1 new_value DB_BLOCK_SIZE noprint
variable DB_BLOCK_SIZE_1 number



set feedback off
begin

	:DB_BLOCK_SIZE_1 := 0;

	for c1 in (
		with inst as (
		select min(instance_number) inst_num
		  from dba_hist_snapshot
		  where dbid = &DBID
			)
		SELECT VALUE the_block_size
			FROM DBA_HIST_PARAMETER
			WHERE dbid = &DBID
			and PARAMETER_NAME = 'db_block_size'
			AND snap_id = (SELECT MAX(snap_id) FROM dba_hist_osstat WHERE dbid = &DBID AND instance_number = (select inst_num from inst))
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


column FILE_NAME new_value SPOOL_FILE_NAME noprint
select 'awr-hist-'||'&DBNAME'||'-'||'&DBID'||'-'||ltrim('&SNAP_ID_MIN')||'-'||ltrim('&SNAP_ID_MAX')||'.out' FILE_NAME from dual;
spool &SPOOL_FILE_NAME


-- ##############################################################################################
REPHEADER ON
REPFOOTER ON 

set linesize 1000 
set numwidth 10
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

    dbms_output.put_line(rpad('AWR_MINER_VER',l_pad_length)||' &AWR_MINER_VER');

    FOR c1 IN (
			with inst as (
		select min(instance_number) inst_num
		  from dba_hist_snapshot
		  where dbid = &DBID
			and snap_id BETWEEN to_number(&SNAP_ID_MIN) and to_number(&SNAP_ID_MAX))
	SELECT 
                      CASE WHEN stat_name = 'PHYSICAL_MEMORY_BYTES' THEN 'PHYSICAL_MEMORY_GB' ELSE stat_name END stat_name,
                      CASE WHEN stat_name IN ('PHYSICAL_MEMORY_BYTES') THEN round(VALUE/1024/1024/1024,2) ELSE VALUE END stat_value
                  FROM dba_hist_osstat 
                 WHERE dbid = &DBID 
                   AND snap_id = (SELECT MAX(snap_id) FROM dba_hist_osstat WHERE dbid = &DBID AND instance_number = (select inst_num from inst))
				   AND instance_number = (select inst_num from inst)
                   AND (stat_name LIKE 'NUM_CPU%'
                   OR stat_name IN ('PHYSICAL_MEMORY_BYTES')))
    loop
        dbms_output.put_line(rpad(c1.stat_name,l_pad_length)||' '||c1.stat_value);
    end loop; --c1
    
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

	
	
	FOR c2 IN (SELECT 
						$IF $$VER_GTE_11_2 $THEN
							REPLACE(platform_name,' ','_') platform_name,
						$ELSE
							'None' platform_name,
						$END
						VERSION,db_name,DBID FROM dba_hist_database_instance 
						WHERE dbid = &DBID  
						and startup_time = (select max(startup_time) from dba_hist_database_instance WHERE dbid = &DBID )
						AND ROWNUM = 1)
    loop
        dbms_output.put_line(rpad('PLATFORM_NAME',l_pad_length)||' '||c2.platform_name);
        dbms_output.put_line(rpad('VERSION',l_pad_length)||' '||c2.VERSION);
        dbms_output.put_line(rpad('DB_NAME',l_pad_length)||' '||c2.db_name);
        dbms_output.put_line(rpad('DBID',l_pad_length)||' '||c2.DBID);
    end loop; --c2

	FOR c2a IN (SELECT 
                       banner from v$version where banner like 'Oracle Database%')
    loop
        dbms_output.put_line(rpad('BANNER',l_pad_length)||' '||c2a.banner);
    end loop; --c2a
    
    FOR c3 IN (SELECT count(distinct s.instance_number) instances
			     FROM dba_hist_database_instance i,dba_hist_snapshot s
				WHERE i.dbid = s.dbid
				  and i.dbid = &DBID
				  AND s.snap_id BETWEEN &SNAP_ID_MIN AND &SNAP_ID_MAX)
    loop
        dbms_output.put_line(rpad('INSTANCES',l_pad_length)||' '||c3.instances);
    end loop; --c3           
	
	
	FOR c4 IN (SELECT distinct regexp_replace(host_name,'^([[:alnum:]]+)\..*$','\1')  host_name 
			     FROM dba_hist_database_instance i,dba_hist_snapshot s
				WHERE i.dbid = s.dbid
				  and i.dbid = &DBID
                  and s.startup_time = i.startup_time
                  and  s.startup_time = (select max(startup_time) from dba_hist_database_instance WHERE dbid = &DBID )
				  AND s.snap_id BETWEEN &SNAP_ID_MIN AND &SNAP_ID_MAX
			    order by 1)
    loop
		if '&CAPTURE_HOST_NAMES' = 'YES' then
			l_hosts := l_hosts || c4.host_name ||',';	
		end if;
	end loop; --c4
	l_hosts := rtrim(l_hosts,',');
	dbms_output.put_line(rpad('HOSTS',l_pad_length)||' '||l_hosts);
	
--	FOR c5 IN (SELECT sys_context('USERENV', 'MODULE') module FROM DUAL)
--    loop
--        dbms_output.put_line(rpad('MODULE',l_pad_length)||' '||c5.module);
--    end loop; --c5  
	
	FOR c6 IN (select round(sum(bytes)/1024/1024/1024) Total_DB_size_in_Gb from (select bytes from &CDB_OR_DBA_COL~_data_files union all select bytes from &CDB_OR_DBA_COL~_temp_files))
    loop
        dbms_output.put_line(rpad('TOTAL_DB_SIZE_GB',l_pad_length)||' '||c6.Total_DB_size_in_Gb);
    end loop; --c6  

	FOR c6b IN (select round(sum(bytes)/1024/1024/1024) Total_DB_size_in_Gb from &CDB_OR_DBA_COL~_data_files)
    loop
        dbms_output.put_line(rpad('TOTAL_DATAFILE_SIZE_GB',l_pad_length)||' '||c6b.Total_DB_size_in_Gb);
    end loop; --c6b  
	
	FOR c7 IN (select round(sum(bytes)/1024/1024/1024) Used_DB_size_in_Gb from &CDB_OR_DBA_COL~_segments)
    loop
        dbms_output.put_line(rpad('USED_DB_SIZE_GB',l_pad_length)||' '||c7.Used_DB_size_in_Gb);
    end loop; --c7  
	
	FOR c8 IN (select count(*) num_links from &CDB_OR_DBA_COL~_db_links)
    loop
        dbms_output.put_line(rpad('COUNT_DB_LINKS',l_pad_length)||' '||c8.num_links);
    end loop; --c8  

	FOR c9 IN (select nvl(count(line),0) line_total from &CDB_OR_DBA_COL~_source where owner not in ('RDSADMIN','SYS','SYSTEM','XDB','X$NULL','SYSMAN','SYSBACKUP','SPATIAL%','SI_INFORMTN_SCHEMA','ORDSYS','ORDDATA','OUTLN','OJVMSYS','OWB%','MDSYS','ORACLE_OCM','OLAPSYS','APEX_040200','APEX_030200','AUDSYS','APPQOSSYS','CTXSYS','DBSNMP','DVSYS','FLOWS_FILES','GSMADMIN_INTERNAL','LBACSYS','ORDPLUGINS','OWBSYS','OWBSYS_AUDIT','WMSYS','APEX_050000','REMOTE_SCHEDULER_AGENT','DVF','DBSFWUSER','SYSDG','SYSKM','XS$NULL','GSMUSER','DIP','ANONYMOUS','GSMCATUSER','MDDATA','APEX_PUBLIC_USER','SYSRAC','SYS$UMF','GGSYS','SPATIAL_CSW_ADMIN_USR') )
    loop
        dbms_output.put_line(rpad('COUNT_LINES_PLSQL',l_pad_length)||' '||c9.line_total);
    end loop; --c9  

	FOR c10 IN (select count(username) num_schemas from &CDB_OR_DBA_COL~_users where username not in ('RDSADMIN','SYS','SYSTEM','XDB','X$NULL','SYSMAN','SYSBACKUP','SPATIAL%','SI_INFORMTN_SCHEMA','ORDSYS','ORDDATA','OUTLN','OJVMSYS','OWB%','MDSYS','ORACLE_OCM','OLAPSYS','APEX_040200','APEX_030200','AUDSYS','APPQOSSYS','CTXSYS','DBSNMP','DVSYS','FLOWS_FILES','GSMADMIN_INTERNAL','LBACSYS','ORDPLUGINS','OWBSYS','OWBSYS_AUDIT','WMSYS','APEX_050000','REMOTE_SCHEDULER_AGENT','DVF','DBSFWUSER','SYSDG','SYSKM','XS$NULL','GSMUSER','DIP','ANONYMOUS','GSMCATUSER','MDDATA','APEX_PUBLIC_USER','SYSRAC','SYS$UMF','GGSYS','SPATIAL_CSW_ADMIN_USR') )
    loop
        dbms_output.put_line(rpad('COUNT_SCHEMAS',l_pad_length)||' '||c10.num_schemas);
    end loop; --c10  

	FOR c11 IN (select count(*) num_pdbs from &CDB_PDB_VIEW )
    loop
        dbms_output.put_line(rpad('COUNT_PDBS',l_pad_length)||' '||(c11.num_pdbs-1));
    end loop; --c11

    FOR c12 in (select object_type, count(*) num_objs from &CDB_OR_DBA_COL~_objects
      where owner not in ('RDSADMIN','SYS','SYSTEM','XDB','X$NULL','SYSMAN','SYSBACKUP','SPATIAL%','SI_INFORMTN_SCHEMA','ORDSYS','ORDDATA','OUTLN','OJVMSYS','OWB%','MDSYS','ORACLE_OCM','OLAPSYS','APEX_040200','APEX_030200','AUDSYS','APPQOSSYS','CTXSYS','DBSNMP','DVSYS','FLOWS_FILES','GSMADMIN_INTERNAL','LBACSYS','ORDPLUGINS','OWBSYS','OWBSYS_AUDIT','WMSYS','APEX_050000','REMOTE_SCHEDULER_AGENT','DVF','DBSFWUSER','SYSDG','SYSKM','XS$NULL','GSMUSER','DIP','ANONYMOUS','GSMCATUSER','MDDATA','APEX_PUBLIC_USER','SYSRAC','SYS$UMF','GGSYS','SPATIAL_CSW_ADMIN_USR') 
      and object_type in ('TABLE','TABLE PARTITION','INDEX','INDEX PARTITION','CONSTRAINT','VIEW','MATERIALIZED VIEW','SEQUENCE','PACKAGE','PROCEDURE','FUNCTION','TRIGGER','TYPE','TYPE BODY','LOB')
      group by object_type
      order by object_type)
    loop
        dbms_output.put_line(rpad('COUNT_'||c12.object_type,l_pad_length)||' '||(c12.num_objs));
    end loop;

    FOR c13 in (select distinct name from &CDB_OR_DBA_COL~_feature_usage_statistics
      where currently_used ='TRUE'
        and name in ('Active Data Guard','Active Data Guard - Real-Time Query on Physical Standby','Application Express','Data Mining','Data Redaction','Editioning Views','Exadata','Fine Grained Audit','GoldenGate','In-Memory Column Store','Label Security','Oracle In-Database Hadoop','Java Virtual Machine (user)','Oracle Multitenant','Partitioning (user)','One Node','RAC','Real Application Security','Real Application Clusters (RAC)','Real Application Cluster One Node','Resource Manager','Shard Database','Spatial','Transparent Data Encryption','VPD','Hybrid Columnar Compression','Parallel SQL Query Execution')
        and dbid = &DBID
        order by name)
    loop
        dbms_output.put_line(rpad('FEATURE_'||c13.name,l_pad_length)||' '||'Yes');
    end loop;

    FOR c14 in (select name, value from v$parameter
      where name in ('statistics_level','timed_statistics')
        order by name)
    loop
        dbms_output.put_line(rpad('DEBUG_'||c14.name,l_pad_length)||' '||c14.value);
    end loop;

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
       FROM dba_hist_sgastat
      WHERE dbid = &DBID
        AND snap_id BETWEEN &SNAP_ID_MIN AND &SNAP_ID_MAX
   GROUP BY snap_id,
        instance_number
  UNION ALL
     SELECT snap_id,
        instance_number,
        ROUND (value / 1024 / 1024 / 1024, 1) stat_value,
        'PGA' stat_name
       FROM dba_hist_pgastat
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



-- ##############################################################################################


-- With CDB, we want to use the con_id field to join tables
-- 11.2.0.4 may or may not have dba_hist_tablespace.  Best to try to use dba_hist_datafile with 11.2?

REPHEADER PAGE LEFT '~~BEGIN-SIZE-ON-DISK~~'
REPFOOTER PAGE LEFT '~~END-SIZE-ON-DISK~~'
 WITH ts_info as (
select dbid, &DISK_SIZE_12C ts#, tsname, max(block_size) block_size
from &DISK_SIZE_12C_TABLE
-- was dba_hist_tablespace
where dbid = &DBID
group by dbid, &DISK_SIZE_12C ts#, tsname),
-- Get the maximum snaphsot id for each day from dba_hist_snapshot
snap_info as (
select dbid,to_char(trunc(end_interval_time,'DD'),'MM/DD/YY') dd, max(s.snap_id) snap_id
FROM dba_hist_snapshot s
where s.snap_id between &SNAP_ID_MIN and &SNAP_ID_MAX
and dbid = &DBID
group by dbid,trunc(end_interval_time,'DD'))
-- Sum up the sizes of all the tablespaces for the last snapshot of each day
select s.snap_id, round(sum(tablespace_size*f.block_size)/1024/1024/1024,2) size_gb
from dba_hist_tbspc_space_usage sp,
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
-- ##############################################################################################


REPHEADER PAGE LEFT '~~BEGIN-MAIN-METRICS~~'
REPFOOTER PAGE LEFT '~~END-MAIN-METRICS~~'

 select snap_id "snap",num_interval "dur_m", end_time "end",inst "inst",
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
nvl(max(decode(metric_name,'Cell Physical IO Interconnect Bytes',         round((maxval)/1024/1024,1),null)),0) "cell_io_int_mb_max"
 --the cell physical IO bytes metrics are for 1 minute, so remember to divide them by 60 if you are expecting bytes per second
  from(
  select  snap_id,num_interval,to_char(end_time,'YY/MM/DD HH24:MI') end_time,instance_number inst,metric_name,round(average,1) average,
  round(maxval,1) maxval,round(standard_deviation,1) standard_deviation
 from dba_hist_sysmetric_summary
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
 'Active Parallel Sessions','Active Serial Sessions','Average Synchronous Single-Block Read Latency','Cell Physical IO Interconnect Bytes'
    )
 )
 group by snap_id,num_interval, end_time,inst
 order by snap_id, end_time,inst;
 
 
-- http://www.oaktable.net/content/oracle-cpu-time
-- https://pavandba.files.wordpress.com/2009/11/owp_awr_historical_analysis.pdf
-- https://kkdba.com/Understand-DB-time.html

prompt 
prompt 

-- ##############################################################################################



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
           FROM dba_hist_snapshot s,
            dba_hist_system_event e
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
           FROM dba_hist_snapshot s,
            dba_hist_sys_time_model t
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
GROUP BY snap_id,
    wait_class
ORDER BY snap_id,
    wait_class; 

	
	
prompt 
prompt 


-- ##############################################################################################



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
      FROM dba_hist_snapshot s,
        dba_hist_system_event e
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
      FROM dba_hist_snapshot s,
        dba_hist_sys_time_model t
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
      FROM dba_hist_snapshot s,
        dba_hist_sys_time_model t
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
-- ##############################################################################################



REPHEADER PAGE LEFT '~~BEGIN-SYSSTAT~~'
REPFOOTER PAGE LEFT '~~END-SYSSTAT~~'
SELECT SNAP_ID,
  MAX(DECODE(event_name,'cell flash cache read hits', event_val_diff,NULL)) "cell_flash_hits",
  MAX(DECODE(event_name,'physical read total IO requests', event_val_diff,NULL)) "read_iops",
  ROUND(MAX(DECODE(event_name,'physical read total bytes', event_val_diff,NULL))                                 /1024/1024,1) "read_mb",
  ROUND(MAX(DECODE(event_name,'physical read total bytes optimized', event_val_diff,NULL))                       /1024/1024,1) "read_mb_opt",
  ROUND(MAX(DECODE(event_name,'cell physical IO interconnect bytes', event_val_diff,NULL))                       /1024/1024,1) "cell_int_mb",
  ROUND(MAX(DECODE(event_name,'cell physical IO interconnect bytes returned by smart scan', event_val_diff,NULL))/1024/1024,1) "cell_int_ss_mb",
  ROUND(MAX(DECODE(event_name,'cell physical IO bytes saved by storage index', event_val_diff,NULL))/1024/1024,1) "cell_si_save_mb",
  ROUND(MAX(DECODE(event_name,'cell physical IO bytes eligible for predicate offload', event_val_diff,NULL))/1024/1024,1) "cell_bytes_elig_mb",
  ROUND(MAX(DECODE(event_name,'HCC scan cell bytes decompressed', event_val_diff,NULL))/1024/1024,1) "cell_hcc_bytes_mb"
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
      FROM dba_hist_snapshot s,
        dba_hist_sysstat t
      WHERE s.dbid = t.dbid
      AND s.dbid   = &DBID
      AND s.instance_number = t.instance_number
      AND s.snap_id         = t.snap_id
      AND s.snap_id BETWEEN &SNAP_ID_MIN AND &SNAP_ID_MAX
      AND t.snap_id BETWEEN &SNAP_ID_MIN AND &SNAP_ID_MAX
      AND t.stat_name IN ('cell flash cache read hits','physical read total IO requests', 'cell physical IO bytes saved by storage index',
      'cell physical IO interconnect bytes','cell physical IO interconnect bytes returned by smart scan', 
      'physical read total bytes','physical read total bytes optimized' , 'cell physical IO bytes eligible for predicate offload','HCC scan cell bytes decompressed')
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
-- ##############################################################################################



REPHEADER PAGE LEFT '~~BEGIN-PERCENT-CPU~~'
REPFOOTER PAGE LEFT '~~END-PERCENT-CPU~~'
column METRIC format a20
WITH 
cpu_per_inst_and_sample AS (
SELECT /*+ 
       FULL(h.INT$DBA_HIST_ACT_SESS_HISTORY.sn) 
       FULL(h.INT$DBA_HIST_ACT_SESS_HISTORY.ash) 
       FULL(h.INT$DBA_HIST_ACT_SESS_HISTORY.evt) 
       USE_HASH(h.INT$DBA_HIST_ACT_SESS_HISTORY.sn h.INT$DBA_HIST_ACT_SESS_HISTORY.ash h.INT$DBA_HIST_ACT_SESS_HISTORY.evt)
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
  FROM dba_hist_active_sess_history h,
       dba_hist_snapshot s
 WHERE (h.session_state = 'ON CPU' OR h.event = 'resmgr:cpu quantum')
   AND s.snap_id = h.snap_id
   AND s.dbid = h.dbid
   AND s.dbid = &DBID
   AND s.instance_number = h.instance_number
   AND s.snap_id BETWEEN &SNAP_ID_MIN AND &SNAP_ID_MAX
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
-- ##############################################################################################



REPHEADER PAGE LEFT '~~BEGIN-PERCENT-IO~'
REPFOOTER PAGE LEFT '~~END-PERCENT-IO~~'
WITH
sysstat_io AS (
SELECT /*+ 
       MATERIALIZE 
       NO_MERGE 
       FULL(h.INT$DBA_HIST_SYSSTAT.sn) 
       FULL(h.INT$DBA_HIST_SYSSTAT.s) 
       FULL(h.INT$DBA_HIST_SYSSTAT.nm) 
       USE_HASH(h.INT$DBA_HIST_SYSSTAT.sn h.INT$DBA_HIST_SYSSTAT.s h.INT$DBA_HIST_SYSSTAT.nm)
       FULL(h.sn) 
       FULL(h.s) 
       FULL(h.nm) 
       USE_HASH(h.sn h.s h.nm)
       FULL(s.INT$DBA_HIST_SNAPSHOT.WRM$_SNAPSHOT)
       FULL(s.WRM$_SNAPSHOT)
       USE_HASH(h s)
       LEADING(h.INT$DBA_HIST_SYSSTAT.nm h.INT$DBA_HIST_SYSSTAT.s h.INT$DBA_HIST_SYSSTAT.sn s.INT$DBA_HIST_SNAPSHOT.WRM$_SNAPSHOT)
       LEADING(h.nm h.s h.sn s.WRM$_SNAPSHOT)
       */
       h.snap_id,
       h.dbid,
       h.instance_number,
       SUM(CASE WHEN h.stat_name = 'physical read total IO requests' THEN value ELSE 0 END) r_reqs,
       SUM(CASE WHEN h.stat_name IN ('physical write total IO requests', 'redo writes') THEN value ELSE 0 END) w_reqs,
       SUM(CASE WHEN h.stat_name = 'physical read total bytes' THEN value ELSE 0 END) r_bytes,
       SUM(CASE WHEN h.stat_name IN ('physical write total bytes', 'redo size') THEN value ELSE 0 END) w_bytes
  FROM dba_hist_sysstat h,
       dba_hist_snapshot s
 WHERE h.stat_name IN ('physical read total IO requests', 'physical write total IO requests', 'redo writes', 'physical read total bytes', 'physical write total bytes', 'redo size')
   AND s.snap_id(+) = h.snap_id
   AND s.dbid(+) = h.dbid
   AND s.instance_number(+) = h.instance_number
   AND s.dbid(+) = &DBID
   AND s.snap_id(+) BETWEEN &SNAP_ID_MIN AND &SNAP_ID_MAX
 GROUP BY
       h.snap_id,
       h.dbid,
       h.instance_number
),
io_per_inst_and_snap_id AS (
SELECT /*+ 
       MATERIALIZE 
       NO_MERGE 
       FULL(s0.INT$DBA_HIST_SNAPSHOT.WRM$_SNAPSHOT)
       FULL(s0.WRM$_SNAPSHOT)
       FULL(s1.INT$DBA_HIST_SNAPSHOT.WRM$_SNAPSHOT)
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
       dba_hist_snapshot s0,
       sysstat_io h1,
       dba_hist_snapshot s1
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

ALTER SESSION SET WORKAREA_SIZE_POLICY = AUTO;
prompt 
prompt 


REPHEADER OFF
REPFOOTER OFF
 
spool off
set termout on

prompt  Thank you for running the script.  Output is in the file: &SPOOL_FILE_NAME

exit

