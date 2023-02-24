- Aurora Global and Write Forwarding
  - https://docs.aws.amazon.com/AmazonRDS/latest/AuroraUserGuide/aurora-global-database-write-forwarding.html 
  - List engines available for aurora-mysql - note global write forwarding is only available for mysql
```
aws rds describe-db-engine-versions --engine aurora-mysql  --query 'DBEngineVersions[].ValidUpgradeTarget[].[Engine,EngineVersion]'
```
  - Create overall global database
```
aws rds create-global-cluster --global-cluster-identifier aurg-mysql-100 \
  --engine aurora-mysql --engine-version 8.0.mysql_aurora.3.02.2 --region us-east-2
```
  - Create primary cluster in same region as the global database
```
aws rds create-db-cluster --global-cluster-identifier aurg-mysql-100 \
  --db-cluster-identifier  aurg-mysql-100-us-e2 \
  --engine aurora-mysql --engine-version 8.0.mysql_aurora.3.02.2  \
  --master-username admin --master-user-password pw \
  --region us-east-2

aws rds create-db-instance --db-cluster-identifier aurg-mysql-100-us-e2 \
  --db-instance-identifier aurg-mysql-100-us-e2-100 \
  --db-instance-class db.r5.large \
  --engine aurora-mysql --engine-version 8.0.mysql_aurora.3.02.2 \
  --region us-east-2

aws rds create-db-instance --db-cluster-identifier aurg-mysql-100-us-e2 \
  --db-instance-identifier aurg-mysql-100-us-e2-200 \
  --db-instance-class db.r5.large \
  --engine aurora-mysql --engine-version 8.0.mysql_aurora.3.02.2 \
  --region us-east-2
```
  - Create the secondary cluster in a different region than the global database,
    with write forwarding enabled.
aws rds create-db-cluster --global-cluster-identifier aurg-mysql-100 \
  --db-cluster-identifier  aurg-mysql-100-ap-se2 \
  --engine aurora-mysql --engine-version 8.0.mysql_aurora.3.02.2  \
  --region ap-southeast-2

aws rds create-db-instance --db-cluster-identifier aurg-mysql-100-ap-se2 \
  --db-instance-identifier aurg-mysql-100-ap-se2-200 \
  --db-instance-class db.r5.large \
  --engine aurora-mysql --engine-version 8.0.mysql_aurora.3.02.2 \
  --region ap-southeast-2

```
  - Note there is no user credentials when creating this secondary cluster
  - The first instance you create in the cluster is the writer.
  - All subsequent ones will be readers.
- Reminder - remove a node from the region that it is in.
  - Console may get a little confused based on global vs regions.
