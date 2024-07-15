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

6. Add IAM role to Redshift cluster.
Or in my case, take existing IAM role and add Kinesis Admin to it.
Then add the IAM role to the Redshift cluster.

6. Login to Redshift cluster
```psql "host=redshift-cluster-1.cst0cjwllvlj.us-east-2.redshift.amazonaws.com user=awsuser dbname=dev port=5439 password=Pass"
```

7. Create external schema
drop schema demo_schema;

CREATE EXTERNAL SCHEMA demo_schema
FROM KINESIS
IAM_ROLE 'arn:aws:iam::1234:role/ttsheng-redshift-etc' ;



8. Create MV
drop materialized view demo_stream_vw;

CREATE MATERIALIZED VIEW demo_stream_vw AS
    SELECT approximate_arrival_timestamp,
    partition_key,
    shard_id,
    sequence_number,
    json_parse(kinesis_data) as payload    
    FROM demo_schema."ddb-rs";


refresh materialized view demo_stream_vw;


