## Testing MultiAZ failover 

- In order to test this, we want to watch 3 things:
  - The IP address of the database endpoint
  - The status of the RDS instance
  - Whether a database client can connect to the database
- The python script checks for these three things and you can run this in a simple bash shell script loop.
- Testing the RDS instance failover is executed via the RDS Console or issuing the aws cli command: 
```
aws rds reboot-db-instance --db-instance-identifier ttsora30 --force-failover
```
