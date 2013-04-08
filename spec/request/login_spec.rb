#encoding: utf-8

require_relative './headless_request_helper'

describe "Login" do
  before do
    @page = Capybara.current_session
    @page.driver.remove_cookie('qs_authentication')

    @page.visit '/'

    uri = URI.parse(@page.current_url)
    ENV['QS_CANVAS_APP_URL'] = "http://localhost:#{uri.port}"
    ENV['QS_DEVCENTER_BACKEND_URL'] = "http://localhost:#{uri.port}/fake-devcenter"
    ENV['QS_SPIRAL_GALAXY_URL'] = "http://localhost:#{uri.port}/fake-spiral-galaxy"
    ENV['QS_SDK_APP_URL'] = "http://localhost:#{uri.port}/fake-sdk"
    ENV['QS_PLAYERCENTER_BACKEND_URL'] = "http://localhost:#{uri.port}/fake-playercenter"

    AUTH_HELPERS.set_app_redirect_uri!(OAUTH_APP[:internal_id], "http://localhost:#{uri.port}/auth/auth_backend/callback")

    @connection ||= Devcenter::Backend::Connection.create

    AUTH_HELPERS.delete_existing_users!
    @player = AUTH_HELPERS.create_user!(name: "Loginnor", email: "loginnor@example.com", password: 'blabla')
    @connection.graph.add_role(@player['uuid'], APP_TOKEN, 'player')

    @developer = UUID.new.generate
    @connection.graph.add_role(@developer, APP_TOKEN, 'developer')

    app_id = ::Facebook::Client::Fixtures.client_id
    app_secret = ::Facebook::Client::Fixtures.client_secret

    @game_options = {:name => "Test Game 1", :description => "Good game", :configuration => {'type' => 'html5', 'url' => 'http://example.com'},:developers => [@developer], :category => 'Jump n Run', :venues => {"spiral-galaxy" => {"enabled" => true}, "embedded" => {"enabled" => true}, 'facebook' => {'enabled' => true, 'app-id' => app_id, 'app-secret' => app_secret}}}
    @game = Devcenter::Backend::Game.create(APP_TOKEN, @game_options)

    Capybara.current_session.driver.remove_cookie('qs_canvas_authentication')
  end

  after do
    Capybara.reset_sessions!
    Capybara.use_default_driver
  end

  it "is possible to login with auth backend for embedded games" do
    @page.visit "#{ENV['QS_CANVAS_APP_URL']}/v1/games/#{@game.uuid}/embedded"
    @page.has_selector?('a', text: /Log out/, visible: true).must_equal false
    tries = 0
    while tries < 5 && !@page.has_selector?('a', text: /Login/)
      sleep 0.1
      tries += 1
    end
    @page.has_selector?('a', text: /Login/).must_equal true

    @page.click_link 'Login'
    @page.fill_in 'Name', with: @player['name']
    @page.fill_in 'Password', with: @player['password']
    @page.click_button 'Log in'
    @page.click_button 'Allow'

    tries = 0
    while tries < 5 && !@page.has_selector?('div', text: /#{@player['name']}/, visible: true)
      sleep 0.1
      tries += 1
    end
    @page.has_selector?('div', text: /#{@player['name']}/, visible: true).must_equal true
  end

  #TODO: Fix the error Facebook causes in this test
  #it "is not to login with auth backend for facebook games" do
  #  @page.visit "#{ENV['QS_CANVAS_APP_URL']}/v1/games/#{@game.uuid}/facebook"
  #
  #  @page.has_selector?('a', text: /Log in/, visible: true).must_equal false
  #end
end