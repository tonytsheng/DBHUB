## Connecting KDFH to OpenSearch
- Source - direct put
- Destination - open search
- Modify the stream name
- Enable data transformation - browse lambda function for apache logs to opensearch
- Choose opensearch service domain
- Specify index name and used a day for index rotation
- Specify an S3 bucket with prefix for bad data

## On your EC2 instance
- Edit /etc/aws-kinesis/agent.json
  - See agent.json
- ```sudo service aws-kinesis-agent start|stop|status```
- ```tail -f /var/log/aws-kinesis-agent/aws-kinesis-agent.log```

