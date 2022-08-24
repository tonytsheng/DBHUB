## Scripts to help test and monitor RDS for Oracle DataGuard Switchover

- Scripts description
  - ins.heartbeat.py
  - cr8.heartbeat.sql 
    - creates a heartbeat table to insert into
  - checkdb.bsh
    - for primary and standby databases, call sqlplus client with an input script
  - 1.sql
    - check the last 5 rows for the heartbeat table
