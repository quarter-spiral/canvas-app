#encoding: utf-8

require_relative './headless_request_helper'

def game_options
  @count ||= 0
  @count += 1

  developer = UUID.new.generate
  Devcenter::Backend::Connection.create.graph.add_role(developer, APP_TOKEN, 'developer')

  {:name => "Test Game #{@count}", :description => "Good game", :category => 'Jump n Run', :configuration => {'type' => 'html5', 'url' => 'http://example.com'},:developers => [developer], :venues => {"spiral-galaxy" => {"enabled" => true}}}
end

def create_game_and_get_friendbar_values(merge_options = nil)
  game_options = game_options()
  game_options[:configuration] = game_options[:configuration].merge(merge_options) if merge_options
  game = Devcenter::Backend::Game.create(APP_TOKEN, game_options)
  page = Capybara.current_session
  page.visit "/v1/games/#{game.uuid}/spiral-galaxy"
  page.has_selector?('script[src="/angular-commons/javascripts/envs.js"]').must_equal true
  values = page.evaluate_script('window.qs.info.friendbar.values')
  values
end


describe "Friendbar" do
  before do
    @page = Capybara.current_session
    @page.driver.remove_cookie('qs_authentication')

    @page.visit '/'

    uri = URI.parse(@page.current_url)
    ENV['QS_CANVAS_APP_URL'] = "http://localhost:#{uri.port}/"
    ENV['QS_DEVCENTER_BACKEND_URL'] = "http://localhost:#{uri.port}/fake-devcenter"
    ENV['QS_SPIRAL_GALAXY_URL'] = "http://localhost:#{uri.port}/fake-spiral-galaxy"
    ENV['QS_SDK_APP_URL'] = "http://localhost:#{uri.port}/fake-sdk"
    ENV['QS_PLAYERCENTER_BACKEND_URL'] = "http://localhost:#{uri.port}/fake-playercenter"

    @connection ||= Devcenter::Backend::Connection.create

    @player = AUTH_HELPERS.user_data
    @token = AUTH_HELPERS.get_token
    @player['name'] = "Thorben Schröder"
    @connection.graph.add_role(@player['uuid'], APP_TOKEN, 'player')
  end

  after do
    Capybara.reset_sessions!
    Capybara.use_default_driver
  end

  describe "can puts the right information into the DOM" do
    it "shows top values" do
      login(@player['uuid'], @player['name'], @token, domain: 'localhost')

      values = create_game_and_get_friendbar_values
      values.must_equal({})

      values = create_game_and_get_friendbar_values(
        'friendbarTopValueLabel' => "Top"
      )
      values.must_equal({})

      values = create_game_and_get_friendbar_values(
        'friendbarTopValueLabel' => "Top",
        'friendbarTopValueKey' => "theKey"
      )
      values['top']['key'].must_equal('theKey')
      values['top']['label'].must_equal('Top')
    end

    it "is empty when only key is set" do
      login(@player['uuid'], @player['name'], @token, domain: 'localhost')
      values = create_game_and_get_friendbar_values(
        'friendbarBottomValueKey' => "boootom"
      )
      values.must_equal({})
    end

    it 'shows bottom values' do
      login(@player['uuid'], @player['name'], @token, domain: 'localhost')
      values = create_game_and_get_friendbar_values(
        'friendbarBottomValueLabel' => "The bottom",
        'friendbarBottomValueKey' => "boootom"
      )
      values['bottom']['key'].must_equal('boootom')
      values['bottom']['label'].must_equal('The bottom')
    end

    it "it shows both values" do
      login(@player['uuid'], @player['name'], @token, domain: 'localhost')
      values = create_game_and_get_friendbar_values(
        'friendbarTopValueLabel' => "Top",
        'friendbarTopValueKey' => "theKey",
        'friendbarBottomValueLabel' => "The bottom",
        'friendbarBottomValueKey' => "boootom"
      )
      values['top']['key'].must_equal('theKey')
      values['top']['label'].must_equal('Top')
      values['bottom']['key'].must_equal('boootom')
      values['bottom']['label'].must_equal('The bottom')
    end
  end

  it "can display a correct friendbar" do
    token = connection.auth.venue_token(APP_TOKEN, 'spiral-galaxy', {"venue-id" => 'some-one', "name" => "Paul II"})
    friend_uuid = connection.auth.token_owner(token)['uuid']

    game_options = game_options()
    game_options[:configuration] = game_options[:configuration].merge(
      'friendbarTopValueLabel' => "Score",
      'friendbarTopValueKey' => "highScore",
      'friendbarBottomValueLabel' => "Level",
      'friendbarBottomValueKey' => "lastLevel"
    )
    game = Devcenter::Backend::Game.create(APP_TOKEN, game_options)

    playercenter_connection = Canvas::App::Connection.create.playercenter
    playercenter_connection.register_player(friend_uuid, game.uuid, 'spiral-galaxy', APP_TOKEN)
    connection.graph.add_relationship(friend_uuid, game.uuid, APP_TOKEN, 'plays', meta: {"#{Playercenter::Backend::MetaData::PREFIX}highScore" => 654, "#{Playercenter::Backend::MetaData::PREFIX}lastLevel" => 'Tower'})
    connection.graph.add_relationship(@player['uuid'], friend_uuid, APP_TOKEN, 'friends')

    login(@player['uuid'], @player['name'], @token, domain: 'localhost')
    @page.visit "/v1/games/#{game.uuid}/spiral-galaxy"
    sleep 2
    @page.evaluate_script('$("a:contains(\"Sort by Score\")").length').must_equal 1
    @page.evaluate_script('$("a:contains(\"Sort by Level\")").length').must_equal 1

    sleep 2
    @page.evaluate_script('$("div.top-value:contains(\"654\")").length').must_equal 1
    @page.evaluate_script('$("div.bottom-value:contains(\"Tower\")").length').must_equal 1
  end

  it "can display default values" do
    token = connection.auth.venue_token(APP_TOKEN, 'spiral-galaxy', {"venue-id" => 'some-one', "name" => "Paul II"})
    friend_uuid = connection.auth.token_owner(token)['uuid']

    game_options = game_options()
    game_options[:configuration] = game_options[:configuration].merge(
      'friendbarTopValueLabel' => "Score",
      'friendbarTopValueKey' => "highScore"
    )
    game = Devcenter::Backend::Game.create(APP_TOKEN, game_options)

    playercenter_connection = Canvas::App::Connection.create.playercenter
    playercenter_connection.register_player(friend_uuid, game.uuid, 'spiral-galaxy', APP_TOKEN)
    connection.graph.add_relationship(friend_uuid, game.uuid, APP_TOKEN, 'plays')
    connection.graph.add_relationship(@player['uuid'], friend_uuid, APP_TOKEN, 'friends')

    login(@player['uuid'], @player['name'], @token, domain: 'localhost')

    @page.visit "/v1/games/#{game.uuid}/spiral-galaxy"
    sleep 2
    @page.has_selector?('div.top-value', visible: true).must_equal false

    game_options = game_options()
    game_options[:configuration] = game_options[:configuration].merge(
      'friendbarTopValueLabel' => "Score",
      'friendbarTopValueKey' => "highScore",
      'friendbarTopValueDefault' => 123
    )
    game = Devcenter::Backend::Game.create(APP_TOKEN, game_options)
    playercenter_connection.register_player(friend_uuid, game.uuid, 'spiral-galaxy', APP_TOKEN)
    connection.graph.add_relationship(friend_uuid, game.uuid, APP_TOKEN, 'plays')
    @page.visit "/v1/games/#{game.uuid}/spiral-galaxy"
    sleep 1
    @page.has_selector?('div.top-value', visible: true, text: '123').must_equal true

    connection.graph.add_relationship(friend_uuid, game.uuid, APP_TOKEN, 'plays', meta: {"#{Playercenter::Backend::MetaData::PREFIX}highScore" => 654})
    @page.visit "/v1/games/#{game.uuid}/spiral-galaxy"
    @page.has_selector?('div.top-value', visible: true, text: '654').must_equal true
  end
end