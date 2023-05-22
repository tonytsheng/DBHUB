# Turning on a DMS Migration Task After Promoting a Read Replica
Prereqs: 
- Source instance up and healthy.
- Read replica from that source instance, up and healthy.
- Database Migration Service Replication Instance, up and healthy.
- DMS source endpoint from the Replication Instance to the source instance that has been tested successfully.
- Source instance configured correctly to be a source for DMS.

Execution order:
- Confirm Read Replica latency is acceptable.
- Stop all applications.
- Confirm Read Replica is in sync.
- Obtain the SCN from the source database.
- Promote the Read Replica.
- Create target endpoint to the former Read Replica.
- Test target endpoint.
- Create and start DMS migration task starting at the SCN.

# Provided Scripts
- getstatus.py can be run in another window as needed to track different executions with this work.
  - latest database alert log entries
  - list of archived and applied logs.
  - current SCN.
  - database instance status.
  - execute this by running 'python3 getstatus.py src_db src_rr_db'.
- promote_rr.py is the script that will do all the work.
  - execute this by running 'python3 promote_rr.py src_db src_rr_db'.

# Misc
- Even though the source database goes into Modifying status when creating or deleting an associated Read Replica, transactions still appear to work fine.
- Promotion of the RR to a standalone database looks like this:
  - Modifying
  - Rebooting
  - Backing-up

# Utilities
```
aws rds delete-db-instance --db-instance-identifier ttsora10-rr  --profile dba --skip-final-snapshot
aws rds describe-db-instances --profile dba | jq ' .DBInstances[]|  .DBInstanceIdentifier, .DBInstanceStatus'
aws rds create-db-instance-read-replica --db-instance-identifier ttsora10c --source-db-instance-identifier ttsora10 --profile dba --db-instance-class db.r5.xlarge
```


