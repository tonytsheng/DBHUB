// Copyright 2020 Amazon.com, Inc. or its affiliates. All Rights Reserved.
// SPDX-License-Identifier: MIT-0
const { g, local, values, desc, without, neq } = require('./utils')

const fetchUserRecommendations = async (username) => {
  const friendsOfFriends = await g.V()
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
  const friendsWithInterests = await g.V()
    .has('User', 'username', username).as('user')
    .out('InterestedIn')
    .in_('InterestedIn')
    .out('Follows')
    .where(neq('user'))
    .values('username')
    .groupCount()
    .order(local)
    .by(values, desc)
    .limit(local, 10)
    .next()
  return {
    username,
    friendsOfFriends: Array.from(friendsOfFriends.value.entries()),
    friendsWithInterests: Array.from(friendsWithInterests.value.entries())
  }
}

module.exports = fetchUserRecommendations