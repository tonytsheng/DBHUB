from random import seed
from random import randint
# seed vars
seed(randint(0,10))
#access_key_set = set()
access_key_set = ''


for _ in range(randint(0,5)):
  access_key = str(randint(0,50))
#  access_key_set.add(access_key)
  access_key_set = (access_key_set + ',' + access_key)
  print (access_key_set)

# devid, agentid, accesskeyset
# insert into data store
print ('10' + ',' + '22' + ',{' + access_key_set + '}')

