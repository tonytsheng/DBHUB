# Automating Turning on a DMS Migration Task After Promoting a Read Replica
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
- Create and start DMS migration task starting at the SCN.

# Misc
- Even though the source database goes into Modifying status when creating or deleting an associated Read Replica, transactions still appear to work fine.
- Promotion of the RR to a standalone database looks like this:
  - Modifying
  - Rebooting
  - Backing-up

# Utilities
```
aws rds delete-db-instance --db-instance-identifier ttsora10-rr  --profile dba --skip-final-snapshot
aws rds create-db-instance-read-replicaa --db-instance-identifier ttsora10c --source-db-instance-identifier ttsora10 --profile dba --db-instance-class db.r5.xlarge
```


# Appendix
Source Database Alert Log entries when remove a read replica:
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

