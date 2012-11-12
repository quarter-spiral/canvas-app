require_relative './request_spec_helper.rb'

include Canvas::App

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
      @game, @uuid = create_initial_game
    end

    it "does not work with no venue" do
      @response = client.get("/v1/games/#{@uuid}")
      @response.status.wont_equal 200
    end

    it "does not work with the galaxy-sprial venue when not enabled" do
      @response = client.get("/v1/games/#{@uuid}/spiral-galaxy")
      @response.status.must_equal 404
    end

    it "does not work with the facebook venue when not enabled" do
      @response = client.get("/v1/games/#{@uuid}/facebook")
      @response.status.must_equal 404
    end

    describe "on the spiral-galaxy venue" do
      before do
        @game[:venues] = {'spiral-galaxy' => {'enabled' => true}}
        devcenter_client.put("/v1/games/#{@uuid}", {}, JSON.dump(venues: @game[:venues]))
        @response = client.get("/v1/games/#{@uuid}/spiral-galaxy")
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
          @response = client.get("/v1/games/#{@uuid}/spiral-galaxy")

          @response.body.must_match /<object [^>]*type="application\/x-shockwave-flash"\s+[^>]*data="http:\/\/example.com\/test-game"/
        end
      end

      describe "that is an initial game" do
        it "responds with a blank 404" do
          @game[:configuration]['type'] = 'initial'
          @uuid = create_game(@game)
          @response = client.get("/v1/games/#{@uuid}/spiral-galaxy")

          @response.status.must_equal 404
          @response.body.must_equal ''
        end
      end

      it "handles token expiration" do
        auth_helpers.expire_all_tokens!
        APP_TOKEN.gsub!(/^.*$/, auth_helpers.get_app_token(oauth_app[:id], oauth_app[:secret]))
        AuthenticationInjector.token = APP_TOKEN
        @response = client.get("/v1/games/#{@uuid}/spiral-galaxy")
        @response.status.must_equal 200
        @response.body.must_match /<title>Some Game<\/title>/
      end
    end
  end
end
