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

@navigationController = ($scope, $timeout) ->
  $scope.currentSection = "game"
  $scope.showPromo = false
  $scope.toggleSection = (target) ->
    if $scope.currentSection isnt target
      $scope.$emit('removeAds') if target is 'game'
      $scope.currentSection = target
    else
      $scope.currentSection = "game"

  $scope.togglePromo = ->
    if $scope.showPromo
      $scope.showPromo = false
    else
      $scope.showPromo = true

  # This add
  $timeout (->
    $scope.toggleSection "preroll" unless $scope.qsData().info.localMode
  ), 0

  $scope.qsData = ->
    window.qs

  $scope.gameData = ->
    $scope.qsData().info.gameDetails

  $scope.gameEmbedCode = ->
    $scope.qsData().info.embedCode

  okToSkipAdAt = null
  addAirTime = 7000

  adTimer = ->
    currentTime = new Date().getTime()
    okToSkipAdAt = currentTime + addAirTime unless okToSkipAdAt

    $scope.timeTillAdIsSkipable = Math.ceil((okToSkipAdAt - currentTime) / 1000)
    $timeout(adTimer, 200) if currentTime < okToSkipAdAt

  $scope.startAdTimer = ->
    adTimer()

  $scope.logout = ->
    date = undefined
    expires = undefined
    logoutUrl = undefined
    redirectUrl = undefined
    date = new Date()
    date.setTime date.getTime() + (-1 * 24 * 60 * 60 * 1000)
    expires = "expires=" + date.toGMTString()
    document.cookie = "qs_canvas_authentication=; " + expires + "; path=/"
    redirectUrl = window.location.href.replace(/#\/logout.*$/, "")
    logoutUrl = window.qs.ENV["QS_AUTH_BACKEND_URL"] + "/signout?redirect_uri=" + encodeURIComponent(redirectUrl)
    window.location.href = logoutUrl

@navigationController.$inject = ["$scope", "$timeout"]