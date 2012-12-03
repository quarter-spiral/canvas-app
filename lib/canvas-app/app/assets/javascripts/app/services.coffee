"use strict"

# Services

# Demonstrate how to register services
# In this case it is a simple value service.
services = angular.module("canvasApp.services", ["ngResource"])

services.factory "venue-user", [->
  {
    currentUser: ->
      {
        uuid: window.qs.info.uuid
        token: window.qs.tokens.qs
      }
  }
]

services.factory "players", ["$rootScope", "venue-user","qs_commons_http", (rootScope, user, http) ->
  playercenterUrl = window.qs.ENV.QS_PLAYERCENTER_BACKEND_URL

  http.setUserService user

  {
    fetchFriends: ->
      http.makeRequest(
        method: 'GET'
        url: "#{playercenterUrl}/v1/#{user.currentUser().uuid}/friends?game=#{window.qs.info.game}"
        returns: (data) ->
          friends = []
          for uuid, friendData of data
            friendData = friendData[window.qs.info.venue] || friendData['facebook'] # TODO <-- dirty hack till we have QS friends
            friends.push {
              uuid: uuid
              userName: friendData.name
              fullName: friendData.name
              level: 12
              xp: 2311
              online: false
              avatar: "#{playercenterUrl}/v1/#{uuid}/avatars/#{window.qs.info.venue}"
            }
          friends
      )
  }
]
