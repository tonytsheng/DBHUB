## DynamoDB - Kinesis - Redshift
Modified architecture from https://aws.amazon.com/blogs/big-data/near-real-time-analytics-using-amazon-redshift-streaming-ingestion-with-amazon-kinesis-data-streams-and-amazon-dynamodb/
0. Create the DynamoDB table.
0.flight.cr8table - this is an aws cli command

1. Generate sample data.
We are generating sample flight data and then loading into a DDB table.
./1.gen_flight_data.bsh > outputfile

2. Load the data from the csv file into the DDB table.
python3 2.csv_load_flight.py <tablename> outputfile

3. Create a Kinesis Data Stream

4. Turn on DynamoDB Streams to put items on the KDS that you just created.

5. Test with Ingest
Run your ingest process for a few minutes. Check the Monitoring tab on the stream to see if items are being put on the stream.

6. Set up streaming ingestion from Kinesis Data Streams
Redshift uses a materalized view which is updated directly from the stream when REFRESH is run.
```
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Sid": "ReadStream",
            "Effect": "Allow",
            "Action": [
                "kinesis:DescribeStreamSummary",
                "kinesis:GetShardIterator",
                "kinesis:GetRecords",
                "kinesis:DescribeStream"
            ],
            "Resource": "arn:aws:kinesis:*:0123456789:stream/*"
        },
        {
            "Sid": "ListStream",
            "Effect": "Allow",
            "Action": [
                "kinesis:ListStreams",
                "kinesis:ListShards"
            ],
            "Resource": "*"
        }
    ]
}
```
6. Add IAM role to Redshift cluster.
Or in my case, take existing IAM role and add Kinesis Admin to it.
Then add the IAM role to the Redshift cluster.

6. Login to Redshift cluster
```
psql "host=redshift-cluster-1.cst0cjwllvlj.us-east-2.redshift.amazonaws.com user=awsuser dbname=dev port=5439 password=Pass"
```

7. Create external schema
```
drop schema demo_schema;

CREATE EXTERNAL SCHEMA demo_schema
FROM KINESIS
IAM_ROLE 'arn:aws:iam::1234:role/ttsheng-redshift-etc' ;
```

8. Create MV
```
drop materialized view demo_stream_vw;

CREATE MATERIALIZED VIEW demo_stream_vw AS
    SELECT approximate_arrival_timestamp,
    partition_key,
    shard_id,
    sequence_number,
    json_parse(kinesis_data) as payload    
    FROM demo_schema."ddb-rs";


refresh materialized view demo_stream_vw;
INFO:  Materialized view demo_stream_vw was incrementally updated successfully.
REFRESH
-- you can also create a materialized view with auto refresh
```

