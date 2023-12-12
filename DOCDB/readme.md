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

## Monitoring

## Migration

## 

## References
- https://catalog.us-east-1.prod.workshops.aws/workshops/464d6c17-9faa-4fef-ac9f-dd49610174d3/en-US/introduction/querycluster/performcrudoperations
- https://aws.amazon.com/blogs/big-data/visualize-mongodb-data-from-amazon-quicksight-using-amazon-athena-federated-query/
- https://docs.aws.amazon.com/documentdb/latest/developerguide/elastic-how-it-works.html
- https://docs.aws.amazon.com/documentdb/latest/developerguide/role_based_access_control.html

