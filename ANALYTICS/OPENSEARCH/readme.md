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


## Create index explicitly
```
curl  -XPUT 'https://search-os100-r2nzbuvapidbpw36nzem54ma7q.us-east-2.es.amazonaws.com/c1/?pretty=true' -H 'Content-Type: application/json' -d @"c1.mapping"
c1.mapping:
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
      "format": "MM/dd/yyyy hh:mm:ss"
    }
  }
  }
}
```

# insert a doc
Note this matches the index built above especially for the metadata_generatedAt field
```
curl  -XPOST "https://search-os100-r2nzbuvapidbpw36nzem54ma7q.us-east-2.es.amazonaws.com/c1/_doc" -H 'Content-Type: application/json' -d '
 {"metadata_generatedAt": "10/18/2017 03:48:52",
  "metadata_recordGeneratedBy": "OBU",
  "metadata_logFileName": "rxMsg_1508341730_2001_470_11_456_226_adff_fe05_14b1.csv"
 }
'
```

## Bulk load from json file
```
curl  -H "Content-Type: application/json" -XPOST "https://search-os200-3upgw4tibkrffdnhn6irnvfwoa.us-east-2.es.amazonaws.com/_bulk" --data-binary @taylor2.json
# json must look like:
{"index" : { "_index" : "idxname", "_id" : 1000 }}
{json stuff}
{"index" : { "_index" : "idxname", "_id" : 1001 }}
{json stuff}
curl  -H "Content-Type: application/json" -XPOST "https://search-os200-3upgw4tibkrffdnhn6irnvfwoa.us-east-2.es.amazonaws.com/_bulk" --data-binary @taylor2.json

```
- idxname must be all lower case
- loader creates the index


## OpenSearch index specific queries
```
# return all data from index c2
curl -XGET "https://search-os100-r2nzbuvapidbpw36nzem54ma7q.us-east-2.es.amazonaws.com/c2/_search?pretty=true&q=*:*"

# see mapping of index
curl  -XGET "https://search-os100-r2nzbuvapidbpw36nzem54ma7q.us-east-2.es.amazonaws.com/c2/_mapping?pretty=true"

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

## Date specific queries
```
curl -XGET "https://search-os100-r2nzbuvapidbpw36nzem54ma7q.us-east-2.es.amazonaws.com/c1/_search?pretty=true" -H 'Content-Type: application/json' -d'
{
  "query": {
    "range": {
      "metadata_generatedAt": {
        "gte": "10/04/2024 03:00:00",
        "lte": "10/05/2024 12:00:00",
        "format": "MM/dd/yyyy HH:mm:ss",
        "relation" : "within"
      }
    }
  }
}'
```

## Working with date fields
- Create the index explicitly with the date field formatted 
- Load data either in bulk or interactively with the correct formatted date
- The issue is that OS can create the index with a string instead of a date
- In the OS dashboard, go to Stack Management..Index Patterns and create an index pattern on your collection. It should find the date field correctly.

## Delete Index
```
curl  -X DELETE "https://search-os200-3upgw4tibkrffdnhn6irnvfwoa.us-east-2.es.amazonaws.com/taylor2"
{"acknowledged":true}
```

## CLI
```
aws opensearch create-domain --domain-name mylogs --engine-version OpenSearch_2.11 --cluster-config  InstanceType=r6g.large.search,InstanceCount=2 --ebs-options EBSEnabled=true,VolumeType=gp3,VolumeSize=100,Iops=3500,Throughput=125 --access-policies '{"Version": "2012-10-17", "Statement": [{"Action": "es:*", "Principal":"*","Effect": "Allow", "Condition": {"IpAddress":{"aws:SourceIp":["3.143.249.228/32", "myip/32"]}}}]}'

aws opensearch describe-domains --domain-names os100 | jq ' .DomainStatusList[] | .ClusterConfig '
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

## Troubleshooting
- Enable logs
- Why is my cluster yellow
  - The primary shards for all indices are allocated to nodes in your cluster. However, one ore more replica shards aren't allocated to any of the nodes
  - List the unassigned shard:
```    
curl -XGET 'domain-endpoint/_cat/shards?h=index,shard,prirep,state,unassigned.reason' | grep UNASSIGNED
```
  - Get details for why
```
curl -XGET 'domain-endpoint/_cluster/allocation/explain?pretty' -H 'Content-Type:application/json' -d'{
     "index": "<index name>",
     "shard": <shardId>,
     "primary": <true or false>
}
```
- Not enough nodes to allocate to the shards
- Low disk space or disk skew
- High JVM memory pressure
  - Reduce JVM memory pressure first
- Tips to bring cluster back to green
  - Increase default shard retry value from 5 to higher
  - Deactivate and activate replica shard
  - Manually retry the unassigned shards
- "Message":"Request size exceeded 10485760 bytes"
  - Instance size too small - https://docs.aws.amazon.com/opensearch-service/latest/developerguide/limits.html
  - Maximum size of http request payloads - all t2/3s have 10MiB https payload limit

## Snapshots
create s3 bucket
create iam role
register a repository to keep the manual snapshots

curl -PUT "https://search-os100-r2nzbuvapidbpw36nzem54ma7q.us-east-2.es.amazonaws.com/_snapshot/os100.1"
'{
  "type": "s3",
  "settings": {
    "bucket": "ttsheng-os-snaps",
    "region": "us-east-2",
    "role_arn": "arn:aws:iam::070201068661:role/admin"
  }
}'

- take a snap
  - snaps not done from the console
curl -XGET 'domain-endpoint/_snapshot/_status'
curl -XPUT 'domain-endpoint/_snapshot/repository-name/snapshot-name'

- to restore a snap
  - identify the repository
    - curl -XGET 'domain-endpoint/_snapshot?pretty'
  - see all the snaps
    - curl -XGET 'domain-endpoint/_snapshot/repository-name/_all?pretty'
  - delete all the indexes
    -  curl -XDELETE 'domain-endpoint/_all'
  - or delete the single index
    - curl -XDELETE 'domain-endpoint/index-name'
  - restore
    - restore single index
    curl -XPOST 'domain-endpoint/_snapshot/cs-automated/2020-snapshot/_restore' \
-d '{"indices": "my-index"}' \
-H 'Content-Type: application/json'

   - restore all indexes except the dashboarrds and fgac indexes
curl -XPOST 'domain-endpoint/_snapshot/cs-automated/2020-snapshot/_restore' \
-d '{"indices": "-.kibana*,-.opendistro*"}' \
-H 'Content-Type: application/json'


## Misc
- JVM memory pressure
- JVM garbage collection
- JVM thread pool



