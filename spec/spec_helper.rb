Bundler.setup

ENV['RACK_ENV'] ||= 'test'

require 'minitest/autorun'

require 'canvas-app'

require 'datastore-backend'
require 'graph-backend'

class FakeAdapters
  def self.datastore
    @adapter ||= Service::Client::Adapter::Faraday.new(adapter: [:rack, Datastore::Backend::API.new])
  end

  def self.graph
    @graph ||= Service::Client::Adapter::Faraday.new(adapter: [:rack, Graph::Backend::API.new])
  end
end

module Canvas::App
  class Connection
    alias raw_initialize initialize
    def initialize(*args)
      result = raw_initialize(*args)

      @datastore.client.raw.adapter = FakeAdapters.datastore

      result
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

      result
    end
  end
end
