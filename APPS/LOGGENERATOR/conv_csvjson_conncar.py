## convert a csv file to json
## specific for bulk load for open search
## consider this a template

import csv
import json

INFILE="/home/ec2-user/data/ConnectedVehicle/Wyo.csv"
OUTFILE="file.json"

# change in and out file

csvfile = open(INFILE, 'r')

jsonfile = open(OUTFILE, 'w')

count=1
# modify index count as needed

#fieldnames = ("InvoiceNo","StockCode","Description","Quantity","UnitPrice","CustomerID","Country","Timestamp")

fieldnames = ("metadata_generatedAt","metadata_recordGeneratedBy","metadata_logFileName","metadata_securityResultCode","metadata_sanitized","metadata_payloadType","metadata_recordType","metadata_serialId_streamId","metadata_serialId_bundleSize","metadata_serialId_bundleId","metadata_serialId_recordId","metadata_serialId_serialNumber","metadata_receivedAt","metadata_rmd_elevation","metadata_rmd_heading","metadata_rmd_latitude","metadata_rmd_longitude","metadata_rmd_speed","metadata_rmd_rxSource","metadata_schemaVersion","dataType","messageId","travelerinformation_timeStamp","travelerinformation_packetID","travelerinformation_urlB","travelerinformation_msgCnt","travelerdataframe_closedPath","travelerdataframe_anchor_elevation","travelerdataframe_anchor_lat","travelerdataframe_anchor_long","travelerdataframe_name","travelerdataframe_laneWidth","travelerdataframe_directionality","travelerdataframe_desc_nodes","travelerdataframe_desc_scale","travelerdataframe_id","travelerdataframe_direction","travelerdataframe_durationTime","travelerdataframe_sspMsgRights1","travelerdataframe_sspMsgRights2","travelerdataframe_startYear","travelerdataframe_msgId_crc","travelerdataframe_msgId_viewAngle","travelerdataframe_msgId_mutcdCode","travelerdataframe_msgId_elevation","travelerdataframe_msgId_lat","travelerdataframe_msgId_long","travelerdataframe_priority","travelerdataframe_content_itis","travelerdataframe_url","travelerdataframe_sspTimRights","travelerdataframe_sspLocationRights","travelerdataframe_frameType","travelerdataframe_startTime")

# field names to match input file

reader = csv.DictReader( csvfile, fieldnames)
for row in reader:
    jsonfile.write("{\"index\" : { \"_index\" : \"connectedcar\", \"_id\" : " + str(count) + "}}\n")
    # change third field to match your OS index name

    json.dump(row, jsonfile)
    jsonfile.write('\n')
    count += 1

