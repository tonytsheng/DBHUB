## DynamoDB - Kinesis - Redshift
Modified architecture from https://aws.amazon.com/blogs/big-data/near-real-time-analytics-using-amazon-redshift-streaming-ingestion-with-amazon-kinesis-data-streams-and-amazon-dynamodb/
https://repost.aws/knowledge-center/redshift-lambda-function-queries

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

dev=# SET enable_case_sensitive_identifier to TRUE;
SET
##    ^ this makes all the json queries work
dev=# select * from demo_stream_vw;
 approximate_arrival_timestamp |          partition_key           |       shard_id       |                     sequence_number                      |

                                                                                                                                                             payload


-------------------------------+----------------------------------+----------------------+----------------------------------------------------------+---------------------------------
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------------------------------------------------------------------------------------
 2024-07-15 02:39:26.134       | 4EE2B8E33C393A826431B390D710B3EF | shardId-000000000000 | 49653934577403172270036403236522020975897761574207619074 | {"awsRegion":"us-east-2","eventI
D":"ca1b15ea-b223-49db-958c-ab8f900b0b9f","eventName":"INSERT","userIdentity":null,"recordFormat":"application/json","tableName":"flight","dynamodb":{"ApproximateCreationDateTime":17
21011165885218,"Keys":{"flight_date":{"S":"2024-01-05 05:01:04"},"flight_number":{"S":" \"WN20\""}},"NewImage":{"arr":{"S":" \"PER\""},"flight_number":{"S":" \"WN20\""},"status":{"S"
:" \"CANCELLED\" "},"dep":{"S":" \"KBP\""},"flight_date":{"S":"2024-01-05 05:01:04"}},"SizeBytes":137,"ApproximateCreationDateTimePrecision":"MICROSECOND"},"eventSource":"aws:dynamod
b"}
 2024-07-15 02:39:26.137       | 77D990333414AE35E391B1F5A7A32718 | shardId-000000000000 | 49653934577403172270036403236524438827536990832557031426 | {"awsRegion":"us-east-2","eventI
D":"1b0bf86f-97cb-4416-8f67-571ff86a78d5","eventName":"INSERT","userIdentity":null,"recordFormat":"application/json","tableName":"flight","dynamodb":{"ApproximateCreationDateTime":17
21011165896882,"Keys":{"flight_date":{"S":"2024-01-13 18:01:39"},"flight_number":{"S":" \"LH30\""}},"NewImage":{"arr":{"S":" \"CKG\""},"flight_number":{"S":" \"LH30\""},"status":{"S"
:" \"ARRIVED\" "},"dep":{"S":" \"CAG\""},"flight_date":{"S":"2024-01-13 18:01:39"}},"SizeBytes":135,"ApproximateCreationDateTimePrecision":"MICROSECOND"},"eventSource":"aws:dynamodb"
}
 2024-07-15 02:39:26.137       | B722F2FE551AF1D33D02C84AB2870B1C | shardId-000000000000 | 49653934577403172270036403236526856679176220090906443778 | {"awsRegion":"us-east-2","eventI
D":"841faaf4-36b7-448a-9314-5c1eeb3fcc82","eventName":"INSERT","userIdentity":null,"recordFormat":"application/json","tableName":"flight","dynamodb":{"ApproximateCreationDateTime":17
21011165907642,"Keys":{"flight_date":{"S":"2024-01-26 18:01:55"},"flight_number":{"S":" \"DL10\""}},"NewImage":{"arr":{"S":" \"OTP\""},"flight_number":{"S":" \"DL10\""},"status":{"S"
:" \"DEPARTED\" "},"dep":{"S":" \"SYZ\""},"flight_date":{"S":"2024-01-26 18:01:55"}},"SizeBytes":136,"ApproximateCreationDateTimePrecision":"MICROSECOND"},"eventSource":"aws:dynamodb
"}
dev=# select approximate_arrival_timestamp, payload."dynamodb"."Keys" from demo_stream_vw;
 approximate_arrival_timestamp |                                     Keys
-------------------------------+-------------------------------------------------------------------------------
 2024-07-15 02:39:26.134       | {"flight_date":{"S":"2024-01-05 05:01:04"},"flight_number":{"S":" \"WN20\""}}
 2024-07-15 02:39:26.137       | {"flight_date":{"S":"2024-01-13 18:01:39"},"flight_number":{"S":" \"LH30\""}}
 2024-07-15 02:39:26.137       | {"flight_date":{"S":"2024-01-26 18:01:55"},"flight_number":{"S":" \"DL10\""}}
 2024-07-15 02:39:26.137       | {"flight_date":{"S":"2024-01-11 23:01:59"},"flight_number":{"S":" \"NK28\""}}
 2024-07-15 02:39:26.137       | {"flight_date":{"S":"2024-01-01 03:01:33"},"flight_number":{"S":" \"B620\""}}
 2024-07-15 02:39:26.137       | {"flight_date":{"S":"2024-01-07 22:01:33"},"flight_number":{"S":" \"UA82\""}}
 2024-07-15 02:39:26.137       | {"flight_date":{"S":"2024-01-14 06:01:13"},"flight_number":{"S":" \"AC23\""}}
 2024-07-15 02:39:26.137       | {"flight_date":{"S":"2024-01-07 16:01:25"},"flight_number":{"S":" \"WN12\""}}
 2024-07-15 02:39:26.137       | {"flight_date":{"S":"2024-01-12 05:01:14"},"flight_number":{"S":" \"HA12\""}}

