"use strict";

this.SocialController = function($scope, players) {
  $scope.friends = [];
  players.fetchFriends().then(function(friends) {
    return $scope.friends = friends;
  });
  $scope.friendbarValues = window.qs.info.friendbar.values;
  $scope.sortFriends = "fullName";
  $scope.onlineOnlyFriends = "level";
  $scope.searchFriends = new Object;
  return $scope.toggleFriendFilter = function() {
    if (!$scope.searchFriends.online) {
      return $scope.searchFriends.online = true;
    } else {
      return $scope.searchFriends.online = "";
    }
  };
};

this.SocialController.$inject = ["$scope", "players"];


this.navigationController = function($scope) {

  $scope.currentSection = "game";

  $scope.toggleSection = function(target) {
    if ($scope.currentSection != target) {
      $scope.currentSection = target;
    } else {
      $scope.currentSection = "game";
    }
  };
  
};

this.navigationController.$inject = ["$scope"];


