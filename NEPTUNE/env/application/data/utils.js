// Copyright 2020 Amazon.com, Inc. or its affiliates. All Rights Reserved.
// SPDX-License-Identifier: MIT-0
const gremlin = require('gremlin');
const DriverRemoteConnection = gremlin.driver.DriverRemoteConnection;
const Graph = gremlin.structure.Graph;

const connection = new DriverRemoteConnection(`wss://${process.env.NEPTUNE_ENDPOINT}:8182/gremlin`,{});

const graph = new Graph();
const g = graph.traversal().withRemote(connection);

const { neq, without } = gremlin.process.P
const { local } = gremlin.process.scope
const { values } = gremlin.process.column
const { desc } = gremlin.process.order

module.exports = {
  g,
  neq,
  without,
  local,
  values,
  desc
}