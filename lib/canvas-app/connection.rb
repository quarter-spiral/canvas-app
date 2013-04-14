module Canvas::App
  class Connection
    attr_reader :datastore, :auth, :playercenter, :redis, :qless, :tracking, :cache

    def self.create
      self.new(
        ENV['QS_DATASTORE_BACKEND_URL'] || 'http://datastore-backend.dev',
        ENV['QS_AUTH_BACKEND_URL'] || 'http://auth-backend.dev',
        ENV['QS_PLAYERCENTER_BACKEND_URL'] || 'http://playercenter-backend.dev',
        ENV['MYREDIS_URL'] || 'redis://localhost:6379/',
        ENV['QS_TRACKING_REDIS_URL'] || 'redis://localhost:6379/'
      )
    end

    def initialize(datastore_backend_url, auth_backend_url, playercenter_backend_url, redis_url, tracking_backend_url)
      @datastore = ::Datastore::Client.new(datastore_backend_url)
      @auth = ::Auth::Client.new(auth_backend_url)
      @playercenter = ::Playercenter::Client.new(playercenter_backend_url)
      @tracking = ::Tracking::Client.new(tracking_backend_url)

      redis_uri = URI.parse(redis_url)

      redis_config = {
        host: redis_uri.host,
        port: redis_uri.port,
        password: redis_uri.password
      }

      @redis = Redis.new(redis_config)

      @qless = Qless::Client.new(redis_config)

      @cache = ::Cache::Client.new(::Cache::Backend::IronCache, ENV['IRON_CACHE_PROJECT_ID'], ENV['IRON_CACHE_TOKEN'], ENV['IRON_CACHE_CACHE'])
    end

    def facebook(client_id, client_secret)
      ::Facebook::Client.new(client_id, client_secret)
    end
  end
end
