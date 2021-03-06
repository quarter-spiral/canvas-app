#encoding: utf-8

require_relative './headless_request_helper'

describe Canvas::App::Venue::SpiralGalaxy do
  before do
    @page = Capybara.current_session
    @page.driver.remove_cookie('qs_authentication')

    @page.visit '/'

    uri = URI.parse(@page.current_url)
    ENV['QS_CANVAS_APP_URL'] = "http://localhost:#{uri.port}/"
    ENV['QS_DEVCENTER_BACKEND_URL'] = "http://localhost:#{uri.port}/fake-devcenter"
    ENV['QS_SPIRAL_GALAXY_URL'] = "http://localhost:#{uri.port}/fake-spiral-galaxy"

    @connection ||= Devcenter::Backend::Connection.create

    @developer = UUID.new.generate
    @connection.graph.add_role(@developer, APP_TOKEN, 'developer')

    @player = AUTH_HELPERS.user_data
    @token = AUTH_HELPERS.get_token
    @player['name'] = "Thorben Schröder"
    @connection.graph.add_role(@player['uuid'], APP_TOKEN, 'player')

    @game_options = {:name => "Test Game 1", :description => "Good game", :category => 'Jump n Run', :configuration => {'type' => 'html5', 'url' => 'http://example.com'},:developers => [@developer], :venues => {"spiral-galaxy" => {"enabled" => true}}}
    @game = Devcenter::Backend::Game.create(APP_TOKEN, @game_options)
  end

  after do
    Capybara.reset_sessions!
    Capybara.use_default_driver
  end

  it "can puts the right information into the DOM" do
    login(@player['uuid'], @player['name'], @token, domain: 'localhost', path: "/fake-spiral-galaxy/play/#{@game.uuid}")
    @page.visit "/v1/games/#{@game.uuid}/spiral-galaxy"
    @page.has_selector?('iframe').must_equal true

    dom_info = nil
    tries = 0
    while !dom_info && tries < 5
      sleep 1 if tries > 0
      dom_info = @page.evaluate_script('window.qs')
      tries += 1
    end

    dom_info['tokens']['qs'].must_equal @token
    dom_info['tokens']['venue'].must_equal @token
    dom_info['info']['game'].must_equal @game.uuid
    dom_info['info']['uuid'].must_equal @player['uuid']
  end

  it "can puts the right information into the DOM when not logged in" do
    @page.visit "/v1/games/#{@game.uuid}/spiral-galaxy"
    sleep 2
    @page.has_selector?('iframe').must_equal true

    dom_info = nil
    tries = 0
    while !dom_info && tries < 5
      sleep 1 if tries > 0
      dom_info = @page.evaluate_script('window.qs')
      tries += 1
    end

    dom_info['tokens'].wont_be_nil
    dom_info['tokens']['qs'].must_be_nil
    dom_info['tokens']['venue'].must_be_nil
    dom_info['info']['game'].must_equal @game.uuid
    dom_info['info']['uuid'].must_be_nil
  end
end