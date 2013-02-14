#encoding: utf-8

require_relative './headless_request_helper'

describe Canvas::App::Venue::Embedded do
  before do
    @page = Capybara.current_session
    @page.driver.remove_cookie('qs_authentication')

    @page.visit '/'

    uri = URI.parse(@page.current_url)
    ENV['QS_CANVAS_APP_URL'] = "http://localhost:#{uri.port}/"
    ENV['QS_DEVCENTER_BACKEND_URL'] = "http://localhost:#{uri.port}/fake-devcenter"

    @connection ||= Devcenter::Backend::Connection.create

    @developer = UUID.new.generate
    @connection.graph.add_role(@developer, APP_TOKEN, 'developer')

    @player = AUTH_HELPERS.user_data
    @token = AUTH_HELPERS.get_token
    @player['name'] = "Thorben Schröder"
    @connection.graph.add_role(@player['uuid'], APP_TOKEN, 'player')

    @game_options = {:name => "Test Game 1", :description => "Good game", :category => 'Jump n Run', :configuration => {'type' => 'html5', 'url' => 'http://example.com'},:developers => [@developer], :venues => {"embedded" => {"enabled" => true}}}
    @game = Devcenter::Backend::Game.create(APP_TOKEN, @game_options)
  end

  after do
    Capybara.reset_sessions!
    Capybara.use_default_driver
  end

  it "is delivering the pure embed without any framing" do
    login(@player['uuid'], @player['name'], @token, domain: 'localhost')
    @page.visit "/v1/games/#{@game.uuid}/embedded"

    @page.has_selector?('iframe').must_equal true

    dom_info = @page.evaluate_script('window.qs');
    dom_info['tokens'].keys.sort.must_equal ['qs', 'venue']
    dom_info['tokens']['qs'].must_be_nil
    dom_info['tokens']['venue'].must_be_nil
    dom_info['info']['game'].must_equal @game.uuid
    dom_info['info']['uuid'].must_be_nil
  end
end