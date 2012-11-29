"use strict"

# Controllers
@SocialController = ($scope, players) ->
  $scope.friends = []

  players.fetchFriends().then (friends) -> $scope.friends = friends

  $scope.sortFriends = "level"
  $scope.onlineOnlyFriends = "level"
  $scope.searchFriends = new Object
  $scope.toggleFriendFilter = ->
    unless $scope.searchFriends.online
      $scope.searchFriends.online = true
    else
      $scope.searchFriends.online = ""

@SocialController.$inject = ["$scope", "players"]
