## RDS for Oracle HA/DR/Read Scalability Options
- Read Replicas
  - Use for read scalability - offload reads from primary database to a read replica.
  - DataGuard Switchover
    - You can also use Read Replicas as a high availability solution with DataGuard Switchover.
    - This feature allows you to reverse the roles between the primary database and one of its standby databases (replicas) with no data loss and a brief outage. Once a switchover is initiated, the primary database transitions to a standby role, and the standby database transitions to the primary role. 
    - Previously, you had to promote a Read Replica to a standalone database and then create a new replica.
    - You will need Oracle Database Enterprise Edition and an additional Oracle Active Data Guard license.
    - Read more at https://aws.amazon.com/about-aws/whats-new/2022/08/amazon-rds-oracle-supports-managed-oracle-data-guard-switchover-automated-backups-replicas/
- MultiAZ
  - Use for high availability within a single region, across multiple availability zones.
  - Failover is automatic, upon any issues with an availability zone and the database fails over to another availability zone. The database endpoint stays the same while the IP changes within DNS. 
  - Make sure you operatiionally test this with your full app stack.
    - You can issue a reboot with failover via the RDS Console or the AWS CLI.
  

