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



