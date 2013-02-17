#encoding: utf-8

require_relative './headless_request_helper'

def local_mode_enabled?(page)
  page.has_selector?('iframe').must_equal true
  src  = page.evaluate_script('document.getElementById("html5frame").src')
  src == 'http://example.com/local-mode'
end

describe "Local Mode" do
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
    @local_mode_options = @game_options[:configuration].merge('url' => 'http://example.com/local-mode')
    @game = Devcenter::Backend::Game.create(APP_TOKEN, @game_options)
  end

  after do
    Capybara.reset_sessions!
    Capybara.use_default_driver
  end

  it "is delivering the pure embed without any framing" do
    login(@player['uuid'], @player['name'], @token, domain: 'localhost', path: "/fake-spiral-galaxy/play/#{@game.uuid}")

    @page.visit "/v1/games/#{@game.uuid}/spiral-galaxy"
    local_mode_enabled?(@page).must_equal false

    @game.developer_configuration['local_mode'] = {}
    @game.save
    @page.visit "/v1/games/#{@game.uuid}/spiral-galaxy"
    sleep 2
    local_mode_enabled?(@page).must_equal false

    @game.developer_configuration = @game.developer_configuration.merge('local_mode' => {@player['uuid'] => @local_mode_options})
    @game.save
    @page.visit "/v1/games/#{@game.uuid}/spiral-galaxy"
    sleep 2
    local_mode_enabled?(@page).must_equal true

    @game.developer_configuration = @game.developer_configuration.merge('local_mode' => {'some-other-uuid' => @local_mode_options})
    @game.save
    @page.visit "/v1/games/#{@game.uuid}/spiral-galaxy"
    sleep 2
    local_mode_enabled?(@page).must_equal false
  end
end