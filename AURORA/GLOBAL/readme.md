- Aurora Global and Write Forwarding
  - https://docs.aws.amazon.com/AmazonRDS/latest/AuroraUserGuide/aurora-global-database-write-forwarding.html 
  - See what clusters are available
```
aws rds describe-db-clusters --query 'DBClusters[].[DatabaseName,Status]'
aws rds describe-db-clusters --query 'DBClusters[].DBClusterMembers[]'
```
  - In Console, Add Region
  - Check status using region in command
```
for region in us-east-2 ap-southeast-2
do
aws rds describe-db-clusters --query 'DBClusters[].DBClusterMembers[]' --region $region
done
```
