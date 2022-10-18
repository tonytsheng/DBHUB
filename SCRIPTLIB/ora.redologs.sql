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

alter database add logfile group 20 ('/u01/app/oracle/oradata/ORADEV/onlinelog/redo20_1.log'
, '/u01/app/oracle/oradata/ORADEV/onlinelog/redo20_2.log'
, '/u01/app/oracle/oradata/ORADEV/onlinelog/redo20_3.log') size 5G, 
  group 21 ('/u01/app/oracle/oradata/ORADEV/onlinelog/redo21_1.log'
, '/u01/app/oracle/oradata/ORADEV/onlinelog/redo21_2.log'
, '/u01/app/oracle/oradata/ORADEV/onlinelog/redo21_3.log') size 5G,
group 22 ('/u01/app/oracle/oradata/ORADEV/onlinelog/redo22_1.log'
, '/u01/app/oracle/oradata/ORADEV/onlinelog/redo22_2.log'
, '/u01/app/oracle/oradata/ORADEV/onlinelog/redo22_3.log') size 5G;

alter database add logfile group 30 ('/u01/app/oracle/oradata/ORADEV/onlinelog/redo30_1.log'
, '/u02/oradata/onlinelog/redo30_2.log'
, '/u03/oradata/onlinelog/redo30_3.log') size 5G,
  group 31 ('/u01/app/oracle/oradata/ORADEV/onlinelog/redo31_1.log'
, '/u02/oradata/onlinelog/redo31_2.log'
, '/u03/oradata/onlinelog/redo31_3.log') size 5G,
group 32 ('/u01/app/oracle/oradata/ORADEV/onlinelog/redo32_1.log'
, '/u02/oradata/onlinelog/redo32_2.log'
, '/u03/oradata/onlinelog/redo32_3.log') size 5G;

alter database add logfile 
  group 40 ('/u02/oradata/onlinelog/redo40_1.log',
            '/u03/oradata/onlinelog/redo40_2.log',
            '/u04/oradata/onlinelog/redo40_3.log'
) size 20G,
  group 41 ('/u02/oradata/onlinelog/redo41_1.log',
            '/u03/oradata/onlinelog/redo41_2.log',
            '/u04/oradata/onlinelog/redo41_3.log'
) size 20G,
  group 42 ('/u02/oradata/onlinelog/redo42_1.log',
            '/u03/oradata/onlinelog/redo42_2.log',
            '/u04/oradata/onlinelog/redo42_3.log'
) size 20G;



select * from v$logfile;
select * from v$log;

alter system switch logfile;
alter database drop logfile group 1, group 2, group 3;

select * from v$logfile;
select * from v$log;

alter system switch logfile;
alter database drop logfile group 1, group 2, group 3;

alter system switch logfile;
alter database drop logfile group 1, group 2, group 3;



