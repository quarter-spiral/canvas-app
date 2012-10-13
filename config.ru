require 'rubygems'
require 'bundler/setup'

require 'canvas-app'

if !ENV['RACK_ENV'] || ENV['RACK_ENV'] == 'development'
  ENV['QS_OAUTH_CLIENT_ID'] ||= 'bmycruwwc96b5otil3fipgh8rcoj9z'
  ENV['QS_OAUTH_CLIENT_SECRET'] ||= 'rcghf9way9i7lbdzyakaecly5ow9fau'
end

run Canvas::App::App
