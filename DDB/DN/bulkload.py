import sys
import csv
import boto3

boto3.setup_default_session(profile_name='ec2')
dynamodb = boto3.resource('dynamodb')

tableName = 'DV1' # FIXME
filename = 'data.csv' # FIXME

def main():
    csvfile = open(filename)

    write_to_dynamo(csv.DictReader(csvfile))

    return print("Done")

def write_to_dynamo(rows):
    table = dynamodb.Table(tableName)
    with table.batch_writer() as batch:
        for row in rows:
            batch.put_item(
                Item={
                    'myHashKey': row['column_a'],
                    'myRangeKey': row['column_b'],
                    'myAttributes': {
                        'attributeA': row['column_c'],
                        'attributeB': row['column_d']
                    }
                }
            )

main()

