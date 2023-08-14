## Set up for Air Routes Demo

### Gremlin on an EC2 instance

1. Install the Gremlin console on your EC2 instance according to https://docs.aws.amazon.com/neptune/latest/userguide/access-graph-gremlin-console.html. Create the correct neptune-remote.yaml file in the conf directory.

2. Stage Air Route demo data into an S3 bucket

3. Create/start your Neptune cluster.  Ensure you have the appropriate IAM roles.

4. Load the Air Route data
```
curl -X POST \
    -H 'Content-Type: application/json' \
https://nep100.cluster-cyt4dgtj55oy.us-east-2.neptune.amazonaws.com:8182/loader -d ' ## your neptune cluster
    {
      "source" : "s3://ttsheng-nepload", ## your bucket
      "format" : "csv",
      "iamRoleArn" : "arn:aws:iam::012345678661:role/load-neptune-s3", ## your iam role arn
      "region" : "us-east-2",
      "failOnError" : "FALSE"
    }'
```

5. Test connectivity from your EC2 instance into your Neptune cluster

```
[ec2-user@ip-10-0-2-111 ~]$ cd rpms/apache-tinkerpop-gremlin-console-3.6.5/
[ec2-user@ip-10-0-2-111 apache-tinkerpop-gremlin-console-3.6.5]$ bin/gremlin.sh

         \,,,/
         (o o)
-----oOOo-(3)-oOOo-----
plugin activated: tinkerpop.server
plugin activated: tinkerpop.utilities
plugin activated: tinkerpop.tinkergraph
gremlin> :remote connect tinkerpop.server conf/neptune-remote.yaml
Aug 14, 2023 6:32:45 PM org.yaml.snakeyaml.internal.Logger warn
WARNING: Failed to find field for org.apache.tinkerpop.gremlin.driver.Settings.serializers
==>Configured nep100.cluster-cyt4dgtj55oy.us-east-2.neptune.amazonaws.com/10.0.2.198:8182
gremlin> :remote console
==>All scripts will now be sent to Gremlin Server - [nep100.cluster-cyt4dgtj55oy.us-east-2.neptune.amazonaws.com/10.0.2.198:8182] - type ':remote console' to return to local mode
gremlin> g.V().limit(1)
==>v[2357]
gremlin> g.V().has('code', 'ORD').valueMap(true)
==>{label=airport, country=[US], longest=[13000], code=[ORD], city=[Chicago], id=18, lon=[-87.90480042], type=[airport], elev=[672], icao=[KORD], region=[US-IL], runways=[7], lat=[41.97859955], desc=[Chicago O'Hare International Airport]}
gremlin> :exit
[ec2-user@ip-10-0-2-111 apache-tinkerpop-gremlin-console-3.6.5]$
```

TODO 6. Use the Neptune connector to enable Quicksight queries from your Graph database.

