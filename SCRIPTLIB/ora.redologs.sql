column group# format 99999;
column status format a10;
column mb format 99999;
select group#, status, bytes/1024/1024 mb from v$log;

alter database add logfile group 10 ('/u01/app/oracle/oradata/ORADEV/onlinelog/redo10_1.log'
, '/u01/app/oracle/oradata/ORADEV/onlinelog/redo10_2.log'
, '/u01/app/oracle/oradata/ORADEV/onlinelog/redo10_3.log') size 2G, 
  group 11 ('/u01/app/oracle/oradata/ORADEV/onlinelog/redo11_1.log'
, '/u01/app/oracle/oradata/ORADEV/onlinelog/redo11_2.log'
, '/u01/app/oracle/oradata/ORADEV/onlinelog/redo11_3.log') size 2G,
group 12 ('/u01/app/oracle/oradata/ORADEV/onlinelog/redo12_1.log'
, '/u01/app/oracle/oradata/ORADEV/onlinelog/redo12_2.log'
, '/u01/app/oracle/oradata/ORADEV/onlinelog/redo12_3.log') size 2G;

alter system switch logfile;
alter database drop logfile group 1, group 2, group 3;



