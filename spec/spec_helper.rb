Bundler.setup

ENV['RACK_ENV'] ||= 'test'

require 'minitest/autorun'

require 'rack/client'

require 'canvas-app'

require 'datastore-backend'
require 'graph-backend'
require 'auth-backend'
require 'playercenter-backend'
require 'spiral-galaxy'

require 'facebook-client/fixtures'

class FakeAdapters
  def self.datastore
    @adapter ||= Service::Client::Adapter::Faraday.new(adapter: [:rack, Datastore::Backend::API.new])
  end

  def self.graph
    @graph ||= Service::Client::Adapter::Faraday.new(adapter: [:rack, Graph::Backend::API.new])
  end

  def self.auth
    @auth ||= Auth::Client.new('http://auth-backend.dev', adapter: [:rack, AUTH_APP])
  end

  def self.playercenter
    @playercenter ||= Service::Client::Adapter::Faraday.new(adapter: [:rack, Playercenter::Backend::API.new])
  end

  def self.facebook(client_id, client_secret)
    @facebooks ||= {}
    @facebooks[[client_id, client_secret]] ||= ::Facebook::Client.new(client_id, client_secret, adapter: :mock)
  end

  def self.devcenter
    @devcenter ||= Service::Client::Adapter::Faraday.new(adapter: [:rack, DEVCENTER_APP])
  end

  def self.reset_facebook!
    @facebooks = nil
  end
end

module Auth::Backend
  class Connection
    alias raw_initialize initialize
    def initialize(*args)
      raw_initialize(*args)
      @graph.client.raw.adapter = FakeAdapters.graph
    end
  end
end

AUTH_APP = Auth::Backend::App.new(test: true)

module Datastore::Backend
  class Connection
    alias raw_initialize initialize
    def initialize(*args)
      raw_initialize(*args)
      @auth = FakeAdapters.auth
    end
  end
end

module Graph::Backend
  class Connection
    alias raw_initialize initialize
    def initialize(*args)
      raw_initialize(*args)
      @auth = FakeAdapters.auth
    end
  end
end

DEVCENTER_APP = Devcenter::Backend::API.new

module Devcenter::Backend
  class Connection
    alias raw_initialize initialize
    def initialize(*args)
      result = raw_initialize(*args)

      @datastore.client.raw.adapter = FakeAdapters.datastore
      @graph.client.raw.adapter = FakeAdapters.graph
      @auth = FakeAdapters.auth

      result
    end
  end
end

module Playercenter::Backend
  class Connection
    alias raw_initialize initialize
    def initialize(*args)
      raw_initialize(*args)

      @graph.client.raw.adapter = FakeAdapters.graph
      @devcenter.client.raw.adapter = FakeAdapters.devcenter
      @auth = FakeAdapters.auth
    end
  end
end

module Spiral::Galaxy
  class Connection
    alias raw_initialize initialize
    def initialize(*args)
      raw_initialize(*args)

      @devcenter.client.raw.adapter = FakeAdapters.devcenter
      @auth = FakeAdapters.auth
    end
  end
end


module Canvas::App
  class Connection
    alias raw_initialize initialize
    def initialize(*args)
      raw_initialize(*args)

      @datastore.client.raw.adapter = FakeAdapters.datastore
      @auth = FakeAdapters.auth
      @playercenter.client.raw.adapter = FakeAdapters.playercenter
    end

    def facebook(client_id, client_secret)
      client = FakeAdapters.facebook(client_id, client_secret)
      client.adapter.authorization_url = "http://mygame.example.com"
      client
    end
  end
end

# Wipe the graph
connection = Graph::Backend::Connection.create.neo4j
(connection.find_node_auto_index('uuid:*') || []).each do |node|
  connection.delete_node!(node)
end

require 'auth-backend/test_helpers'
AUTH_HELPERS = Auth::Backend::TestHelpers.new(AUTH_APP)
OAUTH_APP = AUTH_HELPERS.create_app!
ENV['QS_OAUTH_CLIENT_ID'] = OAUTH_APP[:id]
ENV['QS_OAUTH_CLIENT_SECRET'] = OAUTH_APP[:secret]

APP_TOKEN = Devcenter::Backend::Connection.create.auth.create_app_token(OAUTH_APP[:id], OAUTH_APP[:secret])