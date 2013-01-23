"use strict"
@SocialController = ($scope, players) ->
  $scope.friends = []
  players.fetchFriends().then (friends) ->
    $scope.friends = friends

  $scope.friendbarValues = window.qs.info.friendbar.values
  $scope.sortFriends = "fullName"
  $scope.onlineOnlyFriends = "level"
  $scope.searchFriends = new Object
  $scope.toggleFriendFilter = ->
    unless $scope.searchFriends.online
      $scope.searchFriends.online = true
    else
      $scope.searchFriends.online = ""

@SocialController.$inject = ["$scope", "players"]

@navigationController = ($scope) ->
  $scope.currentSection = "game"
  $scope.showPromo = false
  $scope.toggleSection = (target) ->
    unless $scope.currentSection is target
      $scope.currentSection = target
    else
      $scope.currentSection = "game"

  $scope.togglePromo = ->
    if $scope.showPromo
      $scope.showPromo = false
    else
      $scope.showPromo = true

  $scope.qsData = ->
    window.qs

  $scope.gameData = ->
    $scope.qsData().info.gameDetails

  $scope.gameEmbedCode = ->
    $scope.qsData().info.embedCode

  $scope.logout = ->
    date = new Date()
    date.setTime(date.getTime()+(-1*24*60*60*1000))
    expires = "expires="+date.toGMTString()
    document.cookie = "qs_canvas_authentication=; " + expires + "; path=/"

    redirectUrl = window.location.href.replace(/#\/logout.*$/, '')
    logoutUrl = window.qs.ENV["QS_AUTH_BACKEND_URL"] + "/signout?redirect_uri=" + encodeURIComponent(redirectUrl)
    window.location.href = logoutUrl

@navigationController.$inject = ["$scope"]