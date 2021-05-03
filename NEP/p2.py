# Print all vertices (don't run this on large database!)
print(g.V().toList())

[v[0], v[1], v[2], v[3], v[4], v[5], v[6], v[7], v[8], v[9], v[10], v[11], v[12], v[13], v[14], v[15], v[16], v[17], v[18], v[19], v[20], v[21], v[22], v[23], v[24], v[25], v[26], v[27], v[28], v[29], v[30], v[31], v[32], v[33]]

# Print all edges (don't run this on large database!)
#print(g.E().toList())

# [e[edge15][8-edge->0], e[edge31][17-edge->1], e[edge47][31-edge->24], e[edge63][33-edge->13], e[edge0][1-edge->0], e[edge16][8-edge->2], e[edge32][19-edge->0], e[edge48][31-edge->25], e[edge64][33-edge->14], e[edge1][2-edge->0], e[edge17][9-edge->2], e[edge33][19-edge->1], e[edge49][31-edge->28], e[edge65][33-edge->15], e[edge2][2-edge->1], e[edge18][10-edge->0], e[edge34][21-edge->0], e[edge50][32-edge->2], e[edge66][33-edge->18], e[edge3][3-edge->0], e[edge19][10-edge->4], e[edge35][21-edge->1], e[edge51][32-edge->8], e[edge67][33-edge->19], e[edge4][3-edge->1], e[edge20][10-edge->5], e[edge36][25-edge->23], e[edge52][32-edge->14], e[edge68][33-edge->20], e[edge5][3-edge->2], e[edge21][11-edge->0], e[edge37][25-edge->24], e[edge53][32-edge->15], e[edge69][33-edge->22], e[edge6][4-edge->0], e[edge22][12-edge->0], e[edge38][27-edge->2], e[edge54][32-edge->18], e[edge70][33-edge->23], e[edge7][5-edge->0], e[edge23][12-edge->3], e[edge39][27-edge->23], e[edge55][32-edge->20], e[edge71][33-edge->26], e[edge8][6-edge->0], e[edge24][13-edge->0], e[edge40][27-edge->24], e[edge56][32-edge->22], e[edge72][33-edge->27], e[edge9][6-edge->4], e[edge25][13-edge->1], e[edge41][28-edge->2], e[edge57][32-edge->23], e[edge73][33-edge->28], e[edge10][6-edge->5], e[edge26][13-edge->2], e[edge42][29-edge->23], e[edge58][32-edge->29], e[edge74][33-edge->29], e[edge11][7-edge->0], e[edge27][13-edge->3], e[edge43][29-edge->26], e[edge59][32-edge->30], e[edge75][33-edge->30], e[edge12][7-edge->1], e[edge28][16-edge->5], e[edge44][30-edge->1], e[edge60][32-edge->31], e[edge76][33-edge->31], e[edge13][7-edge->2], e[edge29][16-edge->6], e[edge45][30-edge->8], e[edge61][33-edge->8], e[edge77][33-edge->32], e[edge14][7-edge->3], e[edge30][17-edge->0], e[edge46][31-edge->0], e[edge62][33-edge->9]]

# Select node0 (one of the teachers)
#n0 = g.V().has('name', 'node0')
# Get all edges for this node
#n0_edges = n0.bothE().toList()
# For each edge, get the id of the peer node
#n0_peers = [ e.outV.id for e in n0_edges ]
#print(n0_peers)

#['1', '2', '3', '4', '5', '6', '7', '8', '10', '11', '12', '13', '17', '19', '21', '31']
