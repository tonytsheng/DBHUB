-- https://docs.oracle.com/en/database/oracle/oracle-database/13.2/refrn/UNDO_RETENTION.html

-- Default undo_retention = 900 seconds/15 minutes 
-- The UNDO_RETENTION parameter controls the minimum amount of time Oracle attemps to retain undo information. 
-- It is NOT guaranteed, as it's dependent on the storage and number of ongoing transactions
-- If the storage cannot accomodate the timeframe, this will result in the "snapshot too old" message
-- This parameter can be changed dynamically without a reboot.
show parameter undo_retention; 

-- UNDO can be manually or automatically managed. Default is AUTO.
show parameter undo_management;

-- Check the current amount of undo time the current undo tablespace can accomodate
select to_char(begin_time, 'yyyy-mon-dd hh24:mi:ss'), to_char(end_time, 'yyyy-mon-dd hh24:mi:ss'), tuned_undoretention from v$undostat order by begin_time desc;

-- Display the UNDO tablespaces
show parameter undo_tablespace;
select * from dba_tablespaces where contents = 'UNDO' ;

-- Display the MaxSize of the UNDO tablespace in GB; Default is 100GB
select * from dba_data_files;
select file_name, tablespace_name, bytes/(1024*1024*1024), maxbytes/(1024*1024*1024), autoextensible from dba_data_files where tablespace_name = 'UNDO_T1';

--Flashback Query Example
select * from demo.demo as of timestamp to_timestamp('03-31-2021 09:14:21','mm-dd-yyyy hh24:mi:ss') order by id;

