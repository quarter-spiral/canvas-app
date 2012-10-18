Bundler.setup

ENV['RACK_ENV'] ||= 'test'

require 'minitest/autorun'

require 'canvas-app'

require 'datastore-backend'
require 'graph-backend'
require 'auth-backend'

require 'facebook-client/fixtures'

AUTH_APP = Auth::Backend::App.new(test: true)

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
end

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

module Canvas::App
  class Connection
    alias raw_initialize initialize
    def initialize(*args)
      raw_initialize(*args)

      @datastore.client.raw.adapter = FakeAdapters.datastore
      @auth = FakeAdapters.auth
    end

    def facebook(client_id, client_secret)
      @facebook = ::Facebook::Client.new(client_id, client_secret, adapter: :mock)
      @facebook.adapter.authorization_url = "http://mygame.example.com"
      @facebook
    end
  end
end

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
