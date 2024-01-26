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

WDIR='/home/ec2-user/DBHUB/APPS/FLY1/'
INFILE=WDIR+'airports-large-nodes.csv'
cmd='/usr/bin/shuf -n1 ' + INFILE + ' | /usr/bin/awk -F\',\' \'{print $4}\' '

graph = Graph()
remoteConn = DriverRemoteConnection('wss://nep100.cluster-cyt4dgtj55oy.us-east-2.neptune.amazonaws.com:8182/gremlin','g')
g = graph.traversal().withRemote(remoteConn)

distance = randint(0,99999)
hops = randint(0,5)
arr = []
for r in range(hops):
#    print(r)
    t = subprocess.run(cmd, shell=True, capture_output=True, text=True ).stdout.strip("\n")
    arr.insert(r, t)
#    print (arr[r])
#    print (arr)
#print ('full list: ' )
#print (arr)

for r in range(hops):
#    if r == 0:
#        return
    if r >= hops-1:
        break
#    print (r)
    DEP = (arr[r])
    ARR = (arr[r+1])
    print (DEP)
    print (ARR)
    g.V().has('code',DEP).addE('route').to(__.V().has('code',ARR)).property('distance', distance).next()
--     print ('added')

