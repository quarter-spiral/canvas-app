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
  end
end
