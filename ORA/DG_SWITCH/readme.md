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
    - if you run it in a while loop, the output will look like this:
      ```
      Database Error :::  ORA-16000: database or pluggable database open for read-only access
      2022-08-24 17:53:22.589624 ::: ttsora90 ::: 10.1.1.185 ::: available ::: None
      2022-08-24 17:53:22.589624 ::: ttsora90-rr ::: 10.1.2.248 ::: available ::: False
      Database Error :::  ORA-16000: database or pluggable database open for read-only access
      2022-08-24 17:53:27.209658 ::: ttsora90 ::: 10.1.1.185 ::: available ::: None
      2022-08-24 17:53:27.209658 ::: ttsora90-rr ::: 10.1.2.248 ::: available ::: False
      ```
  - cr8.heartbeat.sql 
    - create a heartbeat table 
  - checkdb.bsh
    - for primary and standby databases, call sqlplus client with an input script
  - sel.last5heartbeat.sql
    - check the last 5 rows for the heartbeat table

## Potential Issues

- The new primary DB instance isn't ready for a role transition. The instance must be available, have no operations pending in its maintenance window, and have a backup retention period greater than 0.
  - Incrase Backup Retention period on the Read Replica from 0 to X days

