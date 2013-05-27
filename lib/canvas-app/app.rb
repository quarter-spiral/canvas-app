require 'sinatra'
require 'sinatra/assetpack'
require 'uri'
require 'service-client'

module Canvas::App
  CHROME_HEIGHT = 160

  class App < Sinatra::Base
    class TokenStore
      def self.token(connection)
        @token ||= connection.auth.create_app_token(ENV['QS_OAUTH_CLIENT_ID'], ENV['QS_OAUTH_CLIENT_SECRET'])
      end

      def self.reset!
        @token = nil
      end
    end

    set :root, ROOT
    set :protection, :except => [:frame_options, :xss_header]
    set :views, File.expand_path('./venue/views', File.dirname(__FILE__))

    register Sinatra::AssetPack

    assets {
      js_compression  :uglify

      serve '/v1/javascripts', from: 'canvas-app/app/assets/javascripts'
      serve '/v1/stylesheets', from: 'canvas-app/app/assets/stylesheets'
      serve '/v1/images',      from: 'canvas-app/app/assets/images'

      css :application, '/v1/stylesheets/application.css', [
        '/v1/stylesheets/default.css'
      ]

      css :vendor, '/v1/stylesheets/vendor.css', [
        '/v1/stylesheets/vendor/bootstrap.css',
        '/v1/stylesheets/vendor/bootstrap-responsive.css'
      ]

      js  :vendor, '/v1/javascripts/vendor.js', [
        '/v1/javascripts/vendor/event-shim.js',
        '/v1/javascripts/vendor/jquery-1.8.2.min.js',
        '/v1/javascripts/vendor/angular/angular.js',
        '/v1/javascripts/vendor/angular/angular-resource.js',
        '/v1/javascripts/vendor/bootstrap.js',
        '/v1/javascripts/vendor/modernizr-2-6-1.js'
      ]

      js :app, '/v1/javascripts/app.js', [
        '/v1/javascripts/app/app.js',
        '/v1/javascripts/app/services.js',
        '/v1/javascripts/app/controllers.js',
        '/v1/javascripts/app/filters.js',
        '/v1/javascripts/app/directives.js'
      ]
    }

    use Angular::Commons::Middleware

    helpers do
      def connection
        @connection ||= Connection.create
      end

      def token
        TokenStore.token(connection)
      end

      def try_twice_and_avoid_token_expiration
        yield
      rescue Service::Client::ServiceError => e
        raise e unless e.error == 'Unauthenticated'
        TokenStore.reset!
        yield
      end

      def tokens=(tokens)
        @tokens = tokens
      end

      def tokens
        @tokens || {}
      end

      def venue=(venue)
        @venue = venue
      end

      def venue
        @venue || 'none'
      end

      def embedder
        @embedder
      end

      def escape_javascript(html_content)
        return '' unless html_content
        javascript_mapping = { '\\' => '\\\\', '</' => '<\/', "\r\n" => '\n', "\n" => '\n' }
        javascript_mapping.merge("\r" => '\n', '"' => '\\"', "'" => "\\'")
        escaped_string = html_content.gsub(/(\\|<\/|\r\n|[\n\r"'])/) { javascript_mapping[$1] }
        "\"#{escaped_string}\""
      end

      include Rack::Utils
      alias_method :h, :escape_html
    end

    error Devcenter::Backend::Error::NotFoundError do
      halt 404, env['sinatra.error']
    end

    error Devcenter::Backend::Error::BaseError do
      halt 403, env['sinatra.error']
    end

    [
      '/v1/javascripts-flXHR/flXHR.js',
      '/v1/javascripts-flXHR/flXHR.swf',
      '/v1/javascripts-flXHR/flXHR.vbs',
      '/v1/javascripts-flXHR/checkplayer.js',
      '/v1/javascripts-flXHR/flensed.js',
      '/v1/javascripts-flXHR/swfobject.js',
      '/v1/javascripts-flXHR/updateplayer.js',
      '/v1/javascripts-flXHR/angular-adaptor.js'
    ].each do |resource|
      send(:get, resource) do
        base_dir = File.dirname(__FILE__)
        send_file File.join(base_dir, 'app/assets/javascripts/vendor/flXHR', resource.gsub(/^\/v1\/javascripts-flXHR\//, ''))
      end
    end

    [:get, :post].each do |method|
      send(method, '/v1/games/:uuid/:venue') do
        return not_found unless params[:uuid]

        game = try_twice_and_avoid_token_expiration do
          Devcenter::Backend::Game.find(params[:uuid], token)
        end

        venue = Venue.for(game, params[:venue])
        return halt(404) unless venue

        venue.response_for(game, self)
      end
    end
  end
end
