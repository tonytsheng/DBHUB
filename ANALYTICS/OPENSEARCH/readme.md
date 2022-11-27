create opensearch cluster
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


