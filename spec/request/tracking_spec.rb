#encoding: utf-8

require_relative './request_spec_helper'
require 'tracking-client/test_helpers'

describe Canvas::App do
  before do
    Thread.abort_on_exception = true

    ENV['QS_SPIRAL_GALAXY_URL'] = 'http://example.com'

    @connection = Canvas::App::Connection.create

    @developer = UUID.new.generate
    devcenter_connection = Devcenter::Backend::Connection.create
    devcenter_connection.graph.add_role(@developer, APP_TOKEN, 'developer')

    @player = AUTH_HELPERS.user_data
    @token = AUTH_HELPERS.get_token
    @player['name'] = "Thorben Schröder"
    devcenter_connection.graph.add_role(@player['uuid'], APP_TOKEN, 'player')

    @app_id = ::Facebook::Client::Fixtures.client_id
    @app_secret = ::Facebook::Client::Fixtures.client_secret
    @game_options = {:name => "Test Game 1", :description => "Good game", :category => 'Jump n Run', :configuration => {'type' => 'html5', 'url' => 'http://example.com'},:developers => [@developer], :venues => {"embedded" => {"enabled" => true}, "facebook" => {"enabled" => true, "app-id" => @app_id, "app-secret" => @app_secret}}}
    @game = Devcenter::Backend::Game.create(APP_TOKEN, @game_options)

    @fb_token = ::Facebook::Client::Fixtures.signed_request_data['oauth_token']
    @fb_adapter = connection.facebook(@app_id, @app_secret).adapter
    @fb_adapter.token_owner[@fb_token] = {'name' => 'Peter', 'email' => 'peter@example.com', 'id' => '123'}

    Tracking::Client::TestHelpers.delete_all_tracked_events!(@connection.tracking)
  end

  it "is tracking plays" do
    @connection.tracking.query_impression("game-played", :day).must_equal 0
    @connection.tracking.query_impression("game-played-embedded", :day).must_equal 0
    @connection.tracking.query_impression("game-played-facebook", :day).must_equal 0
    @connection.tracking.query_impression("game-played-#{@game.uuid}", :day).must_equal 0
    @connection.tracking.query_impression("game-played-embedded-#{@game.uuid}", :day).must_equal 0
    @connection.tracking.query_impression("game-played-facebook-#{@game.uuid}", :day).must_equal 0

    client.get("/v1/games/#{@game.uuid}/embedded")
    sleep 2

    @connection.tracking.query_impression("game-played", :day).must_equal 1
    @connection.tracking.query_impression("game-played-embedded", :day).must_equal 1
    @connection.tracking.query_impression("game-played-facebook", :day).must_equal 0
    @connection.tracking.query_impression("game-played-#{@game.uuid}", :day).must_equal 1
    @connection.tracking.query_impression("game-played-embedded-#{@game.uuid}", :day).must_equal 1
    @connection.tracking.query_impression("game-played-facebook-#{@game.uuid}", :day).must_equal 0

    client.post("/v1/games/#{@game.uuid}/facebook", {}, signed_request: ::Facebook::Client::Fixtures.signed_request(user_id: '123', oauth_token: @fb_token))
    sleep 2

    @connection.tracking.query_impression("game-played", :day).must_equal 2
    @connection.tracking.query_impression("game-played-embedded", :day).must_equal 1
    @connection.tracking.query_impression("game-played-facebook", :day).must_equal 1
    @connection.tracking.query_impression("game-played-#{@game.uuid}", :day).must_equal 2
    @connection.tracking.query_impression("game-played-embedded-#{@game.uuid}", :day).must_equal 1
    @connection.tracking.query_impression("game-played-facebook-#{@game.uuid}", :day).must_equal 1
  end
end