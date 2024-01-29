const gremlin = require('gremlin');
const DriverRemoteConnection = gremlin.driver.DriverRemoteConnection;
const Graph = gremlin.structure.Graph;

const connection = new DriverRemoteConnection(`wss://${process.env.NEPTUNE_ENDPOINT}:8182/gremlin`,{});

const graph = new Graph();
const g = graph.traversal().withRemote(connection);

g.V().count().next().
    then(data => {
        console.log(data);
        connection.close();
    }).catch(error => {
        console.log('ERROR', error);
        connection.close();
    });
