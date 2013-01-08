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

services.factory "players", ["$rootScope", "$q", "venue-user","qs_commons_http", (rootScope, q, user, http) ->
  playercenterUrl = window.qs.ENV.QS_PLAYERCENTER_BACKEND_URL

  http.setUserService user

  {
    fetchFriends: ->
      unless user.currentUser().uuid
        deferred = q.defer()
        return deferred.promise

      url = "#{playercenterUrl}/v1/#{user.currentUser().uuid}/friends?game=#{window.qs.info.game}"
      metaKeys = []
      if window.qs.info.friendbar.values.top
        metaKeys.push(window.qs.info.friendbar.values.top.key)
      if window.qs.info.friendbar.values.bottom
        metaKeys.push(window.qs.info.friendbar.values.bottom.key)
      if metaKeys.length > 0
        url = "#{url}&meta=#{encodeURIComponent(angular.toJson(metaKeys))}"

      http.makeRequest(
        method: 'GET'
        url: url
        returns: (data) ->
          friends = []
          for uuid, rawFriendData of data
            friendData = rawFriendData[window.qs.info.venue] || rawFriendData['facebook'] # TODO <-- dirty hack till we have QS friends
            friend = {
              uuid: uuid
              userName: friendData.name
              fullName: friendData.name
              avatar: "#{playercenterUrl}/v1/#{uuid}/avatars/#{window.qs.info.venue}"
              meta: {}
            }

            if window.qs.info.friendbar.values.top
              value = rawFriendData['meta'][window.qs.info.friendbar.values.top.key] || window.qs.info.friendbar.values.top.default
              friend.meta.top = {label: window.qs.info.friendbar.values.top.label, value: value}
            if window.qs.info.friendbar.values.bottom
              value = rawFriendData['meta'][window.qs.info.friendbar.values.bottom.key] || window.qs.info.friendbar.values.bottom.default
              friend.meta.bottom = {label: window.qs.info.friendbar.values.bottom.label, value: value}

            friends.push(friend)
          friends
      )
  }
]
