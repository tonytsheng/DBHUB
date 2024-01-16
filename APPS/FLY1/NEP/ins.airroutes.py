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

#user_query = sys.argv[1]
#print ("query: " + user_query )

WDIR='/home/ec2-user/DBHUB/APPS/FLY1/'
INFILE=WDIR+'airport-codes_csv.csv'

cmd='/bin/grep large_airport ' + INFILE + ' | /usr/bin/shuf -n1 | /usr/bin/awk -F\',\' \'{print $10}\' '
DEP = subprocess.run(cmd, shell=True, capture_output=True, text=True ).stdout.strip("\n")
ARR = subprocess.run(cmd, shell=True, capture_output=True, text=True ).stdout.strip("\n")
print (DEP)
print (ARR)

graph = Graph()
remoteConn = DriverRemoteConnection('wss://nep100.cluster-ro-cyt4dgtj55oy.us-east-2.neptune.amazonaws.com:8182/gremlin','g')
g = graph.traversal().withRemote(remoteConn)

#result = g.V().has('code', 'BWI').valueMap(True).next()
result = g.V().has('code','BWI').out().path().by('code')

for r in result:
    print ('+++ query:' ,  r)
print ('+++')

#result2 = g.addE('route').from('BWI').to('ATL')
#result2 = g.addE('route').from(_.V('BWI')).to(_.V('ATL'))
result2 = g.addV('airport').property('name','TEST').property('code','YYY')
result2 = g.addE('BWI', 'YYY','route')
print (result2)


remoteConn.close()


#  g.addE('knows').from(vMarko).to(vPeter) ////


