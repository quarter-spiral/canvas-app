"use strict"

# Directives
@angular.module("canvasApp.directives", []).directive "appVersion", ["version", (version) ->
  (scope, elm, attrs) ->
    elm.text version
]
