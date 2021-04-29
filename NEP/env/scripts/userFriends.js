// Copyright 2020 Amazon.com, Inc. or its affiliates. All Rights Reserved.
// SPDX-License-Identifier: MIT-0
const gremlin = require('gremlin');
const DriverRemoteConnection = gremlin.driver.DriverRemoteConnection;
const Graph = gremlin.structure.Graph;
const outE = gremlin.process.statics.outE

const connection = new DriverRemoteConnection(`wss://${process.env.NEPTUNE_ENDPOINT}:8182/gremlin`,{});

const graph = new Graph();
const g = graph.traversal().withRemote(connection);

const findUserFriends = async () => {
  return g.V()
    .group()
    .by()
    .by(outE('Follows').count())
    .toList()
}

findUserFriends().then((resp) => {
  console.log(resp)
  connection.close()
})
