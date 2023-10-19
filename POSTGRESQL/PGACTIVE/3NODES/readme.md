## Create databases
Create 3 databases. Make sure to specify your appropriate:
- database instance identifier 
- db-subnet-group-name
- region
- availability zone
- password
```
aws rds create-db-instance  --db-name app  --db-instance-identifier pg1001  --allocated-storage 50  --db-instance-class db.m5d.large --engine postgres  --master-username postgres --master-user-password Pass  --db-subnet-group-name default-vpc-0467e5c237261df36  --availability-zone us-east-2b  --engine-version  15.4  --publicly-accessible   --enable-cloudwatch-logs-exports  postgresql  --profile ec2  --region us-east-2

aws rds create-db-instance  --db-name app  --db-instance-identifier pg1002  --allocated-storage 50  --db-instance-class db.m5d.large --engine postgres  --master-username postgres --master-user-password Pass  --db-subnet-group-name default-vpc-0467e5c237261df36  --availability-zone us-east-2b  --engine-version  15.4  --publicly-accessible   --enable-cloudwatch-logs-exports  postgresql  --profile ec2  --region us-east-2

aws rds create-db-instance  --db-name app  --db-instance-identifier pg1003  --allocated-storage 50  --db-instance-class db.m5d.large --engine postgres  --master-username postgres --master-user-password Pass  --db-subnet-group-name default-vpc-0467e5c237261df36  --availability-zone us-east-2b  --engine-version  15.4  --publicly-accessible   --enable-cloudwatch-logs-exports  postgresql  --profile ec2  --region us-east-2
```

## Create a new parameter group and change the two parameters
aws rds create-db-parameter-group --db-parameter-group-name pg15-pgactive --db-parameter-group-family postgres15 --description "Parameter group that contains pgactive settings for PostgreSQL 15" --region us-east-2 --profile ec2

aws rds modify-db-parameter-group --db-parameter-group-name pg15-pgactive --parameters '[{"ParameterName": "rds.enable_pgactive","ParameterValue": "1","ApplyMethod": "pending-reboot"},{"ParameterName": "rds.custom_dns_resolution","ParameterValue": "1","ApplyMethod": "pending-reboot"}]' --region us-east-2 --profile ec2

aws rds modify-db-instance --db-instance-identifier pg1001 --db-parameter-group-name pg15-pgactive --profile ec2
aws rds modify-db-instance --db-instance-identifier pg1002 --db-parameter-group-name pg15-pgactive --profile ec2
aws rds modify-db-instance --db-instance-identifier pg1003 --db-parameter-group-name pg15-pgactive --profile ec2

aws rds reboot-db-instance --db-instance-identifier pg1001 --profile ec2
aws rds reboot-db-instance --db-instance-identifier pg1002 --profile ec2
aws rds reboot-db-instance --db-instance-identifier pg1003 --profile ec2

## Create application tables on all 3 nodes
Run the 0.nodeall_ddl.sql sql script on all 3 nodes. This creates an application table for testing and creates the pgactive extension.
Do not create the schema or the application objects on nodes 2 and 3.

## Create the pgactive server groups on all 3 nodes, one at a time.
Run the following scripts per node:
On Node 1: 1.node1.cr8server_mapping.sql
On Node 2: 1.node2.cr8server_mapping.sql
On Node 3: 1.node3.cr8server_mapping.sql



