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

this.navigationController = function($scope, $timeout, $filter) {


  var adTimer, addAirTime, okToSkipAdAt;
  $scope.currentSection = "game";
  $scope.showPromo = false;
  $scope.toggleSection = function(target) {
    if ($scope.currentSection !== target) {
      if (target === 'game') {
        $scope.$emit('removeAds');
      }
      return $scope.currentSection = target;
    } else {
      return $scope.currentSection = "game";
    }
  };
  $scope.getTotalSize = function() {
    var headerHeight = $('#header').height();
    var gameHeight = $('#game').height();
    var socialHeight = $('#socialBar').height();
    var totalHeight = headerHeight + gameHeight + socialHeight;
    alert(
      "header: "+ headerHeight
      +", game: "+ gameHeight
      +", social bar: "+ socialHeight
      +" total Hheight: "+ totalHeight
      );
  }
  $scope.togglePromo = function() {
    if ($scope.showPromo) {
      return $scope.showPromo = false;
    } else {
      return $scope.showPromo = true;
    }
  };
  $scope.qsData = function() {
    return window.qs;
  };
  $scope.gameData = function() {
    return $scope.qsData().info.gameDetails;
  };
  $scope.gameEmbedCode = function() {
    return $scope.qsData().info.embedCode;
  };
  $scope.loggedIn = function() {
    return !!($scope.qsData().info.uuid);
  };
  $scope.loginUrl = function() {
    var urls;
    urls = {
      embedded: '/auth/auth_backend',
      'spiral-galaxy': $scope.qsData().ENV.QS_SPIRAL_GALAXY_URL + "/auth/auth_backend?origin=" + $filter('url')('/play/' + $scope.qsData().info.game)
    };
    return urls[$scope.qsData().info.venue] || '#/no-login';
  };
  $scope.skipAds = $scope.qsData().info.localMode || $scope.qsData().info.subscription;
  $timeout((function() {
    if (!$scope.skipAds) {
      return $scope.toggleSection("preroll");
    }
  }), 0);
  okToSkipAdAt = null;
  addAirTime = 7000;
  adTimer = function() {
    var currentTime;
    currentTime = new Date().getTime();
    if (!okToSkipAdAt) {
      okToSkipAdAt = currentTime + addAirTime;
    }
    $scope.timeTillAdIsSkipable = Math.ceil((okToSkipAdAt - currentTime) / 1000);
    if (currentTime < okToSkipAdAt) {
      return $timeout(adTimer, 200);
    }
  };
  $scope.startAdTimer = function() {
    return adTimer();
  };
  return $scope.logout = function() {
    var date, expires, logoutUrl, redirectUrl;
    date = void 0;
    expires = void 0;
    logoutUrl = void 0;
    redirectUrl = void 0;
    date = new Date();
    date.setTime(date.getTime() + (-1 * 24 * 60 * 60 * 1000));
    expires = "expires=" + date.toGMTString();
    document.cookie = "qs_canvas_authentication=; " + expires + "; path=/";
    redirectUrl = window.location.href.replace(/#\/logout.*$/, "");
    logoutUrl = window.qs.ENV["QS_AUTH_BACKEND_URL"] + "/signout?redirect_uri=" + encodeURIComponent(redirectUrl);
    return window.location.href = logoutUrl;
  };
};

this.navigationController.$inject = ["$scope", "$timeout", "$filter"];
