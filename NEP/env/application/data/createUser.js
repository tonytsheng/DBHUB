// Copyright 2020 Amazon.com, Inc. or its affiliates. All Rights Reserved.
// SPDX-License-Identifier: MIT-0
const { g } = require('./utils')

const createUser = async (username, interests) => {
  const user = await g.addV('User').property('username', username).next()
  const edgePromises = interests.map((interest) => {
    return g.V()
      .has('Interest', 'interest', interest)
      .as('interest')
      .V(user.value.id)
      .addE('InterestedIn').to('interest')
      .next()
  })
  await Promise.all(edgePromises)
  return {
    username,
    interests
  }
}

module.exports = createUser