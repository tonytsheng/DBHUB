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
- tail -f /var/log/aws-kinesis-agent/aws-kinesis-agent.log
debug
1 - stop agent, move files back in and start again
2 - remove and reinstall rpm, edit agent.json and start again
files could be read in /var/log/cadabra - dummy directory created for a lab
but not from /home/ec2-user/data

curl -XGET 'https://search-tts-os-300-tdlizichjv6yimvvoj4cnexaua.us-east-2.es.amazonaws.com/weblogs-*/_search?q=get' | jq

