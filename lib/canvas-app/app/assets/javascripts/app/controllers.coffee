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
  $scope.toggleSection = (target) ->
    unless $scope.currentSection is target
      $scope.currentSection = target
    else
      $scope.currentSection = "game"

  $scope.qsData = ->
    window.qs

  $scope.gameData = ->
    $scope.qsData().info.gameDetails

  $scope.gameEmbedCode = ->
    $scope.qsData().info.embedCode

@navigationController.$inject = ["$scope"]