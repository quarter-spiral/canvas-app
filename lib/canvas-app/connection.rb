module Canvas::App
  class Connection
    attr_reader :datastore

    def self.create
      self.new(ENV['QS_DATASTORE_BACKEND_URL'] || 'http://datastore-backend.dev')
    end

    def initialize(datastore_backend_url)
      @datastore = ::Datastore::Client.new(datastore_backend_url)
    end
  end
end
