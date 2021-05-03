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

const createUser = async (name) => {
  return g.addV('name').property('name', name).next()
}

const createInterest = async (interest) => {
  return g.addV('Interest').property('interest', interest).next()
}

const raw = fs.readFileSync(path.resolve( __dirname, 'airport-2.json'));
const vertices = JSON.parse(raw)

const vertexPromises = vertices.map((vertex) => {
  if (vertex.label === 'airport') {
    return createUser(vertex.name)
  } else if (vertex.label === 'Interest') {
    return createInterest(vertex.name)
  }
})

Promise.all(vertexPromises).then(() => {
  console.log('Loaded vertices successfully!')
  connection.close()
})
