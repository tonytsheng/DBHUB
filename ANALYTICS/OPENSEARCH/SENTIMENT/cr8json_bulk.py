import json

f = open('/home/ec2-user/data/taylor2.json')
data = json.load(f)

for i in data['taylor']:
    print (i)

f.close()

