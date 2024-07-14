## DynamoDB - Kinesis - Redshift
Modified architecture from https://aws.amazon.com/blogs/big-data/near-real-time-analytics-using-amazon-redshift-streaming-ingestion-with-amazon-kinesis-data-streams-and-amazon-dynamodb/

1. Generate sample data.
We are generating sample flight data and then loading into a DDB table.
./1.gen_flight_data.bsh > outputfile

2. Load the data from the csv file into the DDB table.
python3 2.csv_load_flight.py <tablename> outputfile

3. 



