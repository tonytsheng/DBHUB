## Scripts to help test and monitor RDS for Oracle DataGuard Switchover

- Scripts description
  - ins.heartbeat.py
    - insert into heartbeat table
    - also displays ip address for the database endpoint
    - current status of the database instance from the aws rds describe-db-instances call
    - error message if you cannot insert the row into the database
      - in the case of trying to insert into the read replica, you will this:
      ```
      Database Error :::  ORA-16000: database or pluggable database open for read-only access
      ```
  - cr8.heartbeat.sql 
    - create a heartbeat table 
  - checkdb.bsh
    - for primary and standby databases, call sqlplus client with an input script
  - 1.sql
    - check the last 5 rows for the heartbeat table
