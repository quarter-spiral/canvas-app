require_relative '../spec_helper.rb'

require 'json'
require 'rack/client'

include Canvas::App

def client
  return @client if @client

  @client = Rack::Client.new {run App}
end

def connection
  @connection ||= Connection.create
end

def create_game(options)
  uuid = connection.datastore.create(:public, game: options)
end

describe App do
  it "responds with 404 if no uuid is passed" do
    response = client.get('/v1/games/')
    response.status.must_equal 404
  end

  it "responds with 404 if a non existing uuid is passed" do
    response = client.get('/v1/games/non-existing')
    response.status.must_equal 404
  end

  describe "with an existing game" do
    before do
      @game = {
        name: "Some Game",
        description: "A good game",
        developers: ['some-uuid'],
        configuration: {type: 'html5', url: 'http://example.com/test-game'}
      }
      @uuid = create_game(@game)
      @response = client.get("/v1/games/#{@uuid}")
    end

    it "responds with 200" do
      @response.status.must_equal 200
    end

    it "has the name of the game as the pages title and headline" do
      @response.body.must_match /<title>Some Game<\/title>/
      @response.body.must_match /<h1>Some Game<\/h1>/
    end

    describe "that is an html5 game" do
      it "has an iframe with the game's url" do
        @response.body.must_match /<iframe [^>]*src="http:\/\/example.com\/test-game"/
      end
    end
  end
end
