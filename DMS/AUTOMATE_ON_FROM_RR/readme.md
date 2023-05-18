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
- Even though the source database goes into Modifying status, transactions still appear to work fine.
- Promotion of the RR looks like this:
  - Modifying
  - Rebooting
  - Backing-up



decribe db instances
'ReadReplicaDBInstanceIdentifiers': [],
'ReadReplicaSourceDBInstanceIdentifier': 'ttsora10',

