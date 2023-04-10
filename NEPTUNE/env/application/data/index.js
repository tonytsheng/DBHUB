// Copyright 2020 Amazon.com, Inc. or its affiliates. All Rights Reserved.
// SPDX-License-Identifier: MIT-0
const fetchUser = require('./fetchUser')
const fetchUserRecommendations = require('./fetchUserRecommendations')
const followUser = require('./followUser')
const createUser = require('./createUser')

module.exports = {
  fetchUser,
  fetchUserRecommendations,
  followUser,
  createUser
}