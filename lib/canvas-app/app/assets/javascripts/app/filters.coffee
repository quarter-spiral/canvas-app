"use strict"

# Filters
@angular.module("canvasApp.filters", []).filter "interpolate", ["version", (version) ->
  (text) ->
    String(text).replace /\%VERSION\%/g, version
]
