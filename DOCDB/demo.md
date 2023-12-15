## Console
- Create
  - create instance based cluster with just primary instance
  - add replica
  - show endpoints 
- Best practice 
  - connect your apps to cluster endpoint
  - if there is a failure, cluster endpoint fails over appropriately

- Managed Service
  - Snapshots
  - Encryption
  - Parameter Groups
    - audit_logs, profiler, tls, change_stream_log_retention_duration
  - Performance Insights
  - Log Exports - sidebar for CW
  - Maint Window
    - versions - 2023:
      - 12/13, 11/29, 11/21, 11/17, 11/6, 10/20, 9/25, 9/20, 9/15, 9/11, 8/3, 7/13, 6/7 

- Failover
  - Each replica is assoc with a failover tier. When a failover occurs, primary instance fails over to replica with highest priority. If multiple replicas have same priority, primary fails over to tiers replica that is closest in size.
  - If you have an Amazon DocumentDB replica instance in the same or different Availability Zone when failing over: Amazon DocumentDB flips the canonical name record (CNAME) for your instance to point at the healthy replica, which is, in turn, promoted to become the new primary. Failover typically completes within 30 seconds from start to finish.
  - If you don't have an Amazon DocumentDB replica instance (for example, a single instance cluster): Amazon DocumentDB will attempt to create a new instance in the same Availability Zone as the original instance. This replacement of the original instance is done on a best-effort basis and may not succeed if, for example, there is an issue that is broadly affecting the Availability Zone.

- Endpoints
  - The cluster endpoint connects to your cluster’s current primary instance. The cluster endpoint can be used for read and write operations. An Amazon DocumentDB cluster has exactly one cluster endpoint.

  - The cluster endpoint provides failover support for read and write connections to the cluster. If your cluster’s current primary instance fails, and your cluster has at least one active read replica, the cluster endpoint automatically redirects connection requests to a new primary instance.

  - Using the cluster endpoint, you can connect to your cluster in replica set mode. You can then use the built-in read preference driver capabilities. In the following example, specifying /?replicaSet=rs0 signifies to the SDK that you want to connect as a replica set. If you omit /?replicaSet=rs0', the client routes all requests to the cluster endpoint, that is, your primary instance.

  - The advantage of connecting as a replica set is that it enables your SDK to discover the cluster topography automatically, including when instances are added or removed from the cluster. You can then use your cluster more efficiently by routing read requests to your replica instances.


- Performance
  - Performance Insights
  - CW
  - Explain plans *
db.runCommand({explain:
  { db.listings2.find({country_code: "USA"}) }
})

- Migration
  - Native
  - DMS *
create user
limitations for docdb 
 - document vs table mode - drop down when you create the source endpoint
 - To use ongoing replication or CDC with Amazon DocumentDB, AWS DMS requires access to the Amazon DocumentDB cluster's change streams
  - Create indexes first before migrating the data.

- Best Practices
  - Deploy a cluster consisting of two more more instances in two AZs.
    - For Production, three more instances across three AZs.



