# CXT - Getting Started on RDS for Oracle

# Backups
- You can do manual snaps and you also have auto snaps. Transaction log are backed up so you can do point in time recovery to around 5 minute samples.
- Auto backups are kept for only 35 days. Manual snaps are kept forever.
- If you delete a database with the CLI, be careful about including/excluding deleting the associated snaps. You probably want to keep the snaps just in case.
- Restoring a snap creates a new instance. There is no guarantee of endpoint names when you create or restore RDS instances [may require a change to clients/tnsnames/app layer/etc.]

# Patching
- The patching process includes a snapshot at the beginning of the work, applying the patch just like an opatch apply, updating the catalog and a snapshot at the end of the work. It is good practice to take your own snap right before you go into patching since that will decrease the time of that first snap. Snaps are essentially backing up dirty storage blocks, so the less dirty, the faster.
- RDS for Oracle is not friendly towards one-off patches. If you encounter this periodically, you may want to reconsider RDS for Oracle and instead self manage your database on EC2. Our internal teams are working to better support Oracle Spatial patches - please reach out if you are in this situation.
- Multi AZ vs Read Replicas
  - Multi-AZ configuration creates a standby kept in sync with the primary instance via storage replication. This standby is inaccessible and this is really a configuration for infrastructure failure.
  - Read Replicas are Data Guard under the covers, allowing you to have a read only instance. Data Guard ships the logs from the primary and applies them to the replica. Read replicas also allow you to do block checking on the logs which may be another tool for resiliency. Replicas can be promoted to be stand alone at any time. 
  - When Read Replicas are configured, the primary and replica databases must stay up and running. Be cognizant of running this configuration in Dev/Test since you cannot shut them down in off hours.
  - Both Multi-AZ and Read Replica configurations are easily done via the console or CLI, versus 18 pages of configuration instructions.
# Parameter and Option Groups
    * Parameters are done via parameter groups instead of modifying individual spfiles on the instance. Option groups are for adding specific database options to your instances.
    * In both cases, these groups can span numerous instances so take care of how you manage this. It takes a little getting used to. Parameter groups are also tied to snapshots.
* Instance sizing
    * The larger the instance shape, the higher the network bandwidth and IOPS capacity. Keep this in mind as you test your workloads. You can look at IOPS via Cloudwatch [which is the main service for thousands of metrics across all AWS services]. If your IOPS are plateaued, you may be hitting an instance versus a database limitation. See https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/ebs-optimized.html



