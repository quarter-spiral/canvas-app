"use strict"

# Controllers
@SocialCtrl = ($scope) ->
  $scope.friends = [
    userName: "Alex"
    fullName: "Alexander Kohlhofer"
    level: 12
    xp: 2311
    online: false
    avatar: "http://a0.twimg.com/profile_images/14522682/Picture_6.png"
  ,
    userName: "Thorben"
    fullName: "Thorben S"
    level: 14
    xp: 2511
    online: false
    avatar: "http://reddotrubyconf.com/images/2012/thorben.jpg"
  ,
    userName: "Ethan"
    fullName: "Ethan Levy"
    level: 13
    xp: 3121
    online: true
    avatar: "http://www.gamasutra.com/blogs/edit/img/portrait/404017/portrait.jpg?1331322898"
  ,
    userName: "Thorben"
    fullName: "Thorben S"
    level: 11
    xp: 2511
    online: false
    avatar: "http://reddotrubyconf.com/images/2012/thorben.jpg"
  ,
    userName: "Ethan"
    fullName: "Ethan Levy"
    level: 10
    xp: 3121
    online: true
    avatar: "http://www.gamasutra.com/blogs/edit/img/portrait/404017/portrait.jpg?1331322898"
  ,
    userName: "Thorben"
    fullName: "Thorben S"
    level: 18
    xp: 2511
    online: false
    avatar: "http://reddotrubyconf.com/images/2012/thorben.jpg"
  ,
    userName: "Ethan"
    fullName: "Ethan Levy"
    level: 9
    xp: 3121
    online: false
    avatar: "http://www.gamasutra.com/blogs/edit/img/portrait/404017/portrait.jpg?1331322898"
  ,
    userName: "Thorben"
    fullName: "Thorben S"
    level: 7
    xp: 2511
    online: true
    avatar: "http://reddotrubyconf.com/images/2012/thorben.jpg"
  ,
    userName: "Ethan"
    fullName: "Ethan Levy"
    level: 6
    xp: 3121
    online: false
    avatar: "http://www.gamasutra.com/blogs/edit/img/portrait/404017/portrait.jpg?1331322898"
  ,
    userName: "Cecile"
    fullName: "Cecile Plattner"
    level: 11
    xp: 4021
    online: true
    avatar: "http://4.bp.blogspot.com/-UqYB0pv19mI/TrWGaZ2aD4I/AAAAAAAAAfE/SUP-ppHUo4o/s1600/Photo+on+2011-11-05+at+11.53+%25232.jpg"
  ,
    userName: "Ethan"
    fullName: "Ethan Levy"
    level: 4
    xp: 3121
    online: false
    avatar: "http://www.gamasutra.com/blogs/edit/img/portrait/404017/portrait.jpg?1331322898"
  ,
    userName: "Thorben"
    fullName: "Thorben S"
    level: 3
    xp: 2511
    online: false
    avatar: "http://reddotrubyconf.com/images/2012/thorben.jpg"
  ,
    userName: "Ethan"
    fullName: "Ethan Levy"
    level: 2
    xp: 3121
    online: false
    avatar: "http://www.gamasutra.com/blogs/edit/img/portrait/404017/portrait.jpg?1331322898"
  ]
  $scope.sortFriends = "level"
  $scope.onlineOnlyFriends = "level"
  $scope.searchFriends = new Object
  $scope.toggleFriendFilter = ->
    unless $scope.searchFriends.online
      $scope.searchFriends.online = true
    else
      $scope.searchFriends.online = ""
