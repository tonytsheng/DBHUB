import botocore
import boto3
import json
 
print('Loading function')
rds_client = boto3.client('rds')
 
#def lambda_handler(event, context):
print("Received event: " + json.dumps(event, indent=2))
try:
    print("Version is {}".format(botocore.__version__))        
         
    instances = rds_client.describe_db_instances()
    clusters_to_start = [instance["DBClusterIdentifier"] for instance in instances]
 
    for name in clusters_to_start:
        print('Starting instance: ' + name)
#          rds_client.start_db_cluster(DBClusterIdentifier=name)    
         
#    return True
except Exception as e:
    print(e)
    print('Error starting rds clusters.')
    raise e

