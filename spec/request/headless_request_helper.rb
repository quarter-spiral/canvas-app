#encoding: utf-8

require_relative '../spec_helper'

require 'cgi'
require 'capybara'
require 'capybara/dsl'
require 'capybara/poltergeist'
require_relative './poltergeist_hack_from_hell'

# Make sure Capybara fucks itself and actually shows errors happening in our webapp.
require 'rack/handler/thin'
Thin::Logging
module Thin::Logging
  def self.silent?
  end
end
module Thin
  class Connection
    def threaded?
      true
    end
  end
end

ENV['QS_AUTH_BACKEND_URL'] = 'http://auth-backend.dev'

def login(uuid, name, token, options = {})
  Capybara.current_session.driver.set_cookie('qs_authentication', CGI::escape(JSON.dump(info: {uuid: uuid, name: name, token: token})), options)
end

AUTH_SERVER = Capybara::Server.new(AUTH_APP).boot
ENV['QS_AUTH_BACKEND_URL'] = "http://localhost:#{AUTH_SERVER.port}"
Canvas::App.send(:remove_const, :AuthBackend)
load File.expand_path("../../../lib/canvas-app/auth_backend.rb", __FILE__)

ENV['QS_COOKIE_SECRET'] ||= "some-secret"

SPIRAL_GALAXY_APP = Spiral::Galaxy::App.new
SDK_APP = Sdk::App::App.new

APP = Rack::Builder.new {
  map '/fake-spiral-galaxy' do
    run SPIRAL_GALAXY_APP
  end

  map '/fake-devcenter' do
    run DEVCENTER_APP
  end

  map '/fake-playercenter' do
    run PLAYERCENTER_APP
  end

  map '/sdk-app' do
    run SDK_APP
  end

  run Canvas::App::AppBuilder.new
}

Capybara.register_driver :poltergeist do |app|
  Capybara::Poltergeist::Driver.new(APP, debug: false)
end
Capybara.default_driver = :poltergeist