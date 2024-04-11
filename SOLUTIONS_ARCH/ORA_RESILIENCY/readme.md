aws rds delete-db-instance --db-instance-identifier ttsora10-rr  --profile dba --skip-final-snapshot
aws rds describe-db-instances --profile dba | jq ' .DBInstances[]|  .DBInstanceIdentifier, .DBInstanceStatus'
aws rds create-db-instance-read-replica --db-instance-identifier ttsora10c --source-db-instance-identifier ttsora10 --profile dba --db-instance-class db.r5.xlarge

aws rds reboot-db-instance --db-instance-identifier ttsora10 --profile dba --force-failover

nslookup ttsora10.ciushqttrpqx.us-east-2.rds.amazonaws.com | grep -v '#' | grep Address | awk -F':' '{print $2}' | sed 's/ //g'^


