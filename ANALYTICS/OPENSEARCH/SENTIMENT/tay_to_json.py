import csv
import json
import subprocess
import linecache

id = 1

data = {}
with open('/home/ec2-user/data/taylor2.csv', encoding='utf-8') as csvf:
    taylor_csv = csv.DictReader(csvf)
    for t_rows in taylor_csv:
        le = linecache.getline(r"sentiment2",id)
#        print (le)
        newrow = (t_rows , le)
#        print (newrow)
        print ('{"index" : { "_index" : "taylor2", "_id" : ' + str(id) + ' }}')
        print (json.dumps(newrow))
        id += 1

