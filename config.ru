require 'rubygems'
require 'bundler/setup'

require 'canvas-app'

if !ENV['RACK_ENV'] || ENV['RACK_ENV'] == 'development'
  ENV['QS_OAUTH_CLIENT_ID'] ||= 'bmycruwwc96b5otil3fipgh8rcoj9z'
  ENV['QS_OAUTH_CLIENT_SECRET'] ||= 'rcghf9way9i7lbdzyakaecly5ow9fau'
end

ENV_KEYS_TO_EXPOSE = ['QS_PLAYERCENTER_BACKEND_URL', 'QS_AUTH_BACKEND_URL']

require 'newrelic_rpm'
require 'new_relic/agent/instrumentation/rack'
require 'ping-middleware'

class NewRelicMiddleware
  def initialize(app)
    @app = app
  end

  def call(env)
    @app.call(env)
  end
  include NewRelic::Agent::Instrumentation::Rack
end

use NewRelicMiddleware
use Ping::Middleware

app = Rack::Builder.new do
  if ENV['RACK_ENV'] == 'development'
    require 'qless/server'
    Qless::Server.client = Canvas::App::Connection.create.qless
    map('/qless') {run Qless::Server.new}
  end

  run Canvas::App::App
end

run app
