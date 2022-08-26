## RDS for Oracle HA/DR/Read Scalability Options
- Read Replicas
  - Use for read scalability - offload reads from primary database to a read replica
- MultiAZ
  - Use for high availability within a single region, across multiple availability zones
  - Failover is automatic, database endpoint changes in DNS
  - Make sure you operatiionally test this with your full app stack 
    - Reboot with failover via the RDS Console or CLI command
- DataGuard switchover
  - Use when you want to offload reads from the primary database
  - One click failover that changes read replica to primary and primary to read replica
  - Database endpoints do change so your application will need to be restarted.

