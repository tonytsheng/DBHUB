import boto3dynamodb = boto3.client('dynamodb')
response = dynamodb.update_item(    TableName='siteVisits',     
        Key={'siteUrl':{'S': "https://www.linuxacademy.com/"}},    
        UpdateExpression='SET visits = visits + :inc',    
        ExpressionAttributeValues={':inc': {'N': '1'}    },    
        ReturnValues="UPDATED_NEW")print("UPDATING ITEM")print(response)