9. Select count from the view. Select * from the view.
```
 approximate_arrival_timestamp |          partition_key           |       shard_id       |                     sequence_numbe
r                      |


                     payload



-------------------------------+----------------------------------+----------------------+-----------------------------------
-----------------------+-----------------------------------------------------------------------------------------------------
-----------------------------------------------------------------------------------------------------------------------------
-----------------------------------------------------------------------------------------------------------------------------
-----------------------------------------------------------------------------------------------------------------------------
-----------------------------------------------------------------------------------------------------------------------------
-----------------------------------------------------------------------------------------------------------------------------
-------------------------
 2024-07-15 02:39:26.136       | 68406A366BD60300C59F519142163A14 | shardId-000000000000 | 4965393457740317227003640323652322
9901717376203382325250 | {"awsRegion":"us-east-2","eventID":"f89436e0-627d-4d37-9879-42f86249aa83","eventName":"INSERT","user
Identity":null,"recordFormat":"application/json","tableName":"flight","dynamodb":{"ApproximateCreationDateTime":1721011165891
550,"Keys":{"flight_date":{"S":"2024-01-23 04:01:53"},"flight_number":{"S":" \"BA28\""}},"NewImage":{"arr":{"S":" \"TZX\""},"
flight_number":{"S":" \"BA28\""},"status":{"S":" \"CANCELLED\" "},"dep":{"S":" \"PEE\""},"flight_date":{"S":"2024-01-23 04:01
:53"}},"SizeBytes":137,"ApproximateCreationDateTimePrecision":"MICROSECOND"},"eventSource":"aws:dynamodb"}
 2024-07-15 02:39:26.137       | 3F434FB798726BE01C2AD3335E9F9B79 | shardId-000000000000 | 4965393457740317227003640323652564
7753356605461731737602 | {"awsRegion":"us-east-2","eventID":"3af8d9d2-5644-4f50-b8bf-2f2fbab3f9c2","eventName":"INSERT","user
Identity":null,"recordFormat":"application/json","tableName":"flight","dynamodb":{"ApproximateCreationDateTime":1721011165902
277,"Keys":{"flight_date":{"S":"2024-01-08 03:01:09"},"flight_number":{"S":" \"AS22\""}},"NewImage":{"arr":{"S":" \"YYT\""},"
flight_number":{"S":" \"AS22\""},"status":{"S":" \"DEPARTED\" "},"dep":{"S":" \"TYS\""},"flight_date":{"S":"2024-01-08 03:01:
09"}},"SizeBytes":136,"ApproximateCreationDateTimePrecision":"MICROSECOND"},"eventSource":"aws:dynamodb"}

dev=# select json_serialize (payload) from demo_stream_vw;


                                                                                                                      json_se
rialize



-----------------------------------------------------------------------------------------------------------------------------
-----------------------------------------------------------------------------------------------------------------------------
-----------------------------------------------------------------------------------------------------------------------------
-----------------------------------------------------------------------------------------------------------------------------
-----------------------------------------------------------------------------------------------------------------------------
-----------------------------------------------------------------------------------------------------------------------------
-
 {"awsRegion":"us-east-2","eventID":"f89436e0-627d-4d37-9879-42f86249aa83","eventName":"INSERT","userIdentity":null,"recordFo
rmat":"application/json","tableName":"flight","dynamodb":{"ApproximateCreationDateTime":1721011165891550,"Keys":{"flight_date
":{"S":"2024-01-23 04:01:53"},"flight_number":{"S":" \"BA28\""}},"NewImage":{"arr":{"S":" \"TZX\""},"flight_number":{"S":" \"
BA28\""},"status":{"S":" \"CANCELLED\" "},"dep":{"S":" \"PEE\""},"flight_date":{"S":"2024-01-23 04:01:53"}},"SizeBytes":137,"
ApproximateCreationDateTimePrecision":"MICROSECOND"},"eventSource":"aws:dynamodb"}
 {"awsRegion":"us-east-2","eventID":"3af8d9d2-5644-4f50-b8bf-2f2fbab3f9c2","eventName":"INSERT","userIdentity":null,"recordFo
rmat":"application/json","tableName":"flight","dynamodb":{"ApproximateCreationDateTime":1721011165902277,"Keys":{"flight_date
":{"S":"2024-01-08 03:01:09"},"flight_number":{"S":" \"AS22\""}},"NewImage":{"arr":{"S":" \"YYT\""},"flight_number":{"S":" \"
AS22\""},"status":{"S":" \"DEPARTED\" "},"dep":{"S":" \"TYS\""},"flight_date":{"S":"2024-01-08 03:01:09"}},"SizeBytes":136,"A
pproximateCreationDateTimePrecision":"MICROSECOND"},"eventSource":"aws:dynamodb"}
 {"awsRegion":"us-east-2","eventID":"75d273d4-86e9-4dd2-b0a6-e13885cfaf7e","eventName":"INSERT","userIdentity":null,"recordFo
rmat":"application/json","tableName":"flight","dynamodb":{"ApproximateCreationDateTime":1721011165912948,"Keys":{"flight_date
":{"S":"2024-01-19 05:01:49"},"flight_number":{"S":" \"AC31\""}},"NewImage":{"arr":{"S":" \"FRA\""},"flight_number":{"S":" \"
AC31\""},"status":{"S":" \"ARRIVED\" "},"dep":{"S":" \"NCL\""},"flight_date":{"S":"2024-01-19 05:01:49"}},"SizeBytes":135,"Ap
proximateCreationDateTimePrecision":"MICROSECOND"},"eventSource":"aws:dynamodb"}

dev=# select approximate_arrival_timestamp, "payload"."dynamodb" from demo_stream_vw;
approximate_arrival_timestamp |
                                                                                                                        dynamodb


-------------------------------+--------------------------------------------------------------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--------------------------------------
 2024-07-15 02:39:26.136       | {"ApproximateCreationDateTime":1721011165891550,"Keys":{"flight_date":{"S":"2024-01-23 04:01:53"},"flight_number":{"S":" \"BA28\""}},"NewImage":{
"arr":{"S":" \"TZX\""},"flight_number":{"S":" \"BA28\""},"status":{"S":" \"CANCELLED\" "},"dep":{"S":" \"PEE\""},"flight_date":{"S":"2024-01-23 04:01:53"}},"SizeBytes":137,"Appro
ximateCreationDateTimePrecision":"MICROSECOND"}
 2024-07-15 02:39:26.137       | {"ApproximateCreationDateTime":1721011165902277,"Keys":{"flight_date":{"S":"2024-01-08 03:01:09"},"flight_number":{"S":" \"AS22\""}},"NewImage":{
"arr":{"S":" \"YYT\""},"flight_number":{"S":" \"AS22\""},"status":{"S":" \"DEPARTED\" "},"dep":{"S":" \"TYS\""},"flight_date":{"S":"2024-01-08 03:01:09"}},"SizeBytes":136,"Approx
imateCreationDateTimePrecision":"MICROSECOND"}
 2024-07-15 02:39:26.137       | {"ApproximateCreationDateTime":1721011165912948,"Keys":{"flight_date":{"S":"2024-01-19 05:01:49"},"flight_number":{"S":" \"AC31\""}},"NewImage":{
"arr":{"S":" \"FRA\""},"flight_number":{"S":" \"AC31\""},"status":{"S":" \"ARRIVED\" "},"dep":{"S":" \"NCL\""},"flight_date":{"S":"2024-01-19 05:01:49"}},"SizeBytes":135,"Approxi
mateCreationDateTimePrecision":"MICROSECOND"}

```

10. Do whatever you want from the view into a real table.


