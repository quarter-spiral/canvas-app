require_relative './request_spec_helper'

describe "on the facebook venue" do
  before do
    FakeAdapters.reset_facebook!
    @game, @uuid = create_initial_game

    @app_id = ::Facebook::Client::Fixtures.client_id
    @app_secret = ::Facebook::Client::Fixtures.client_secret
    @fb_token = ::Facebook::Client::Fixtures.signed_request_data['oauth_token']
    @fb_adapter = connection.facebook(@app_id, @app_secret).adapter
    @fb_adapter.token_owner[@fb_token] = {'name' => 'Peter', 'email' => 'peter@example.com', 'id' => '123'}
    @game[:venues] = {'facebook' => {'enabled' => true, 'app-id' => @app_id, 'app-secret' => @app_secret}}
    devcenter_client.put("/v1/games/#{@uuid}", {}, JSON.dump(venues: @game[:venues]))

    #clear all jobs
    queue = connection.qless.queues['jobs']
    while job = queue.pop
      job.cancel
    end
  end

  it "errors out on GET requests" do
    @response = client.get("/v1/games/#{@uuid}/facebook")
    @response.status.must_equal 302
    @response['Location'].must_equal ::Facebook::Client.new(@app_id, @app_secret).unauthenticated.app_url
  end

  it "friends get added to our system when a player plays a game on our system" do
    facebook_id = "7289573"
    fb_token = '324-45231-dsf32-324234'
    @fb_adapter.token_owner[fb_token] = {'name' => 'Guilherme', 'email' => 'guilherme@example.com', 'id' => facebook_id}
    token = connection.auth.venue_token(APP_TOKEN, 'facebook', {"venue-id" => facebook_id, "name" => "Peter"})
    uuid = connection.auth.token_owner(token)['uuid']

    fake_friend_class = Struct.new(:identifier, :name, :email)
    connection.facebook(@app_id, @app_secret).adapter.friends[facebook_id] = [
      fake_friend_class.new('21312313', 'Jacko Smith', nil),
      fake_friend_class.new('32948990', 'Paul Toddlo', nil)
    ]

    connection.playercenter.friends_of(uuid, token).must_be_empty
    signed_request = ::Facebook::Client::Fixtures.signed_request(user_id: facebook_id, oauth_token: fb_token)

    @response = client.post("/v1/games/#{@uuid}/facebook", {}, signed_request: signed_request)

    job = connection.qless.queues['jobs'].pop
    job.wont_be_nil
    job.perform

    friends = connection.playercenter.friends_of(uuid, token)
    friends.keys.size.must_equal 2
    friends.values.must_include("facebook" => {"id" => "21312313", "name" => "Jacko Smith"})
    friends.values.must_include("facebook" => {"id" => "32948990", "name" => "Paul Toddlo"})
  end

  describe "with a request" do
    before do
      @response = client.post("/v1/games/#{@uuid}/facebook", {}, signed_request: ::Facebook::Client::Fixtures.signed_request)
    end

    it "responds with 200 for POST request" do
      @response = client.post("/v1/games/#{@uuid}/facebook", {}, signed_request: ::Facebook::Client::Fixtures.signed_request)
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
        @response = client.post("/v1/games/#{@uuid}/facebook", {}, signed_request: ::Facebook::Client::Fixtures.signed_request)

        @response.body.must_match /<object [^>]*type="application\/x-shockwave-flash"\s+[^>]*data="http:\/\/example.com\/test-game"/
      end
    end

    describe "that is an initial game" do
      it "responds with a blank 404" do
        @game[:configuration]['type'] = 'initial'
        @uuid = create_game(@game)
        @response = client.post("/v1/games/#{@uuid}/facebook")

        @response.status.must_equal 404
        @response.body.must_equal ''
      end
    end

  end
end

