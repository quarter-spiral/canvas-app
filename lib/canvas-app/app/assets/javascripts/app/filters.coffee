"use strict"

# Filters
@angular.module("canvasApp.filters", []).filter("interpolate", ["version", (version) ->
  (text) ->
    String(text).replace /\%VERSION\%/g, version
]).filter('url', [->
  (url) ->
    window.encodeURIComponent(url)
]).filter('friendbarValue', [->
  (value) ->
    return unless value
    if typeof value is "number"
      return Math.round(value * 100) / 100
    else
      return value
])