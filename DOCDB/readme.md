## DocumentDB

cannot use 'admin' as a username since it is a reserved word.
instead use docadmin

- Connecting
1. See all the code in the console.
  - Download the correct pem file.
  - Use the mongo command.
```
mongo --ssl --host docdb100.cyt4dgtj55oy.us-east-2.docdb.amazonaws.com:27017 --sslCAFile /home/ec2-user/ssl/global-bundle.pem --username docadmin --password Pass
```


## Scaling
- no sharding for instance based clusters - one primary
- sharding for elastic clusters - see concepts from Aurora Limitless like request router
  - how does it handle isolation levels?

## Monitoring
- query stats/explain plans

## Migration
- dms
- mongo native tools
- 
## Consistency
- isolation
  - Reads from an Amazon DocumentDB instance only return data that is durable before the query begins. Reads never return data modified after the query begins execution nor are dirty reads possible under any circumstances.
  - Reads from an Amazon DocumentDB cluster’s primary instance are strongly consistent under normal operating conditions and have read-after-write consistency. If a failover event occurs between the write and subsequent read, the system can briefly return a read that is not strongly consistent. All reads from a read replica are eventually consistent and return the data in the same order, and often with less than 100 ms replica lag.
    - primary - strongly consistent
    - read replica - eventually consistent

## References
- https://catalog.us-east-1.prod.workshops.aws/workshops/464d6c17-9faa-4fef-ac9f-dd49610174d3/en-US/introduction/querycluster/performcrudoperations
- https://aws.amazon.com/blogs/big-data/visualize-mongodb-data-from-amazon-quicksight-using-amazon-athena-federated-query/
- https://docs.aws.amazon.com/documentdb/latest/developerguide/elastic-how-it-works.html
- https://docs.aws.amazon.com/documentdb/latest/developerguide/role_based_access_control.html
- https://aws.amazon.com/blogs/database/perform-a-live-migration-from-a-sharded-document-database-cluster-to-amazon-documentdb/
- https://docs.aws.amazon.com/documentdb/latest/developerguide/how-it-works.html#how-it-works.replication


