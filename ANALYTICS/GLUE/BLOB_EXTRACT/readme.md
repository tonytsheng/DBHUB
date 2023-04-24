## 
set up jdbc connection to source database
jdbc:oracle:thin:@localhost:1521:xe 
it looks like that
Add S3 VPC Gateway Endpoint:
https://stackoverflow.com/questions/55972886/could-not-find-s3-endpoint-or-nat-gateway-for-subnetid


view crawler logs in cloudwatch logs
```
[86aae15c-c28a-431f-9bb3-d4519e8f5b0b] ERROR : JDBC connection URL jdbc:oracle:thin:@:ttsora10.ciushqttrpqx.us-east-2.rds.amazonaws.com1521/ttsora10 is not supported. Check the Developer Guide for the list of supported data stores / URL formatting.
```

recreate the jdbc connection - wasn't quite right

