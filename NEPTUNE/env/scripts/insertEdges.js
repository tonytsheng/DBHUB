// Copyright 2020 Amazon.com, Inc. or its affiliates. All Rights Reserved.
// SPDX-License-Identifier: MIT-0
const fs = require('fs');
const path = require('path');

const gremlin = require('gremlin');
const DriverRemoteConnection = gremlin.driver.DriverRemoteConnection;
const Graph = gremlin.structure.Graph;

const connection = new DriverRemoteConnection(`wss://${process.env.NEPTUNE_ENDPOINT}:8182/gremlin`,{});

const graph = new Graph();
const g = graph.traversal().withRemote(connection);

const addFollow = async ({ friend, follower }) => {
  return g.V().has('User', 'username', friend).as('friend')
    .V().has('User', 'username', follower).as('follower')
    .addE('Follows').from_('follower').to('friend').next()
}

const addInterested = async ({ user, interest }) => {
  return g.V().has('User', 'username', user).as('user')
    .V().has('Interest', 'interest', interest).as('interest')
    .addE('InterestedIn').from_('user').to('interest').next()
}

const raw = fs.readFileSync(path.resolve( __dirname, 'edges.json'));
const edges = JSON.parse(raw)

const edgePromises = edges.map((edge) => {
  if (edge.label === 'Follow') {
    return addFollow({ friend: edge.friend, follower: edge.follower })
  } else if (edge.label === 'InterestedIn') {
    return addInterested({ user: edge.user, interest: edge.interest })
  }
})

Promise.all(edgePromises).then(() => {
  console.log('Loaded edges successfully!')
  connection.close()
})
