require_relative '../spec_helper'

require 'json'
require 'rack/client'

require 'auth-backend/test_helpers'

AUTH_HELPERS = Auth::Backend::TestHelpers.new(AUTH_APP)
def auth_helpers
  AUTH_HELPERS
end

OAUTH_APP = auth_helpers.create_app!
def oauth_app
  OAUTH_APP
end

ENV['QS_OAUTH_CLIENT_ID'] = oauth_app[:id]
ENV['QS_OAUTH_CLIENT_SECRET'] = oauth_app[:secret]
APP_TOKEN = auth_helpers.get_app_token(oauth_app[:id], oauth_app[:secret])
DEV_USER = auth_helpers.create_user!(name: "Devuser", email: "dev-user@example.com", password: 'blabla')

class AuthenticationInjector
  def self.token=(token)
    @token = token
  end

  def self.token
    @token
  end

  def self.reset!
    @token = nil
  end

  def initialize(app)
    @app = app
  end

  def call(env)
    if token = self.class.token
      env['HTTP_AUTHORIZATION'] = "Bearer #{token}"
    end

    @app.call(env)
  end
end

AuthenticationInjector.token = APP_TOKEN

def client
  return @client if @client

  @client = Rack::Client.new {run Canvas::App::AppBuilder.new}
end

def devcenter_client
  return @devcenter_client if @devcenter_client

  @devcenter_client = Rack::Client.new {
    use AuthenticationInjector
    run Devcenter::Backend::API
  }
end

def connection
  @connection ||= Connection.create
end

def create_game(options)
  game = Devcenter::Backend::Game.create(APP_TOKEN, options.clone)
  game.uuid
end

def create_initial_game
  devcenter_client.post "/v1/developers/some-uuid"
  game = {
    name: "Some Game",
    description: "A good game",
    developers: [DEV_USER['uuid']],
    configuration: {'type' => 'html5', 'url' => 'http://example.com/test-game'}
  }
  uuid = create_game(game)

  [game, uuid]
end

devcenter_client.post("/v1/developers/#{DEV_USER['uuid']}")
