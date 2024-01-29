from __future__  import print_function  # Python 2/3 compatibility
#import sys

from gremlin_python import statics
from gremlin_python.structure.graph import Graph
from gremlin_python.process.graph_traversal import __
from gremlin_python.process.strategies import *
from gremlin_python.driver.driver_remote_connection import DriverRemoteConnection

#user_query = sys.argv[1]
#print ("query: " + user_query )

graph = Graph()
remoteConn = DriverRemoteConnection('wss://nep100.cluster-ro-cyt4dgtj55oy.us-east-2.neptune.amazonaws.com:8182/gremlin','g')
g = graph.traversal().withRemote(remoteConn)

result = g.V().has('code', 'BWI').valueMap(True).next()
print ('+++')
print ('+++ query:' ,  result)
print ('+++')

remoteConn.close()
