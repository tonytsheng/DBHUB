import os
import subprocess
import shlex
from subprocess import check_output, CalledProcessError, STDOUT
#from __future__  import print_function  # Python 2/3 compatibility
import sys
from gremlin_python import statics
from gremlin_python.structure.graph import Graph
from gremlin_python.process.graph_traversal import __
from gremlin_python.process.strategies import *
from gremlin_python.driver.driver_remote_connection import DriverRemoteConnection
from random import randint
import array as arr

#user_query = sys.argv[1]
#print ("query: " + user_query )

WDIR='/home/ec2-user/DBHUB/APPS/FLY1/'
INFILE=WDIR+'airports-large-nodes.csv'

#cmd='/bin/grep large_airport ' + INFILE + ' | /usr/bin/shuf -n1 | /usr/bin/awk -F\',\' \'{print $10}\' '
cmd='/usr/bin/shuf -n1 ' + INFILE + ' | /usr/bin/awk -F\',\' \'{print $4}\' '

graph = Graph()
remoteConn = DriverRemoteConnection('wss://nep100.cluster-cyt4dgtj55oy.us-east-2.neptune.amazonaws.com:8182/gremlin','g')
g = graph.traversal().withRemote(remoteConn)

hops = randint(1,5)
for r in range(1,4):
    print(r)
    distance = randint(0,99999)
    DEP = subprocess.run(cmd, shell=True, capture_output=True, text=True ).stdout.strip("\n")
    ARR = subprocess.run(cmd, shell=True, capture_output=True, text=True ).stdout.strip("\n")
    PREV = ARR
    print (DEP, ARR, PREV)

# want to do X inserts but one of them is always BWI as departure
# building the graph
    g.V().has('code',DEP).addE('route').to(__.V().has('code',ARR)).property('distance', distance).next() 
    g.V().has('code','BWI').addE('route').to(__.V().has('code',ARR)).property('distance', distance).next() 

i=0
result = g.V().has('code','BWI').out().path().by('code')
for r in result:
    i += 1
#    print (r)
#    print (i)
print (i)

remoteConn.close()


#  g.addE('knows').from(vMarko).to(vPeter) ////
#result = g.V().has('code', 'BWI').valueMap(True).next()
#result = g.V().has('code','BWI').out().path().by('code')
#result2 = g.addE('route').from('BWI').to('ATL')
#result2 = g.addE('route').from(_.V('BWI')).to(_.V('ATL'))
#result2 = g.addV('airport').property('name','TEST').property('code','YYY')
#result2 = g.V().has('code', 'BWI').addE('route').to(V().has('code', 'YYY')).iterate()
#result = g.V().has('code','BWI').out().has('code','YYY').valueMap()
#print (result2)
from_id = '6'
to_id = '1450'
#g.V(from_id).addE('route').to(__.V(to_id)).property('distance', 99999).next() -- works
#g.V().has('code','BWI').addE('route').to(__.V(to_id)).property('distance', 99999).next() -- works


