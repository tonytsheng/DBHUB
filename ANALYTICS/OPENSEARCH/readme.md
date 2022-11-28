## Configure Your Open Search cluster
domain name
deployment type - dev/test
version - used 1.3
auto tune enabled
1 az
3 nodes
ebs storage
gp3
10 mb ebs storage per node
disable fine grained access control
domain access policy - configure
elements - my ip address - allow
[allow the ip from your workstation and your dbhub ec2 instance]
encryption - defaults
create

create kinesis data firehose delivery stream
source - direct put
destination - open search
stream name
enable data transformation - browse lambda function for apache logs to opensearch
choose opensearch service domain
index, index rotation
s3 bucket for failed data

edit /etc/aws-kinesis/agent.json
tail -f /var/log/aws-kinesis-agent/aws-kinesis-agent.log
debug
1 - stop agent, move files back in and start again
2 - remove and reinstall rpm, edit agent.json and start again
files could be read in /var/log/cadabra - dummy directory created for a lab
but not from /home/ec2-user/data

curl -XGET 'https://search-tts-os-300-tdlizichjv6yimvvoj4cnexaua.us-east-2.es.amazonaws.com/weblogs-*/_search?q=get' | jq

