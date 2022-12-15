## Create Connection
- jdbc url:
  - jdbc:oracle:thin:@:ttsora10.ciushqttrpqx.us-east-2.rds.amazonaws.com1521/ttsora10

## Glue Crawler : S3
- Generate data and put it into an S3 bucket 
  - Use LogGenerator and the Kinesis Data Firehose stream to send to an S3 bucket
- Set up the crawler to crawl the bucket
  - ttsheng-kinesis-demo
    - partitioned by month, day, hour : 12/15/14
- Edit the columns since there is no header row
  - Fill in the appropriate partition keys
- Should be auto filled when you return back to Athena