dev=# select approximate_arrival_timestamp, payload."dynamodb"."NewImage" from demo_stream_vw;
 approximate_arrival_timestamp |                                                                           NewImage

-------------------------------+------------------------------------------------------------------------------------------------------------------------------------------------------
--------
 2024-07-15 02:39:26.134       | {"arr":{"S":" \"PER\""},"flight_number":{"S":" \"WN20\""},"status":{"S":" \"CANCELLED\" "},"dep":{"S":" \"KBP\""},"flight_date":{"S":"2024-01-05 05:0
1:04"}}
 2024-07-15 02:39:26.137       | {"arr":{"S":" \"CKG\""},"flight_number":{"S":" \"LH30\""},"status":{"S":" \"ARRIVED\" "},"dep":{"S":" \"CAG\""},"flight_date":{"S":"2024-01-13 18:01:
39"}}
 2024-07-15 02:39:26.137       | {"arr":{"S":" \"OTP\""},"flight_number":{"S":" \"DL10\""},"status":{"S":" \"DEPARTED\" "},"dep":{"S":" \"SYZ\""},"flight_date":{"S":"2024-01-26 18:01
:55"}}
 2024-07-15 02:39:26.137       | {"arr":{"S":" \"BJV\""},"flight_number":{"S":" \"NK28\""},"status":{"S":" \"DELAYED\" "},"dep":{"S":" \"LPL\""},"flight_date":{"S":"2024-01-11 23:01:
59"}}
 2024-07-15 02:39:26.137       | {"arr":{"S":" \"BHM\""},"flight_number":{"S":" \"B620\""},"status":{"S":" \"ARRIVED\" "},"dep":{"S":" \"OAK\""},"flight_date":{"S":"2024-01-01 03:01:
33"}}

dev=# select payload , payload."dynamodb"."NewImage"."arr"."S"::varchar  from demo_stream_vw;


        payload

                       |   S
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-----------------------+--------
 {"awsRegion":"us-east-2","eventID":"f89436e0-627d-4d37-9879-42f86249aa83","eventName":"INSERT","userIdentity":null,"recordFormat":"application/json","tableName":"flight","dynamodb":
{"ApproximateCreationDateTime":1721011165891550,"Keys":{"flight_date":{"S":"2024-01-23 04:01:53"},"flight_number":{"S":" \"BA28\""}},"NewImage":{"arr":{"S":" \"TZX\""},"flight_number
":{"S":" \"BA28\""},"status":{"S":" \"CANCELLED\" "},"dep":{"S":" \"PEE\""},"flight_date":{"S":"2024-01-23 04:01:53"}},"SizeBytes":137,"ApproximateCreationDateTimePrecision":"MICROSE
COND"},"eventSource":"aws:dynamodb"}
                       |  "TZX"
 {"awsRegion":"us-east-2","eventID":"3af8d9d2-5644-4f50-b8bf-2f2fbab3f9c2","eventName":"INSERT","userIdentity":null,"recordFormat":"application/json","tableName":"flight","dynamodb":
{"ApproximateCreationDateTime":1721011165902277,"Keys":{"flight_date":{"S":"2024-01-08 03:01:09"},"flight_number":{"S":" \"AS22\""}},"NewImage":{"arr":{"S":" \"YYT\""},"flight_number
":{"S":" \"AS22\""},"status":{"S":" \"DEPARTED\" "},"dep":{"S":" \"TYS\""},"flight_date":{"S":"2024-01-08 03:01:09"}},"SizeBytes":136,"ApproximateCreationDateTimePrecision":"MICROSEC
OND"},"eventSource":"aws:dynamodb"}
                       |  "YYT"
dev=# select count(*), payload."dynamodb"."NewImage"."arr"."S"::varchar  
from demo_stream_vw 
group by payload."dynamodb"."NewImage"."arr"."S"::varchar 
order by payload."dynamodb"."NewImage"."arr"."S"::varchar ;
 count |   S
-------+--------
    41 |  "AAL"
    47 |  "ABQ"
    43 |  "ABV"
    37 |  "ABZ"
    51 |  "ACA"
    45 |  "ACC"
    47 |  "ADA"
    29 |  "ADB"
    40 |  "ADD"
    54 |  "ADL"
    39 |  "AER"
    37 |  "AFW"
    63 |  "AGP"
    49 |  "AGS"
    63 |  "AKL"
    42 |  "AKX"
    59 |  "ALA"
    57 |  "ALC"
    47 |  "ALG"
    46 |  "AMA"
    53 |  "AMM"
    51 |  "AMS"
    38 |  "ANC"
    42 |  "ARN"
    49 |  "ASB"
    47 |  "ATA"
    45 |  "ATH"
    43 |  "ATL"
    36 |  "ATQ"

dev=# select distinct date_part(day, approximate_arrival_timestamp) from demo_stream_vw;
 pgdate_part
-------------
          15
          16
(2 rows)

-- Used Redshift Q to generate this query as a template
SELECT
  EXTRACT(
    HOUR
    FROM
      arrival_ts
  ) AS hour,
  arr,
  COUNT(*) AS count
FROM
  public.airflight
GROUP BY
  hour,
  arr

SELECT
  EXTRACT( HOUR FROM approximate_arrival_timestamp) AS hour
  , payload."dynamodb"."NewImage"."arr"."S"::varchar as arrival
  , COUNT(*) AS count
FROM
  demo_stream_vw
GROUP BY
  hour
  , arrival
ORDER BY
  hour
  , arrival;
-- put this into a stored proc that runs once an hour
```
10. Do whatever you want from the view into a real table.


