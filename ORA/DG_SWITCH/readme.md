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
    - the output looks like this - note that latency between the source and the read replica is usually less than a few seconds.
    ```
    ttsora90
           24-AUG-22 07.06.36.000000 PM                                                10.1.1.185                               10.1.2.248
           24-AUG-22 07.06.41.000000 PM                                                10.1.1.185                               10.1.2.248
           24-AUG-22 07.06.45.000000 PM                                                10.1.1.185                               10.1.2.248
           24-AUG-22 07.06.50.000000 PM                                                10.1.1.185                               10.1.2.248
           24-AUG-22 07.06.55.000000 PM                                                10.1.1.185                               10.1.2.248

    ttsora90-rr
           24-AUG-22 07.06.36.000000 PM                                                10.1.1.185                               10.1.2.248
           24-AUG-22 07.06.41.000000 PM                                                10.1.1.185                               10.1.2.248
           24-AUG-22 07.06.45.000000 PM                                                10.1.1.185                               10.1.2.248
           24-AUG-22 07.06.50.000000 PM                                                10.1.1.185                               10.1.2.248
           24-AUG-22 07.06.55.000000 PM                                                10.1.1.185                               10.1.2.248
    ````

## Potential Issues
- The new primary DB instance isn't ready for a role transition. The instance must be available, have no operations pending in its maintenance window, and have a backup retention period greater than 0.
  - Increase Backup Retention period on the Read Replica from 0 to X days
- You can't switch over because the primary instance's (ttsora90) option group contains unrelated instances
  - Assign both primary and read replica to a new/limited option group. The goal is to have an option group that is independent of other instances.
  - Create a new custom option group.
    - RDS Console
    - Create option group.
      - Name, Description, Engine, Major Engine Version.
    - Database - for both the primary and the read replica.
      - Modify
      - Option Group

## Console Notes
- Upon initiating the switchover: 
```
Switch over replica is in progress for ttsora90-rr. The switchover is in progress for ttsora90-rr. Replication is intrerrpted for all databases in the replica configuration. RDS is restarting the old and new primary databases and transferring transactions to ttsora90-rr.
```

- When the switchover is done:
```
Switch over replica is complete for ttsora90-rr. Reconnect your application to the new primary database. You might also want to configure Multi-AZ replication or change the instance type of the new primary to match the old one.
```

## Items to Note
- The ttsora90-rr is now the primary database. [The old read replica]
- The IP addresses did not switch (unlike MultiAZ failover). You will have to change the database endpoint. Consider using an NLB in front of your databases.
- Downtime is around 60 seconds.

## Sample Logs
- The output from ins.heartbeat.py [less frequent logging next time]:
```
Database Error :::  ORA-16000: database or pluggable database open for read-only access
2022-08-24 18:59:37.455867 ::: ttsora90 ::: 10.1.1.185 ::: available ::: None
2022-08-24 18:59:37.455867 ::: ttsora90-rr ::: 10.1.2.248 ::: available ::: False
Database Error :::  ORA-16000: database or pluggable database open for read-only access
2022-08-24 18:59:42.165122 ::: ttsora90 ::: 10.1.1.185 ::: available ::: None
2022-08-24 18:59:42.165122 ::: ttsora90-rr ::: 10.1.2.248 ::: available ::: False
Database Error :::  ORA-16000: database or pluggable database open for read-only access
2022-08-24 18:59:46.890866 ::: ttsora90 ::: 10.1.1.185 ::: modifying ::: None
2022-08-24 18:59:46.890866 ::: ttsora90-rr ::: 10.1.2.248 ::: available ::: False
Database Error :::  ORA-16000: database or pluggable database open for read-only access
2022-08-24 18:59:51.627973 ::: ttsora90 ::: 10.1.1.185 ::: modifying ::: None
2022-08-24 18:59:51.627973 ::: ttsora90-rr ::: 10.1.2.248 ::: modifying ::: False
Database Error :::  ORA-16000: database or pluggable database open for read-only access
2022-08-24 18:59:56.250537 ::: ttsora90 ::: 10.1.1.185 ::: modifying ::: None
2022-08-24 18:59:56.250537 ::: ttsora90-rr ::: 10.1.2.248 ::: modifying ::: False
Database Error :::  ORA-16000: database or pluggable database open for read-only access
2022-08-24 19:00:00.840595 ::: ttsora90 ::: 10.1.1.185 ::: modifying ::: None
2022-08-24 19:00:00.840595 ::: ttsora90-rr ::: 10.1.2.248 ::: modifying ::: False
Database Error :::  ORA-16000: database or pluggable database open for read-only access
2022-08-24 19:00:05.483006 ::: ttsora90 ::: 10.1.1.185 ::: modifying ::: None
2022-08-24 19:00:05.483006 ::: ttsora90-rr ::: 10.1.2.248 ::: modifying ::: False
Database Error :::  ORA-16000: database or pluggable database open for read-only access
2022-08-24 19:00:10.078371 ::: ttsora90 ::: 10.1.1.185 ::: modifying ::: None
2022-08-24 19:00:10.078371 ::: ttsora90-rr ::: 10.1.2.248 ::: modifying ::: False
Database Error :::  ORA-16000: database or pluggable database open for read-only access
2022-08-24 19:00:14.694755 ::: ttsora90 ::: 10.1.1.185 ::: modifying ::: None
2022-08-24 19:00:14.694755 ::: ttsora90-rr ::: 10.1.2.248 ::: modifying ::: False
Database Error :::  ORA-16000: database or pluggable database open for read-only access
2022-08-24 19:00:19.302974 ::: ttsora90 ::: 10.1.1.185 ::: modifying ::: None
2022-08-24 19:00:19.302974 ::: ttsora90-rr ::: 10.1.2.248 ::: modifying ::: False
Database Error :::  ORA-16000: database or pluggable database open for read-only access
2022-08-24 19:00:23.919474 ::: ttsora90 ::: 10.1.1.185 ::: modifying ::: None
2022-08-24 19:00:23.919474 ::: ttsora90-rr ::: 10.1.2.248 ::: modifying ::: False
Database Error :::  ORA-16000: database or pluggable database open for read-only access
2022-08-24 19:00:28.523271 ::: ttsora90 ::: 10.1.1.185 ::: modifying ::: None
2022-08-24 19:00:28.523271 ::: ttsora90-rr ::: 10.1.2.248 ::: modifying ::: False
Database Error :::  ORA-16000: database or pluggable database open for read-only access
2022-08-24 19:00:33.123287 ::: ttsora90 ::: 10.1.1.185 ::: modifying ::: None
2022-08-24 19:00:33.123287 ::: ttsora90-rr ::: 10.1.2.248 ::: modifying ::: False
Database Error :::  ORA-16000: database or pluggable database open for read-only access
2022-08-24 19:00:37.735137 ::: ttsora90 ::: 10.1.1.185 ::: modifying ::: None
2022-08-24 19:00:37.735137 ::: ttsora90-rr ::: 10.1.2.248 ::: modifying ::: False
Database Error :::  ORA-16000: database or pluggable database open for read-only access
2022-08-24 19:00:42.379973 ::: ttsora90 ::: 10.1.1.185 ::: modifying ::: None
2022-08-24 19:00:42.379973 ::: ttsora90-rr ::: 10.1.2.248 ::: modifying ::: False
Database Error :::  ORA-16000: database or pluggable database open for read-only access
2022-08-24 19:00:46.978062 ::: ttsora90 ::: 10.1.1.185 ::: modifying ::: None
2022-08-24 19:00:46.978062 ::: ttsora90-rr ::: 10.1.2.248 ::: modifying ::: False
Database Error :::  ORA-16000: database or pluggable database open for read-only access
2022-08-24 19:00:51.607616 ::: ttsora90 ::: 10.1.1.185 ::: modifying ::: None
2022-08-24 19:00:51.607616 ::: ttsora90-rr ::: 10.1.2.248 ::: modifying ::: False
Database Error :::  ORA-16000: database or pluggable database open for read-only access
2022-08-24 19:00:56.212475 ::: ttsora90 ::: 10.1.1.185 ::: modifying ::: None
2022-08-24 19:00:56.212475 ::: ttsora90-rr ::: 10.1.2.248 ::: modifying ::: False
Database Error :::  ORA-16000: database or pluggable database open for read-only access
2022-08-24 19:01:00.850037 ::: ttsora90 ::: 10.1.1.185 ::: modifying ::: None
2022-08-24 19:01:00.850037 ::: ttsora90-rr ::: 10.1.2.248 ::: modifying ::: False
Database Error :::  ORA-16000: database or pluggable database open for read-only access
2022-08-24 19:01:05.483367 ::: ttsora90 ::: 10.1.1.185 ::: modifying ::: None
2022-08-24 19:01:05.483367 ::: ttsora90-rr ::: 10.1.2.248 ::: modifying ::: False
Database Error :::  ORA-16000: database or pluggable database open for read-only access
2022-08-24 19:01:10.082275 ::: ttsora90 ::: 10.1.1.185 ::: available ::: None
2022-08-24 19:01:10.082275 ::: ttsora90-rr ::: 10.1.2.248 ::: modifying ::: False
Database Error :::  ORA-16000: database or pluggable database open for read-only access
2022-08-24 19:01:14.678809 ::: ttsora90 ::: 10.1.1.185 ::: available ::: None
2022-08-24 19:01:14.678809 ::: ttsora90-rr ::: 10.1.2.248 ::: modifying ::: False
Database Error :::  ORA-16000: database or pluggable database open for read-only access
2022-08-24 19:01:19.265199 ::: ttsora90 ::: 10.1.1.185 ::: available ::: None
2022-08-24 19:01:19.265199 ::: ttsora90-rr ::: 10.1.2.248 ::: modifying ::: False
Database Error :::  ORA-16000: database or pluggable database open for read-only access
2022-08-24 19:01:23.847965 ::: ttsora90 ::: 10.1.1.185 ::: modifying ::: None
2022-08-24 19:01:23.847965 ::: ttsora90-rr ::: 10.1.2.248 ::: modifying ::: False
Database Error :::  ORA-16000: database or pluggable database open for read-only access
2022-08-24 19:01:28.444425 ::: ttsora90 ::: 10.1.1.185 ::: modifying ::: None
2022-08-24 19:01:28.444425 ::: ttsora90-rr ::: 10.1.2.248 ::: modifying ::: False
Database Error :::  ORA-16000: database or pluggable database open for read-only access
2022-08-24 19:01:33.026029 ::: ttsora90 ::: 10.1.1.185 ::: modifying ::: None
2022-08-24 19:01:33.026029 ::: ttsora90-rr ::: 10.1.2.248 ::: modifying ::: False
Database Error :::  ORA-16000: database or pluggable database open for read-only access
2022-08-24 19:01:37.625407 ::: ttsora90 ::: 10.1.1.185 ::: modifying ::: None
2022-08-24 19:01:37.625407 ::: ttsora90-rr ::: 10.1.2.248 ::: modifying ::: False
Database Error :::  ORA-16000: database or pluggable database open for read-only access
2022-08-24 19:01:42.181692 ::: ttsora90 ::: 10.1.1.185 ::: modifying ::: None
2022-08-24 19:01:42.181692 ::: ttsora90-rr ::: 10.1.2.248 ::: modifying ::: False
Database Error :::  ORA-16000: database or pluggable database open for read-only access
2022-08-24 19:01:46.754911 ::: ttsora90 ::: 10.1.1.185 ::: modifying ::: None
2022-08-24 19:01:46.754911 ::: ttsora90-rr ::: 10.1.2.248 ::: modifying ::: False
Database Error :::  ORA-16000: database or pluggable database open for read-only access
2022-08-24 19:01:51.341534 ::: ttsora90 ::: 10.1.1.185 ::: modifying ::: None
2022-08-24 19:01:51.341534 ::: ttsora90-rr ::: 10.1.2.248 ::: modifying ::: False
Database Error :::  ORA-16000: database or pluggable database open for read-only access
2022-08-24 19:01:55.949903 ::: ttsora90 ::: 10.1.1.185 ::: modifying ::: None
2022-08-24 19:01:55.949903 ::: ttsora90-rr ::: 10.1.2.248 ::: modifying ::: False
Database Error :::  ORA-16000: database or pluggable database open for read-only access
2022-08-24 19:02:00.529690 ::: ttsora90 ::: 10.1.1.185 ::: modifying ::: None
2022-08-24 19:02:00.529690 ::: ttsora90-rr ::: 10.1.2.248 ::: modifying ::: False
Database Error :::  ORA-16000: database or pluggable database open for read-only access
2022-08-24 19:02:05.130163 ::: ttsora90 ::: 10.1.1.185 ::: modifying ::: None
2022-08-24 19:02:05.130163 ::: ttsora90-rr ::: 10.1.2.248 ::: modifying ::: False
Database Error :::  ORA-16456: switchover to standby in progress or completed
Database Error :::  ORA-16000: database or pluggable database open for read-only access
2022-08-24 19:02:09.706364 ::: ttsora90 ::: 10.1.1.185 ::: modifying ::: False
2022-08-24 19:02:09.706364 ::: ttsora90-rr ::: 10.1.2.248 ::: modifying ::: False
Database Error :::  ORA-00604: error occurred at recursive SQL level 1
ORA-16456: switchover to standby in progress or completed
Database Error :::  ORA-16000: database or pluggable database open for read-only access
2022-08-24 19:02:14.306599 ::: ttsora90 ::: 10.1.1.185 ::: modifying ::: False
2022-08-24 19:02:14.306599 ::: ttsora90-rr ::: 10.1.2.248 ::: modifying ::: False
Database Error :::  ORA-00604: error occurred at recursive SQL level 1
ORA-16456: switchover to standby in progress or completed
Database Error :::  ORA-12537: TNS:connection closed
2022-08-24 19:02:18.915929 ::: ttsora90 ::: 10.1.1.185 ::: modifying ::: False
2022-08-24 19:02:18.915929 ::: ttsora90-rr ::: 10.1.2.248 ::: modifying ::: False
Database Error :::  ORA-00604: error occurred at recursive SQL level 1
ORA-16456: switchover to standby in progress or completed
Database Error :::  ORA-01033: ORACLE initialization or shutdown in progress
Process ID: 0
Session ID: 0 Serial number: 0
2022-08-24 19:02:23.539540 ::: ttsora90 ::: 10.1.1.185 ::: modifying ::: False
2022-08-24 19:02:23.539540 ::: ttsora90-rr ::: 10.1.2.248 ::: modifying ::: False
Database Error :::  ORA-00604: error occurred at recursive SQL level 1
ORA-16456: switchover to standby in progress or completed
Database Error :::  ORA-01033: ORACLE initialization or shutdown in progress
Process ID: 0
Session ID: 0 Serial number: 0
2022-08-24 19:02:28.162848 ::: ttsora90 ::: 10.1.1.185 ::: modifying ::: False
2022-08-24 19:02:28.162848 ::: ttsora90-rr ::: 10.1.2.248 ::: modifying ::: False
Database Error :::  ORA-12537: TNS:connection closed
Database Error :::  ORA-01033: ORACLE initialization or shutdown in progress
Process ID: 0
Session ID: 0 Serial number: 0
2022-08-24 19:02:32.788546 ::: ttsora90 ::: 10.1.1.185 ::: modifying ::: False
2022-08-24 19:02:32.788546 ::: ttsora90-rr ::: 10.1.2.248 ::: modifying ::: False
Database Error :::  ORA-01034: ORACLE not available
ORA-27101: shared memory realm does not exist
Linux-x86_64 Error: 2: No such file or directory
Additional information: 4475
Additional information: 377622255
Process ID: 0
Session ID: 0 Serial number: 0
2022-08-24 19:02:37.543754 ::: ttsora90 ::: 10.1.1.185 ::: modifying ::: False
2022-08-24 19:02:37.543754 ::: ttsora90-rr ::: 10.1.2.248 ::: modifying ::: None
Database Error :::  ORA-01033: ORACLE initialization or shutdown in progress
Process ID: 0
Session ID: 0 Serial number: 0
2022-08-24 19:02:42.281858 ::: ttsora90 ::: 10.1.1.185 ::: modifying ::: False
2022-08-24 19:02:42.281858 ::: ttsora90-rr ::: 10.1.2.248 ::: modifying ::: None
Database Error :::  ORA-01033: ORACLE initialization or shutdown in progress
Process ID: 0
Session ID: 0 Serial number: 0
2022-08-24 19:02:47.046380 ::: ttsora90 ::: 10.1.1.185 ::: modifying ::: False
2022-08-24 19:02:47.046380 ::: ttsora90-rr ::: 10.1.2.248 ::: modifying ::: None
Database Error :::  ORA-01033: ORACLE initialization or shutdown in progress
Process ID: 0
Session ID: 0 Serial number: 0
2022-08-24 19:02:51.669167 ::: ttsora90 ::: 10.1.1.185 ::: modifying ::: False
2022-08-24 19:02:51.669167 ::: ttsora90-rr ::: 10.1.2.248 ::: modifying ::: None
Database Error :::  ORA-01033: ORACLE initialization or shutdown in progress
Process ID: 0
Session ID: 0 Serial number: 0
2022-08-24 19:02:56.283107 ::: ttsora90 ::: 10.1.1.185 ::: modifying ::: False
2022-08-24 19:02:56.283107 ::: ttsora90-rr ::: 10.1.2.248 ::: modifying ::: None
Database Error :::  ORA-16000: database or pluggable database open for read-only access
2022-08-24 19:03:00.883198 ::: ttsora90 ::: 10.1.1.185 ::: modifying ::: False
2022-08-24 19:03:00.883198 ::: ttsora90-rr ::: 10.1.2.248 ::: modifying ::: None
Database Error :::  ORA-16000: database or pluggable database open for read-only access
2022-08-24 19:03:05.550666 ::: ttsora90 ::: 10.1.1.185 ::: modifying ::: False
2022-08-24 19:03:05.550666 ::: ttsora90-rr ::: 10.1.2.248 ::: modifying ::: None
Database Error :::  ORA-16000: database or pluggable database open for read-only access
2022-08-24 19:03:10.175887 ::: ttsora90 ::: 10.1.1.185 ::: modifying ::: False
2022-08-24 19:03:10.175887 ::: ttsora90-rr ::: 10.1.2.248 ::: modifying ::: None
Database Error :::  ORA-16000: database or pluggable database open for read-only access
2022-08-24 19:03:14.789953 ::: ttsora90 ::: 10.1.1.185 ::: modifying ::: False
2022-08-24 19:03:14.789953 ::: ttsora90-rr ::: 10.1.2.248 ::: modifying ::: None
Database Error :::  ORA-16000: database or pluggable database open for read-only access
2022-08-24 19:03:19.431227 ::: ttsora90 ::: 10.1.1.185 ::: modifying ::: False
2022-08-24 19:03:19.431227 ::: ttsora90-rr ::: 10.1.2.248 ::: modifying ::: None
Database Error :::  ORA-16000: database or pluggable database open for read-only access
2022-08-24 19:03:24.015458 ::: ttsora90 ::: 10.1.1.185 ::: modifying ::: False
2022-08-24 19:03:24.015458 ::: ttsora90-rr ::: 10.1.2.248 ::: modifying ::: None
Database Error :::  ORA-16000: database or pluggable database open for read-only access
2022-08-24 19:03:28.608926 ::: ttsora90 ::: 10.1.1.185 ::: modifying ::: False
2022-08-24 19:03:28.608926 ::: ttsora90-rr ::: 10.1.2.248 ::: modifying ::: None
Database Error :::  ORA-16000: database or pluggable database open for read-only access
2022-08-24 19:03:33.185483 ::: ttsora90 ::: 10.1.1.185 ::: modifying ::: False
2022-08-24 19:03:33.185483 ::: ttsora90-rr ::: 10.1.2.248 ::: modifying ::: None
Database Error :::  ORA-16000: database or pluggable database open for read-only access
2022-08-24 19:03:37.775198 ::: ttsora90 ::: 10.1.1.185 ::: modifying ::: False
2022-08-24 19:03:37.775198 ::: ttsora90-rr ::: 10.1.2.248 ::: modifying ::: None
Database Error :::  ORA-16000: database or pluggable database open for read-only access
2022-08-24 19:03:42.338900 ::: ttsora90 ::: 10.1.1.185 ::: modifying ::: False
2022-08-24 19:03:42.338900 ::: ttsora90-rr ::: 10.1.2.248 ::: modifying ::: None
Database Error :::  ORA-16000: database or pluggable database open for read-only access
2022-08-24 19:03:46.945497 ::: ttsora90 ::: 10.1.1.185 ::: modifying ::: False
2022-08-24 19:03:46.945497 ::: ttsora90-rr ::: 10.1.2.248 ::: modifying ::: None
Database Error :::  ORA-16000: database or pluggable database open for read-only access
2022-08-24 19:03:51.533089 ::: ttsora90 ::: 10.1.1.185 ::: modifying ::: False
2022-08-24 19:03:51.533089 ::: ttsora90-rr ::: 10.1.2.248 ::: modifying ::: None
Database Error :::  ORA-16000: database or pluggable database open for read-only access
2022-08-24 19:03:56.110123 ::: ttsora90 ::: 10.1.1.185 ::: modifying ::: False
2022-08-24 19:03:56.110123 ::: ttsora90-rr ::: 10.1.2.248 ::: modifying ::: None
Database Error :::  ORA-16000: database or pluggable database open for read-only access
2022-08-24 19:04:00.712281 ::: ttsora90 ::: 10.1.1.185 ::: modifying ::: False
2022-08-24 19:04:00.712281 ::: ttsora90-rr ::: 10.1.2.248 ::: modifying ::: None
Database Error :::  ORA-16000: database or pluggable database open for read-only access
2022-08-24 19:04:05.336774 ::: ttsora90 ::: 10.1.1.185 ::: modifying ::: False
2022-08-24 19:04:05.336774 ::: ttsora90-rr ::: 10.1.2.248 ::: modifying ::: None
Database Error :::  ORA-16000: database or pluggable database open for read-only access
2022-08-24 19:04:09.936224 ::: ttsora90 ::: 10.1.1.185 ::: modifying ::: False
2022-08-24 19:04:09.936224 ::: ttsora90-rr ::: 10.1.2.248 ::: modifying ::: None
Database Error :::  ORA-16000: database or pluggable database open for read-only access
2022-08-24 19:04:14.566318 ::: ttsora90 ::: 10.1.1.185 ::: modifying ::: False
2022-08-24 19:04:14.566318 ::: ttsora90-rr ::: 10.1.2.248 ::: modifying ::: None
Database Error :::  ORA-16000: database or pluggable database open for read-only access
2022-08-24 19:04:19.144947 ::: ttsora90 ::: 10.1.1.185 ::: modifying ::: False
2022-08-24 19:04:19.144947 ::: ttsora90-rr ::: 10.1.2.248 ::: modifying ::: None
Database Error :::  ORA-16000: database or pluggable database open for read-only access
2022-08-24 19:04:23.907094 ::: ttsora90 ::: 10.1.1.185 ::: modifying ::: False
2022-08-24 19:04:23.907094 ::: ttsora90-rr ::: 10.1.2.248 ::: modifying ::: None
Database Error :::  ORA-16000: database or pluggable database open for read-only access
2022-08-24 19:04:28.671707 ::: ttsora90 ::: 10.1.1.185 ::: modifying ::: False
2022-08-24 19:04:28.671707 ::: ttsora90-rr ::: 10.1.2.248 ::: modifying ::: None
Database Error :::  ORA-16000: database or pluggable database open for read-only access
2022-08-24 19:04:33.462664 ::: ttsora90 ::: 10.1.1.185 ::: modifying ::: False
2022-08-24 19:04:33.462664 ::: ttsora90-rr ::: 10.1.2.248 ::: modifying ::: None
Database Error :::  ORA-16000: database or pluggable database open for read-only access
2022-08-24 19:04:38.227546 ::: ttsora90 ::: 10.1.1.185 ::: modifying ::: False
2022-08-24 19:04:38.227546 ::: ttsora90-rr ::: 10.1.2.248 ::: modifying ::: None
Database Error :::  ORA-16000: database or pluggable database open for read-only access
2022-08-24 19:04:42.970107 ::: ttsora90 ::: 10.1.1.185 ::: modifying ::: False
2022-08-24 19:04:42.970107 ::: ttsora90-rr ::: 10.1.2.248 ::: modifying ::: None
Database Error :::  ORA-16000: database or pluggable database open for read-only access
2022-08-24 19:04:47.731852 ::: ttsora90 ::: 10.1.1.185 ::: modifying ::: False
2022-08-24 19:04:47.731852 ::: ttsora90-rr ::: 10.1.2.248 ::: modifying ::: None
Database Error :::  ORA-16000: database or pluggable database open for read-only access
2022-08-24 19:04:52.496514 ::: ttsora90 ::: 10.1.1.185 ::: modifying ::: False
2022-08-24 19:04:52.496514 ::: ttsora90-rr ::: 10.1.2.248 ::: modifying ::: None
Database Error :::  ORA-16000: database or pluggable database open for read-only access
2022-08-24 19:04:57.247899 ::: ttsora90 ::: 10.1.1.185 ::: modifying ::: False
2022-08-24 19:04:57.247899 ::: ttsora90-rr ::: 10.1.2.248 ::: modifying ::: None
Database Error :::  ORA-16000: database or pluggable database open for read-only access
2022-08-24 19:05:01.999578 ::: ttsora90 ::: 10.1.1.185 ::: modifying ::: False
2022-08-24 19:05:01.999578 ::: ttsora90-rr ::: 10.1.2.248 ::: modifying ::: None
Database Error :::  ORA-16000: database or pluggable database open for read-only access
2022-08-24 19:05:06.813739 ::: ttsora90 ::: 10.1.1.185 ::: modifying ::: False
2022-08-24 19:05:06.813739 ::: ttsora90-rr ::: 10.1.2.248 ::: modifying ::: None
Database Error :::  ORA-16000: database or pluggable database open for read-only access
2022-08-24 19:05:11.578537 ::: ttsora90 ::: 10.1.1.185 ::: modifying ::: False
2022-08-24 19:05:11.578537 ::: ttsora90-rr ::: 10.1.2.248 ::: available ::: None
Database Error :::  ORA-16000: database or pluggable database open for read-only access
2022-08-24 19:05:16.349341 ::: ttsora90 ::: 10.1.1.185 ::: modifying ::: False
2022-08-24 19:05:16.349341 ::: ttsora90-rr ::: 10.1.2.248 ::: available ::: None
Database Error :::  ORA-16000: database or pluggable database open for read-only access
2022-08-24 19:05:20.946826 ::: ttsora90 ::: 10.1.1.185 ::: modifying ::: False
2022-08-24 19:05:20.946826 ::: ttsora90-rr ::: 10.1.2.248 ::: available ::: None
Database Error :::  ORA-16000: database or pluggable database open for read-only access
2022-08-24 19:05:25.563460 ::: ttsora90 ::: 10.1.1.185 ::: modifying ::: False
2022-08-24 19:05:25.563460 ::: ttsora90-rr ::: 10.1.2.248 ::: available ::: None
Database Error :::  ORA-16000: database or pluggable database open for read-only access
2022-08-24 19:05:30.147879 ::: ttsora90 ::: 10.1.1.185 ::: modifying ::: False
2022-08-24 19:05:30.147879 ::: ttsora90-rr ::: 10.1.2.248 ::: available ::: None
Database Error :::  ORA-16000: database or pluggable database open for read-only access
2022-08-24 19:05:34.797964 ::: ttsora90 ::: 10.1.1.185 ::: modifying ::: False
2022-08-24 19:05:34.797964 ::: ttsora90-rr ::: 10.1.2.248 ::: available ::: None
Database Error :::  ORA-16000: database or pluggable database open for read-only access
2022-08-24 19:05:39.398252 ::: ttsora90 ::: 10.1.1.185 ::: modifying ::: False
2022-08-24 19:05:39.398252 ::: ttsora90-rr ::: 10.1.2.248 ::: available ::: None
Database Error :::  ORA-16000: database or pluggable database open for read-only access
2022-08-24 19:05:44.005291 ::: ttsora90 ::: 10.1.1.185 ::: modifying ::: False
2022-08-24 19:05:44.005291 ::: ttsora90-rr ::: 10.1.2.248 ::: available ::: None
Database Error :::  ORA-16000: database or pluggable database open for read-only access
2022-08-24 19:05:48.575134 ::: ttsora90 ::: 10.1.1.185 ::: modifying ::: False
2022-08-24 19:05:48.575134 ::: ttsora90-rr ::: 10.1.2.248 ::: available ::: None
Database Error :::  ORA-16000: database or pluggable database open for read-only access
2022-08-24 19:05:53.120728 ::: ttsora90 ::: 10.1.1.185 ::: modifying ::: False
2022-08-24 19:05:53.120728 ::: ttsora90-rr ::: 10.1.2.248 ::: available ::: None
Database Error :::  ORA-16000: database or pluggable database open for read-only access
2022-08-24 19:05:57.700045 ::: ttsora90 ::: 10.1.1.185 ::: modifying ::: False
2022-08-24 19:05:57.700045 ::: ttsora90-rr ::: 10.1.2.248 ::: available ::: None
Database Error :::  ORA-16000: database or pluggable database open for read-only access
2022-08-24 19:06:02.271418 ::: ttsora90 ::: 10.1.1.185 ::: modifying ::: False
2022-08-24 19:06:02.271418 ::: ttsora90-rr ::: 10.1.2.248 ::: available ::: None
Database Error :::  ORA-16000: database or pluggable database open for read-only access
2022-08-24 19:06:06.868362 ::: ttsora90 ::: 10.1.1.185 ::: modifying ::: False
2022-08-24 19:06:06.868362 ::: ttsora90-rr ::: 10.1.2.248 ::: available ::: None
Database Error :::  ORA-16000: database or pluggable database open for read-only access
2022-08-24 19:06:11.469493 ::: ttsora90 ::: 10.1.1.185 ::: modifying ::: False
2022-08-24 19:06:11.469493 ::: ttsora90-rr ::: 10.1.2.248 ::: available ::: None
Database Error :::  ORA-16000: database or pluggable database open for read-only access
2022-08-24 19:06:16.094165 ::: ttsora90 ::: 10.1.1.185 ::: modifying ::: False
2022-08-24 19:06:16.094165 ::: ttsora90-rr ::: 10.1.2.248 ::: available ::: None
Database Error :::  ORA-16000: database or pluggable database open for read-only access
2022-08-24 19:06:20.669507 ::: ttsora90 ::: 10.1.1.185 ::: modifying ::: False
2022-08-24 19:06:20.669507 ::: ttsora90-rr ::: 10.1.2.248 ::: available ::: None
Database Error :::  ORA-16000: database or pluggable database open for read-only access
2022-08-24 19:06:25.255144 ::: ttsora90 ::: 10.1.1.185 ::: modifying ::: False
2022-08-24 19:06:25.255144 ::: ttsora90-rr ::: 10.1.2.248 ::: available ::: None
Database Error :::  ORA-16000: database or pluggable database open for read-only access
2022-08-24 19:06:30.028959 ::: ttsora90 ::: 10.1.1.185 ::: available ::: False
2022-08-24 19:06:30.028959 ::: ttsora90-rr ::: 10.1.2.248 ::: available ::: None
Database Error :::  ORA-16000: database or pluggable database open for read-only access
2022-08-24 19:06:34.756646 ::: ttsora90 ::: 10.1.1.185 ::: available ::: False
2022-08-24 19:06:34.756646 ::: ttsora90-rr ::: 10.1.2.248 ::: available ::: None
```
