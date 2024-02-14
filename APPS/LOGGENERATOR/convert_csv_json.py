## convert a csv file to json
## specific for bulk load for open search
## consider this a template

import csv
import json

INFILE="20240214-022238.log"
OUTFILE="20240214-022238.json"
# change in and out file

csvfile = open(INFILE, 'r')

jsonfile = open(OUTFILE, 'w')

count=1
# modify index count as needed

fieldnames = ("InvoiceNo","StockCode","Description","Quantity","UnitPrice","CustomerID","Country","InvoiceDate")
# field names to match input file

reader = csv.DictReader( csvfile, fieldnames)
for row in reader:
    jsonfile.write("{\"index\" : { \"_index\" : \"logger\", \"_id\" : " + str(count) + "}}\n")
    # change third field to match your OS index name

    json.dump(row, jsonfile)
    jsonfile.write('\n')
    count += 1

