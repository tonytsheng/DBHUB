## Connecting KDFH to OpenSearch
- Source - direct put
- Destination - open search
- Modify the stream name
- Enable data transformation - browse lambda function for apache logs to opensearch
- Choose opensearch service domain
- Specify index name and used a day for index rotation
- Specify an S3 bucket with prefix for bad data
- Edit /etc/aws-kinesis/agent.json
  - See agent.json.opensearch
  - Note that the kdfh stream (kdfh-400) was built with a lambda function to convert apache logs to opensearch - this was done in the console
  - Start/stop the kinesis agent and watch the logs:
- ```sudo service aws-kinesis-agent start|stop|status```
- ```tail -f /var/log/aws-kinesis-agent/aws-kinesis-agent.log```

