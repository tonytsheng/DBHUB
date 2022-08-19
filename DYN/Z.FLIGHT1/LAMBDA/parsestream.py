# example taken from Be A Better Dev
# https://gist.github.com/djg07/2bcf216822c9ab664d8286924776999f
# lambda function to read through DynamoDB Stream
# and pull out information for old vs new images for records that have been modified
# DDB table: flight
# "dep": { "S": "MEL" } 
# "arr": { "S": "MEL" } 
# "status": { "S": "scheduled" }
# "flight_number": { "S": "UK8218" }
# "flight_date": { "S": "2021-10-30"}


import json

print('Loading function')

def lambda_handler(event, context):
	print('------------------------')
	# print(event)
	#1. Iterate over each record
	try:
		for record in event['Records']:
			#2. Handle event by type
			if record['eventName'] == 'INSERT':
				handle_insert(record)
			elif record['eventName'] == 'MODIFY':
				handle_modify(record)
			elif record['eventName'] == 'REMOVE':
				handle_remove(record)
		print('------------------------')
		return "Success!"
	except Exception as e: 
		print(e)
		print('------------------------')
		return "Error"


def handle_insert(record):
	print("Handling INSERT Event")
	
	#3a. Get newImage content
	newImage = record['dynamodb']['NewImage']
	
	#3b. Parse values
	newPlayerId = newImage['playerId']['S']

	#3c. Print it
	print ('New row added with playerId=' + newPlayerId)

	print("Done handling INSERT Event")

def handle_modify(record):
	#print("Handling MODIFY Event")

	#3a. Parse oldImage and score
	oldImage = record['dynamodb']['OldImage']
	oldFlightNo = oldImage['flight_number']['S']
	oldFlightDate = oldImage['flight_date']['S']
	oldStatus = oldImage['status']['S']
	
	#3b. Parse oldImage and score
	newImage = record['dynamodb']['NewImage']
	newStatus = newImage['status']['S']

	#3c. Check for change
	if oldStatus != newStatus:
		print('Change for ' + str(oldFlightNo) + ' at ' + str(oldFlightDate) + ' : - oldStatus=' + str(oldStatus) + ', newStatus=' + str(newStatus))

	#print("Done handling MODIFY Event")

def handle_remove(record):
	print("Handling REMOVE Event")

	#3a. Parse oldImage
	oldImage = record['dynamodb']['OldImage']
	
	#3b. Parse values
	oldPlayerId = oldImage['playerId']['S']

	#3c. Print it
	print ('Row removed with playerId=' + oldPlayerId)

	print("Done handling REMOVE Event")

