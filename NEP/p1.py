from __future__  import print_function  # Python 2/3 compatibility

from gremlin_python import statics
from gremlin_python.structure.graph import Graph
from gremlin_python.process.graph_traversal import __
from gremlin_python.process.strategies import *
from gremlin_python.driver.driver_remote_connection import DriverRemoteConnection

graph = Graph()

remoteConn = DriverRemoteConnection('wss://nep1001.cyt4dgtj55oy.us-east-2.neptune.amazonaws.com:8182/gremlin','g')
g = graph.traversal().withRemote(remoteConn)

#ID = g.V().has('code', 'ORD').values('T.id').next()
#print (ID)
#for p in g.V(v).properties():
#   print("key:",p.label, "| value: " ,p.value)
ORD = g.V().has('code', 'ORD').valueMap(True).next()
print ('+++ Vertices with all attributes for ORD:', ORD)
ORD = g.V().has('code', 'ORD').valueMap().next()
print ('+++ Vertices with all attributes for ORD:', ORD)
ORD = g.V().count().next()
print ('+++ Overall Vertices:' , ORD)


remoteConn.close()
