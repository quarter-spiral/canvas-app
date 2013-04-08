"use strict"

# Directives
@angular.module("canvasApp.directives", []).directive("appVersion", ["version", (version) ->
  (scope, elm, attrs) ->
    elm.text version
]).directive('adTimer', ->
  ($scope, element, attrs) ->
    $scope.startAdTimer()
).directive('removableAd', ->
  ($scope, element, attrs) ->
    $scope.$on 'removeAds', ->
      element.remove()
).directive('inviteLink', ->
  ($scope, element, attrs) ->
    $(element).click (e) ->
      e.preventDefault()
      $('.st_sharethis_large').click()
)