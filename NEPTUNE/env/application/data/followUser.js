// Copyright 2020 Amazon.com, Inc. or its affiliates. All Rights Reserved.
// SPDX-License-Identifier: MIT-0
const { g } = require('./utils')

const followUser = async ({ follower, friend }) => {
  const relationship = await g
    .V().has('User', 'username', friend).as('friend')
    .V().has('User', 'username', follower)
    .addE('Follows').to('friend')
    .next()

  console.log(relationship)

  return {
    follower,
    friend
  }
}

module.exports = followUser