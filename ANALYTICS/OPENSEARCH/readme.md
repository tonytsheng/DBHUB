## Configure Your Open Search cluster
- Enter domain name
- Select deployment type 
- Used version 1.3 
- auto tune enabled
- 1 az, 3 nodes
- ebs storage, gp3
- 10 mb ebs storage per node
- disable fine grained access control
- Configure domain access policy
  - elements - allow your ip address 
  - Allow any IPs, including from your EC2 instance for example
- Defaults for encryption options
- Create

## Create Kinesis Data Firehose Delivery Stream
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

## Log Generator

## OpenSearch cli queries
```
curl -XGET 'https://search-tts-os-300-tdlizichjv6yimvvoj4cnexaua.us-east-2.es.amazonaws.com/weblogs-*/_search?q=get' | jq
curl -XGET 'https://search-tts-os-300-tdlizichjv6yimvvoj4cnexaua.us-east-2.es.amazonaws.com/weblogs*/_search?q=host:80.127.116.96' | jq
curl -XGET 'https://search-tts-os-300-tdlizichjv6yimvvoj4cnexaua.us-east-2.es.amazonaws.com/weblogs*/_search?q=response:400' | jq
curl -XGET 'https://search-tts-os-300-tdlizichjv6yimvvoj4cnexaua.us-east-2.es.amazonaws.com/weblogs*/_count'
{"count":349276,"_shards":{"total":10,"successful":10,"skipped":0,"failed":0}}

curl -XGET 'https://search-tts-os-300-tdlizichjv6yimvvoj4cnexaua.us-east-2.es.amazonaws.com/_cat/indices/web*'
curl -XGET 'https://search-tts-os-300-tdlizichjv6yimvvoj4cnexaua.us-east-2.es.amazonaws.com/web*/_stats' | jq
```

## Dashboard

Once your data has been loaded with KDFH:
- go to your dashboard
- on the left, click Stack Management
- on the left, click Index Patterns
- enter your index pattern name, click Create Index pattern
- go back to Dashboard..Discover
- your index pattern that you just created should now show up in the dropdown in the left panel


