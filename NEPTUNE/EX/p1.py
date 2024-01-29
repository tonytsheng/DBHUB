from __future__  import print_function  # Python 2/3 compatibility

from gremlin_python import statics
from gremlin_python.structure.graph import Graph
from gremlin_python.process.graph_traversal import __
from gremlin_python.process.strategies import *
from gremlin_python.driver.driver_remote_connection import DriverRemoteConnection

graph = Graph()

remoteConn = DriverRemoteConnection('wss://nep1002.cyt4dgtj55oy.us-east-2.neptune.amazonaws.com:8182/gremlin','g')
g = graph.traversal().withRemote(remoteConn)

#ID = g.V().has('code', 'ORD').values('T.id').next()
#print (ID)
#for p in g.V(v).properties():
#   print("key:",p.label, "| value: " ,p.value)

result = g.V().has('code', 'ORD').valueMap(True).next()
print ('+++')
print ('+++ ORD:', result)
print ('+++')

result = g.V().has('code', 'BWI').valueMap(True).next()
print ('+++')
print ('+++ BWI:', result)
print ('+++')

result = g.V().count().next()
print ('+++')
print ('+++ Overall Vertices:' , result)
print ('+++')

result = g.V().hasLabel('airport').groupCount().by('country').next()
print ('+++')
print ('+++ Airports by Country:', result)
print ('+++')

result = g.V().has('code','ORD').out().path().by('code')
print ('+++')
print ('+++ TODO does not work Where can I fly to ORD from  :', result)
print ('+++')

result = g.V().has('airport','code','ORD').values('city').next()
print ('+++')
print ('+++ City :', result)
print ('+++')

result = g.V().outE('route').count().next()
print ('+++')
print ('+++ Number of routes :', result)
print ('+++')

remoteConn.close()
