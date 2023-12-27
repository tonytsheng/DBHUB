import json

f = open('taylor2.json')
data = json.load(f)

for i in data['taylor']:
    print (i)

f.close()

