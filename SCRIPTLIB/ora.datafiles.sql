select TABLESPACE_NAME, FILE_NAME,AUTOEXTENSIBLE,MAXBYTES from dba_Data_files where TABLESPACE_NAME='TTSHENG';

alter database datafile '/u01/app/oracle/oradata/ORADEV/datafile/slob_data_01.dbf' resize 5000M

shutdown abort
startup mount
alter database datafile '/directory/filename' offline drop;
alter database open;
drop tablespace ts_name;

