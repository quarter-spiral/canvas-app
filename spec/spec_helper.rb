Bundler.setup

ENV['RACK_ENV'] ||= 'test'

require 'minitest/autorun'

require 'canvas-app'

require 'datastore-backend'

module Canvas::App
  class Connection
    alias raw_initialize initialize
    def initialize(*args)
      result = raw_initialize(*args)

      datatstore_adapter = Service::Client::Adapter::Faraday.new(adapter: [:rack, Datastore::Backend::API.new])
      @datastore.client.raw.adapter = datatstore_adapter

      result
    end
  end
end
