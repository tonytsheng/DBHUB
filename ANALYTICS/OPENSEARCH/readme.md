## Configure Your Open Search cluster
- Enter domain name
- Select deployment type 
- Used version 1.3 
- auto tune enabled
- 1 az, 3 nodes
- ebs storage, gp3
- 10 mb ebs storage per node
- disable fine grained access control
- Can make cluster public
- Configure domain access policy
  - elements - allow your ip address 
  - Allow your EC2 instance to run curl, python, etc
  - Add your laptop to access the dashboards
    -       "aws:SourceIp": "3.143.249.228/32"
- Defaults for encryption options
- Create

## Changing access policy
- Cluster - Security configuration - Edit
- Change Deny to Allow

## Add another node
- Let it run through the Dry Run analysis
- If there are no errors, click Save and then cluster goes into Processing

## Create Kinesis Data Firehose Delivery Stream
See steps under ../KINESIS/readme.md for connecting KDFH to OpenSearch

## Log Generator

## OpenSearch health
```
curl -XGET "https://search-os110-c464qrmmf637vk7iy3jaijtzdq.us-east-2.es.amazonaws.com/_cluster/health?pretty=true"
curl -XGET "https://search-os110-c464qrmmf637vk7iy3jaijtzdq.us-east-2.es.amazonaws.com/_aliases?pretty=true"
curl -XGET "https://search-os110-c464qrmmf637vk7iy3jaijtzdq.us-east-2.es.amazonaws.com/_cat/indices?v"
```


## Create index
curl  -XPUT 'https://search-os100-r2nzbuvapidbpw36nzem54ma7q.us-east-2.es.amazonaws.com/c1/?pretty=true' -H 'Content-Type: application/json' -d @"c2.mapping"
c2.mapping:
{
  "settings": {
    "index": {
      "number_of_shards": 2,
      "number_of_replicas": 1
    }
  },
  "mappings": {
    "properties" : {
    "messageId": {
      "type": "text"
    },
    "metadata_generatedAt" : {
      "type" : "date",
      "format": ["MM/dd/YYYY hh:mm"]
    }
  }
  }
}


## OpenSearch index specific queries
```
# return all data from index c2
curl  -XGET "https://search-os100-r2nzbuvapidbpw36nzem54ma7q.us-east-2.es.amazonaws.com/c2/_search?pretty=true&q=*:*"
curl -XGET 'https://search-tts-os-300-tdlizichjv6yimvvoj4cnexaua.us-east-2.es.amazonaws.com/weblogs-*/_search?q=get' | jq
curl -XGET 'https://search-tts-os-300-tdlizichjv6yimvvoj4cnexaua.us-east-2.es.amazonaws.com/weblogs*/_search?q=host:80.127.116.96' | jq
curl -XGET 'https://search-tts-os-300-tdlizichjv6yimvvoj4cnexaua.us-east-2.es.amazonaws.com/weblogs*/_search?q=response:400' | jq
curl -XGET 'https://search-tts-os-300-tdlizichjv6yimvvoj4cnexaua.us-east-2.es.amazonaws.com/weblogs*/_count'
{"count":349276,"_shards":{"total":10,"successful":10,"skipped":0,"failed":0}}
curl -XGET 'https://search-tts-os-300-tdlizichjv6yimvvoj4cnexaua.us-east-2.es.amazonaws.com/_cat/indices/web*'
curl -XGET 'https://search-tts-os-300-tdlizichjv6yimvvoj4cnexaua.us-east-2.es.amazonaws.com/web*/_stats' | jq
curl -XPUT -u 'admin:Pass' \
  'https://search-ttsheng-opensearch-100-gxza6jvpr67ioemyyqqj7fkoxy.us-east-2.es.amazonaws.com/voicemail'
curl -XGET -u 'admin:Pass' \
  'https://search-ttsheng-opensearch-100-gxza6jvpr67ioemyyqqj7fkoxy.us-east-2.es.amazonaws.com/voicemail'
curl -XGET -u 'admin:Pass' \
  'https://search-ttsheng-opensearch-100-gxza6jvpr67ioemyyqqj7fkoxy.us-east-2.es.amazonaws.com/voicemail/_search?q-get'
curl -X DELETE -u 'admin:Pass' \
'https://search-ttsheng-opensearch-100-gxza6jvpr67ioemyyqqj7fkoxy.us-east-2.es.amazonaws.com/voicemail/'
#insert single doc
curl -XPOST 'https://search-os110-c464qrmmf637vk7iy3jaijtzdq.us-east-2.es.amazonaws.com/swift/_doc/1' -d '{"title":"test", "Album":"test","Lyric":"test"}'  -H 'Content-Type: application/json'
# count docs
curl -XGET "https://search-os110-c464qrmmf637vk7iy3jaijtzdq.us-east-2.es.amazonaws.com/swift/_count?pretty=true"
# query keyword
curl -XGET "https://search-os110-c464qrmmf637vk7iy3jaijtzdq.us-east-2.es.amazonaws.com/swift/_search?q=magic&pretty"
curl -XGET "https://search-os110-c464qrmmf637vk7iy3jaijtzdq.us-east-2.es.amazonaws.com/swift/_search?q=sad&pretty"


```

## Bulk load from json file
```
curl  -H "Content-Type: application/json" -XPOST "https://search-os200-3upgw4tibkrffdnhn6irnvfwoa.us-east-2.es.amazonaws.com/_bulk" --data-binary @taylor2.json
# json must look like:
{"index" : { "_index" : "idxname", "_id" : 1000 }}
{json stuff}
{"index" : { "_index" : "idxname", "_id" : 1001 }}
{json stuff}
```

- idxname must be all lower case
- loader creates the index


## Delete Index
```
curl  -X DELETE "https://search-os200-3upgw4tibkrffdnhn6irnvfwoa.us-east-2.es.amazonaws.com/taylor2"
{"acknowledged":true}
```

## CLI
```
aws opensearch create-domain --domain-name mylogs --engine-version OpenSearch_2.11 --cluster-config  InstanceType=r6g.large.search,InstanceCount=2 --ebs-options EBSEnabled=true,VolumeType=gp3,VolumeSize=100,Iops=3500,Throughput=125 --access-policies '{"Version": "2012-10-17", "Statement": [{"Action": "es:*", "Principal":"*","Effect": "Allow", "Condition": {"IpAddress":{"aws:SourceIp":["3.143.249.228/32", "myip/32"]}}}]}'
```

## Dashboard
Once your data has been loaded, create an index for the dashboard:
- go to your dashboard
- on the left, click Dashboards Management
- on the left, click Index Patterns
- enter your index pattern name, click Create Index pattern
- go back to Dashboard..Discover
- your index pattern that you just created should now show up in the dropdown in the left panel
After loading data [Swift, Airbnb] in bulk:
- Dashboards Management
  - Index patterns
    - Create index pattern


