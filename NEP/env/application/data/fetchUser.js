// Copyright 2020 Amazon.com, Inc. or its affiliates. All Rights Reserved.
// SPDX-License-Identifier: MIT-0
const { g } = require('./utils')

const fetchUser = async (username) => {
  const friends = await g.V()
    .has('User', 'username', username)
    .out('Follows')
    .values('username')
    .toList()

  const interests = await g.V()
    .has('User', 'username', username)
    .out('InterestedIn')
    .values('interest')
    .toList()
  
  return {
    username,
    friends,
    interests
  }
}

module.exports = fetchUser