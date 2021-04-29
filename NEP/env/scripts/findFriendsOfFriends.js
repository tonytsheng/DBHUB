// Copyright 2020 Amazon.com, Inc. or its affiliates. All Rights Reserved.
// SPDX-License-Identifier: MIT-0
const gremlin = require('gremlin');
const DriverRemoteConnection = gremlin.driver.DriverRemoteConnection;
const Graph = gremlin.structure.Graph;
const neq = gremlin.process.P.neq
const without = gremlin.process.P.without
const local = gremlin.process.scope.local
const values = gremlin.process.column.values
const desc = gremlin.process.order.desc

const connection = new DriverRemoteConnection(`wss://${process.env.NEPTUNE_ENDPOINT}:8182/gremlin`,{});

const graph = new Graph();
const g = graph.traversal().withRemote(connection);

const findFriendsOfFriends = async (username) => {
  return g.V()
    .has('User', 'username', username).as('user')
    .out('Follows').aggregate('friends')
    .in_('Follows')
    .out('Follows').where(without('friends'))
    .where(neq('user'))
    .values('username')
    .groupCount()
    .order(local)
    .by(values, desc)
    .limit(local, 10)
    .next()
}

findFriendsOfFriends('davidmiller').then((resp) => {
  console.log(resp.value)
  connection.close()
})
