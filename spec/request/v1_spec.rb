require_relative '../spec_helper.rb'

require 'json'
require 'rack/client'

include Canvas::App

def client
  return @client if @client

  @client = Rack::Client.new {run App}
end

def devcenter_client
  return @devcenter_client if @devcenter_client

  @devcenter_client = Rack::Client.new {run Devcenter::Backend::API}
end

def connection
  @connection ||= Connection.create
end

def create_game(options)
  game = Devcenter::Backend::Game.create(options.clone)
  game.uuid
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
      devcenter_client.post "/v1/developers/some-uuid"
      @game = {
        name: "Some Game",
        description: "A good game",
        developers: ['some-uuid'],
        configuration: {'type' => 'html5', 'url' => 'http://example.com/test-game'}
      }
      @uuid = create_game(@game)
    end

    it "does not work with no venue" do
      @response = client.get("/v1/games/#{@uuid}")
      @response.status.wont_equal 200
    end

    it "does not work with the galaxy-sprial venue when not enabled" do
      @response = client.get("/v1/games/#{@uuid}/galaxy-spiral")
      @response.status.must_equal 404
    end

    it "does not work with the facebook venue when not enabled" do
      @response = client.get("/v1/games/#{@uuid}/facebook")
      @response.status.must_equal 404
    end

    describe "on the galaxy-spiral venue" do
      before do
        @game[:venues] = {'galaxy-spiral' => true}
        devcenter_client.put("/v1/games/#{@uuid}", {}, JSON.dump(venues: {'galaxy-spiral' => true}))
        @response = client.get("/v1/games/#{@uuid}/galaxy-spiral")
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

      describe "thas is a flash game" do
        it "has an object with the game's url" do
          @game[:configuration]['type'] = 'flash'
          @uuid = create_game(@game)
          @response = client.get("/v1/games/#{@uuid}/galaxy-spiral")

          @response.body.must_match /<object [^>]*type="application\/x-shockwave-flash"\s+[^>]*data="http:\/\/example.com\/test-game"/
        end
      end

      describe "that is an initial game" do
        it "responds with a blank 404" do
          @game[:configuration]['type'] = 'initial'
          @uuid = create_game(@game)
          @response = client.get("/v1/games/#{@uuid}/galaxy-spiral")

          @response.status.must_equal 404
          @response.body.must_equal ''
        end
      end
    end

    describe "on the facebook venue" do
      before do
        @game[:venues] = {'facebook' => true}
        devcenter_client.put("/v1/games/#{@uuid}", {}, JSON.dump(venues: {'facebook' => true}))
        @response = client.get("/v1/games/#{@uuid}/facebook")
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

      describe "thas is a flash game" do
        it "has an object with the game's url" do
          @game[:configuration]['type'] = 'flash'
          @uuid = create_game(@game)
          @response = client.get("/v1/games/#{@uuid}/facebook")

          @response.body.must_match /<object [^>]*type="application\/x-shockwave-flash"\s+[^>]*data="http:\/\/example.com\/test-game"/
        end
      end

      describe "that is an initial game" do
        it "responds with a blank 404" do
          @game[:configuration]['type'] = 'initial'
          @uuid = create_game(@game)
          @response = client.get("/v1/games/#{@uuid}/facebook")

          @response.status.must_equal 404
          @response.body.must_equal ''
        end
      end
    end
  end
end