# Appendix
Source Database Alert Log when creating a read replica:
```
('05/19/023 14:02:23', 'alter database force logging')
('05/19/023 14:02:23', 'ORA-12920 signalled during: alter database force logging...')
('05/19/023 14:02:23', 'alter database add standby logfile thread 1 size 134217728')
('05/19/023 14:02:23', 'Completed: alter database add standby logfile thread 1 size 134217728')
('05/19/023 14:02:23', 'alter database add standby logfile thread 1 size 134217728')
('05/19/023 14:02:24', 'Completed: alter database add standby logfile thread 1 size 134217728')
('05/19/023 14:02:24', 'alter database add standby logfile thread 1 size 134217728')
('05/19/023 14:02:24', 'Completed: alter database add standby logfile thread 1 size 134217728')
('05/19/023 14:02:25', 'alter database add standby logfile thread 1 size 134217728')
('05/19/023 14:02:25', 'Completed: alter database add standby logfile thread 1 size 134217728')
('05/19/023 14:02:25', 'alter database add standby logfile thread 1 size 134217728')
('05/19/023 14:02:25', 'Completed: alter database add standby logfile thread 1 size 134217728')
('05/19/023 14:02:26', "ALTER DATABASE CREATE STANDBY CONTROLFILE AS '/rdsdbdata/config/standby.ctl'")
('05/19/023 14:02:26', 'Clearing standby activation ID 3534873085 (0xd2b1e1fd)')
('05/19/023 14:02:26', 'The primary database controlfile was created using the')
('05/19/023 14:02:26', "'MAXLOGFILES 16' clause.")
('05/19/023 14:02:26', 'There is space for up to 12 standby redo logfiles')
('05/19/023 14:02:26', 'Use the following SQL commands on the standby database to create')
('05/19/023 14:02:26', 'standby redo logfiles that match the primary database:')
('05/19/023 14:02:26', "ALTER DATABASE ADD STANDBY LOGFILE 'srl1.f' SIZE 134217728;")
('05/19/023 14:02:26', "ALTER DATABASE ADD STANDBY LOGFILE 'srl2.f' SIZE 134217728;")
('05/19/023 14:02:26', "ALTER DATABASE ADD STANDBY LOGFILE 'srl3.f' SIZE 134217728;")
('05/19/023 14:02:26', "ALTER DATABASE ADD STANDBY LOGFILE 'srl4.f' SIZE 134217728;")
('05/19/023 14:02:26', "ALTER DATABASE ADD STANDBY LOGFILE 'srl5.f' SIZE 134217728;")
('05/19/023 14:02:26', 'WARNING: OMF is enabled on this database. Creating a physical ')
('05/19/023 14:02:26', 'standby controlfile, when OMF is enabled on the primary ')
('05/19/023 14:02:26', 'database, requires manual RMAN intervention to resolve OMF ')
('05/19/023 14:02:26', 'datafile pathnames.')
('05/19/023 14:02:26', 'NOTE: Please refer to the RMAN documentation for procedures ')
('05/19/023 14:02:26', 'describing how to manually resolve OMF datafile pathnames.')
('05/19/023 14:02:26', "Completed: ALTER DATABASE CREATE STANDBY CONTROLFILE AS '/rdsdbdata/config/standby.ctl'")
('05/19/023 14:02:26', '.... (PID:18003): REDO_TRANSPORT_USER changed to <RDS_DATAGUARD>')
('05/19/023 14:02:26', "ALTER SYSTEM SET redo_transport_user='RDS_DATAGUARD' SCOPE=BOTH;")
('05/19/023 14:02:26', 'Starting background process DMON')
('05/19/023 14:02:26', 'ALTER SYSTEM SET dg_broker_start=TRUE SCOPE=BOTH;')
('05/19/023 14:02:26', 'DMON started with pid=90, OS id=18013 ')
('05/19/023 14:02:29', 'Starting Data Guard Broker (DMON)')
('05/19/023 14:02:29', 'Starting background process INSV')
('05/19/023 14:02:29', 'INSV started with pid=91, OS id=18028 ')
('05/19/023 14:03:26', "alter database /*rds_sys_hm_util*/  backup controlfile to '/rdsdbdata/tmp/backup_control_file' reuse")
('05/19/023 14:03:26', "Completed: alter database /*rds_sys_hm_util*/  backup controlfile to '/rdsdbdata/tmp/backup_control_file' reuse")
('05/19/023 14:03:26', 'alter database /*rds_sys_hm_util*/  begin backup')
('05/19/023 14:03:26', 'Completed: alter database /*rds_sys_hm_util*/  begin backup')
('05/19/023 14:03:27', 'alter database /*rds_sys_hm_util*/  end backup')
('05/19/023 14:03:27', 'Completed: alter database /*rds_sys_hm_util*/  end backup')
('05/19/023 14:03:27', 'Thread 1 advanced to log sequence 1090405 (LGWR switch),  current SCN: 315707313')
('05/19/023 14:03:27', '  Current log# 1 seq# 1090405 mem# 0: /rdsdbdata/db/TTSORA10_A/onlinelog/o1_mf_1_j92p41s3_.log')
('05/19/023 14:03:27', 'ARC0 (PID:11679): Archived Log entry 1090716 added for T-1.S-1090404 ID 0xd2b1e1fd LAD:1')
('05/19/023 14:08:25', 'Thread 1 advanced to log sequence 1090406 (LGWR switch),  current SCN: 315709960')
('05/19/023 14:08:25', '  Current log# 2 seq# 1090406 mem# 0: /rdsdbdata/db/TTSORA10_A/onlinelog/o1_mf_2_j92p427g_.log')
('05/19/023 14:08:25', 'ARC1 (PID:14214): Archived Log entry 1090717 added for T-1.S-1090405 ID 0xd2b1e1fd LAD:1')
('05/19/023 14:08:55', 'Control autobackup written to DISK device')
('05/19/023 14:08:55', "handle '/rdsdbdata/userdirs/01/BACKUP-2021-11-26-14-31-13-c-3534888171-20230519-01'")
('05/19/023 14:11:43', "ALTER SYSTEM SET local_listener='(ADDRESS = (PROTOCOL = TCP)(HOST = 10.1.2.15)(PORT = 1521))','(ADDRESS = (PROTOCOL = TCP)(HOST = 172.31.0.216)(PORT = 1137))' SCOPE=BOTH;")
('05/19/023 14:12:05', 'Starting background process RSM0')
('05/19/023 14:12:05', 'RSM0 started with pid=92, OS id=22081 ')
('05/19/023 14:12:09', "ALTER SYSTEM SET fal_server='' SCOPE=BOTH;")
('05/19/023 14:12:44', "ALTER SYSTEM SET local_listener='(ADDRESS = (PROTOCOL = TCP)(HOST = 10.1.2.15)(PORT = 1521))','(ADDRESS = (PROTOCOL = TCP)(HOST = 172.31.0.216)(PORT = 1137))' SCOPE=BOTH;")
('05/19/023 14:13:25', 'Thread 1 advanced to log sequence 1090407 (LGWR switch),  current SCN: 315712443')
('05/19/023 14:13:25', '  Current log# 3 seq# 1090407 mem# 0: /rdsdbdata/db/TTSORA10_A/onlinelog/o1_mf_3_j92p42sn_.log')
('05/19/023 14:13:25', 'ARC2 (PID:3075): Archived Log entry 1090718 added for T-1.S-1090406 ID 0xd2b1e1fd LAD:1')
('05/19/023 14:13:56', 'Starting background process NSV2')
('05/19/023 14:13:56', 'NSV2 started with pid=93, OS id=23476 ')
('05/19/023 14:14:01', "Data Guard Broker executes SQL [alter system set log_archive_config='dg_config=(TTSORA10_A,TTSORA10_B)']")
('05/19/023 14:14:01', "ALTER SYSTEM SET log_archive_config='dg_config=(TTSORA10_A,TTSORA10_B)' SCOPE=BOTH;")
('05/19/023 14:14:11', 'RSM0 (PID:22081): Using STANDBY_ARCHIVE_DEST parameter default value as /rdsdbdata/db/TTSORA10_A/arch/redolog [krsd.c:18221]')
('05/19/023 14:14:11', 'ALTER SYSTEM SET log_archive_dest_2=\'service="ttsora10_b"\',\'ASYNC NOAFFIRM delay=0 optional compression=disable max_failure=0 reopen=300 db_unique_name="TTSORA10_B" net_timeout=30\',\'valid_for=(online_logfile,all_roles)\' SCOPE=BOTH;')
('05/19/023 14:14:11', "ALTER SYSTEM SET log_archive_dest_state_2='ENABLE' SCOPE=BOTH;")
('05/19/023 14:14:13', 'Thread 1 advanced to log sequence 1090408 (LGWR switch),  current SCN: 315712816')
('05/19/023 14:14:13', '  Current log# 4 seq# 1090408 mem# 0: /rdsdbdata/db/TTSORA10_A/onlinelog/o1_mf_4_j92p43t4_.log')
('05/19/023 14:14:13', 'ARC3 (PID:11694): Archived Log entry 1090722 added for T-1.S-1090407 ID 0xd2b1e1fd LAD:1')
('05/19/023 14:14:24', 'TT04 (PID:23589): Attempting LAD:2 network reconnect (3135)')
('05/19/023 14:14:24', 'TT04 (PID:23589): LAD:2 network reconnect abandoned')
('05/19/023 14:14:24', "TT04 (PID:23589): Error 3135 for LNO:4 to 'ttsora10_b'")
('05/19/023 14:14:26', "ALTER SYSTEM SET log_archive_dest_state_2='RESET' SCOPE=BOTH;")
('05/19/023 14:15:22', "ALTER SYSTEM SET log_archive_dest_state_2='ENABLE' SCOPE=BOTH;")
('05/19/023 14:15:22', 'Errors in file /rdsdbdata/log/diag/rdbms/ttsora10_a/TTSORA10/trace/TTSORA10_tt03_14172.trc:ORA-16047: DGID mismatch between destination setting and target database')
('05/19/023 14:15:22', "TT03 (PID:14172): krsg_check_connection: Error 16047 connecting to standby 'ttsora10_b'")
('05/19/023 14:15:22', 'Errors in file /rdsdbdata/log/diag/rdbms/ttsora10_a/TTSORA10/trace/TTSORA10_tt00_24138.trc:ORA-16047: DGID mismatch between destination setting and target database')
('05/19/023 14:15:22', "TT00 (PID:24138): Error 16047 for LNO:4 to 'ttsora10_b'")
('05/19/023 14:15:22', 'Errors in file /rdsdbdata/log/diag/rdbms/ttsora10_a/TTSORA10/trace/TTSORA10_tt00_24138.trc:ORA-16047: DGID mismatch between destination setting and target database')
('05/19/023 14:15:22', 'Errors in file /rdsdbdata/log/diag/rdbms/ttsora10_a/TTSORA10/trace/TTSORA10_tt00_24138.trc:ORA-16047: DGID mismatch between destination setting and target database')
('05/19/023 14:15:26', "ALTER SYSTEM SET log_archive_dest_state_2='ENABLE' SCOPE=BOTH;")
('05/19/023 14:15:26', 'Errors in file /rdsdbdata/log/diag/rdbms/ttsora10_a/TTSORA10/trace/TTSORA10_tt00_24138.trc:ORA-16047: DGID mismatch between destination setting and target database')
('05/19/023 14:15:26', "TT00 (PID:24138): Error 16047 for LNO:4 to 'ttsora10_b'")
('05/19/023 14:15:26', 'Errors in file /rdsdbdata/log/diag/rdbms/ttsora10_a/TTSORA10/trace/TTSORA10_tt00_24138.trc:ORA-16047: DGID mismatch between destination setting and target database')
('05/19/023 14:15:26', 'Errors in file /rdsdbdata/log/diag/rdbms/ttsora10_a/TTSORA10/trace/TTSORA10_tt00_24138.trc:ORA-16047: DGID mismatch between destination setting and target database')
('05/19/023 14:15:26', 'Errors in file /rdsdbdata/log/diag/rdbms/ttsora10_a/TTSORA10/trace/TTSORA10_tt03_14172.trc:ORA-16047: DGID mismatch between destination setting and target database')
('05/19/023 14:15:26', "TT03 (PID:14172): krsg_check_connection: Error 16047 connecting to standby 'ttsora10_b'")
('05/19/023 14:16:20', "ALTER SYSTEM SET local_listener='(ADDRESS = (PROTOCOL = TCP)(HOST = 10.1.2.15)(PORT = 1521))','(ADDRESS = (PROTOCOL = TCP)(HOST = 172.31.0.216)(PORT = 1137))' SCOPE=BOTH;")
('05/19/023 14:16:20', 'ALTER SYSTEM SET dg_broker_start=TRUE SCOPE=BOTH;')
('05/19/023 14:16:23', "ALTER SYSTEM SET log_archive_dest_state_2='ENABLE' SCOPE=BOTH;")
('05/19/023 14:16:23', "ALTER SYSTEM SET fal_server='' SCOPE=BOTH;")
('05/19/023 14:16:27', "ALTER SYSTEM SET log_archive_dest_state_2='ENABLE' SCOPE=BOTH;")
('05/19/023 14:17:08', "ALTER SYSTEM SET log_archive_dest_state_2='ENABLE' SCOPE=MEMORY SID='*';")
('05/19/023 14:18:30', 'TT00 (PID:24138): Attempting LAD:2 network reconnect (3135)')
('05/19/023 14:18:30', 'TT00 (PID:24138): LAD:2 network reconnect abandoned')
('05/19/023 14:18:30', 'Errors in file /rdsdbdata/log/diag/rdbms/ttsora10_a/TTSORA10/trace/TTSORA10_tt00_24138.trc:ORA-03135: connection lost contact')
('05/19/023 14:18:30', "TT00 (PID:24138): Error 3135 for LNO:4 to 'ttsora10_b'")
('05/19/023 14:18:30', 'Errors in file /rdsdbdata/log/diag/rdbms/ttsora10_a/TTSORA10/trace/TTSORA10_tt00_24138.trc:ORA-03135: connection lost contact')
('05/19/023 14:18:30', 'Errors in file /rdsdbdata/log/diag/rdbms/ttsora10_a/TTSORA10/trace/TTSORA10_tt00_24138.trc:ORA-03135: connection lost contact')
('05/19/023 14:18:33', "ALTER SYSTEM SET log_archive_dest_state_2='RESET' SCOPE=BOTH;")
('05/19/023 14:19:11', 'Thread 1 advanced to log sequence 1090409 (LGWR switch),  current SCN: 315715263')
('05/19/023 14:19:11', '  Current log# 1 seq# 1090409 mem# 0: /rdsdbdata/db/TTSORA10_A/onlinelog/o1_mf_1_j92p41s3_.log')
('05/19/023 14:19:11', 'ARC3 (PID:11694): Archived Log entry 1090724 added for T-1.S-1090408 ID 0xd2b1e1fd LAD:1')
('05/19/023 14:19:15', "ALTER SYSTEM SET log_archive_dest_state_2='ENABLE' SCOPE=BOTH;")
('05/19/023 14:19:15', 'Errors in file /rdsdbdata/log/diag/rdbms/ttsora10_a/TTSORA10/trace/TTSORA10_tt03_14172.trc:ORA-16047: DGID mismatch between destination setting and target database')
('05/19/023 14:19:15', "TT03 (PID:14172): krsg_check_connection: Error 16047 connecting to standby 'ttsora10_b'")
('05/19/023 14:19:15', 'Errors in file /rdsdbdata/log/diag/rdbms/ttsora10_a/TTSORA10/trace/TTSORA10_tt00_25516.trc:ORA-16047: DGID mismatch between destination setting and target database')
('05/19/023 14:19:15', "TT00 (PID:25516): Error 16047 for LNO:1 to 'ttsora10_b'")
('05/19/023 14:19:15', 'Errors in file /rdsdbdata/log/diag/rdbms/ttsora10_a/TTSORA10/trace/TTSORA10_tt00_25516.trc:ORA-16047: DGID mismatch between destination setting and target database')
('05/19/023 14:19:15', 'Errors in file /rdsdbdata/log/diag/rdbms/ttsora10_a/TTSORA10/trace/TTSORA10_tt00_25516.trc:ORA-16047: DGID mismatch between destination setting and target database')
('05/19/023 14:19:19', "ALTER SYSTEM SET log_archive_dest_state_2='ENABLE' SCOPE=BOTH;")
('05/19/023 14:19:19', 'Errors in file /rdsdbdata/log/diag/rdbms/ttsora10_a/TTSORA10/trace/TTSORA10_tt03_14172.trc:ORA-16047: DGID mismatch between destination setting and target database')
('05/19/023 14:19:19', "TT03 (PID:14172): krsg_check_connection: Error 16047 connecting to standby 'ttsora10_b'")
('05/19/023 14:19:19', 'Errors in file /rdsdbdata/log/diag/rdbms/ttsora10_a/TTSORA10/trace/TTSORA10_tt00_25516.trc:ORA-16047: DGID mismatch between destination setting and target database')
('05/19/023 14:19:19', "TT00 (PID:25516): Error 16047 for LNO:1 to 'ttsora10_b'")
('05/19/023 14:19:19', 'Errors in file /rdsdbdata/log/diag/rdbms/ttsora10_a/TTSORA10/trace/TTSORA10_tt00_25516.trc:ORA-16047: DGID mismatch between destination setting and target database')
('05/19/023 14:19:19', 'Errors in file /rdsdbdata/log/diag/rdbms/ttsora10_a/TTSORA10/trace/TTSORA10_tt00_25516.trc:ORA-16047: DGID mismatch between destination setting and target database')
```
Source Database Alert Log when removing a read replica:
```
('05/19/023 13:47:05', 'Process termination requested for pid 11981 [source = rdbms], [info = 2] [request issued by pid: 6156, uid: 3001]')
('05/19/023 13:47:06', 'RSM0 (PID:11460): Using STANDBY_ARCHIVE_DEST parameter default value as /rdsdbdata/db/TTSORA10_A/arch/redolog [krsd.c:18221]')
('05/19/023 13:47:06', "ALTER SYSTEM SET log_archive_dest_2='' SCOPE=BOTH;")
('05/19/023 13:47:06', "Data Guard Broker executes SQL [alter system set log_archive_config='dg_config=(TTSORA10_A)']")
('05/19/023 13:47:06', "ALTER SYSTEM SET log_archive_config='dg_config=(TTSORA10_A)' SCOPE=BOTH;")
('05/19/023 13:47:06', 'Starting background process NSV2')
('05/19/023 13:47:06', 'NSV2 started with pid=93, OS id=13195 ')
('05/19/023 13:47:40', 'RSM0: Killing process NSV2 (PID=13195)')
('05/19/023 13:48:36', 'DMON: NSV2 did not stop within 60 seconds, killing it now')
('05/19/023 13:48:36', 'Process termination requested for pid 13195 [source = rdbms], [info = 2] [request issued by pid: 6156, uid: 3001]')
('05/19/023 13:48:38', "ALTER SYSTEM SET local_listener='(ADDRESS = (PROTOCOL = TCP)(HOST = 10.1.2.15)(PORT = 1521))' SCOPE=BOTH;")
('05/19/023 13:48:41', 'Completed: Data Guard Broker shutdown')
('05/19/023 13:48:42', 'ALTER SYSTEM SET dg_broker_start=FALSE SCOPE=BOTH;')
('05/19/023 13:48:42', '.... (PID:13856): REDO_TRANSPORT_USER changed to < >')
('05/19/023 13:48:42', "ALTER SYSTEM SET redo_transport_user=' ' SCOPE=BOTH;")
('05/19/023 13:48:42', 'JIT: pid 13858 requesting full stop')
('05/19/023 13:48:42', 'alter database drop logfile group 6')
('05/19/023 13:48:42', 'Deleted Oracle managed file /rdsdbdata/db/TTSORA10_A/onlinelog/o1_mf_6_l6dvs3js_.log')
('05/19/023 13:48:42', 'Completed: alter database drop logfile group 6')
('05/19/023 13:48:43', 'alter database drop logfile group 8')
('05/19/023 13:48:43', 'Deleted Oracle managed file /rdsdbdata/db/TTSORA10_A/onlinelog/o1_mf_8_l6dvs4pv_.log')
('05/19/023 13:48:43', 'Completed: alter database drop logfile group 8')
('05/19/023 13:48:43', 'alter database drop logfile group 9')
('05/19/023 13:48:43', 'Deleted Oracle managed file /rdsdbdata/db/TTSORA10_A/onlinelog/o1_mf_9_l6dvs5gv_.log')
('05/19/023 13:48:43', 'Completed: alter database drop logfile group 9')
('05/19/023 13:48:43', 'alter database drop logfile group 5')
('05/19/023 13:48:43', 'Deleted Oracle managed file /rdsdbdata/db/TTSORA10_A/onlinelog/o1_mf_5_l6dvs314_.log')
('05/19/023 13:48:43', 'Completed: alter database drop logfile group 5')
('05/19/023 13:48:43', 'alter database drop logfile group 7')
('05/19/023 13:48:43', 'Deleted Oracle managed file /rdsdbdata/db/TTSORA10_A/onlinelog/o1_mf_7_l6dvs42c_.log')
('05/19/023 13:48:43', 'Completed: alter database drop logfile group 7')
('05/19/023 13:49:18', 'TMON (PID:11589): Process (PID:31138) hung on an I/O to LAD:2 after 256 seconds with threshold of 240 at [krsu.c:10192]')
('05/19/023 13:49:18', 'TMON (PID:11589): WARN: Terminating process hung on an operation (PID:31138)')
('05/19/023 13:49:22', 'TMON (PID:11589): Killing 1 processes (PIDS:31138) (Process by index) in order to remove hung processes. Requested by OS process 11589')
('05/19/023 13:49:22', 'Process termination requested for pid 31138 [source = rdbms], [info = 2] [request issued by pid: 11589, uid: 3001]')
('05/19/023 13:49:48', 'TT03 (PID:14172): Gap Manager starting')
('05/19/023 13:50:00', 'Thread 1 advanced to log sequence 1090402 (LGWR switch),  current SCN: 315700865')
('05/19/023 13:50:00', '  Current log# 2 seq# 1090402 mem# 0: /rdsdbdata/db/TTSORA10_A/onlinelog/o1_mf_2_j92p427g_.log')
('05/19/023 13:50:00', 'ARC1 (PID:14214): Archived Log entry 1090713 added for T-1.S-1090401 ID 0xd2b1e1fd LAD:1')
```

