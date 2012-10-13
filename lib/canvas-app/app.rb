require 'sinatra'
require 'sinatra/assetpack'
require 'uri'
require 'service-client'

module Canvas::App
  class App < Sinatra::Base
    class TokenStore
      def self.token
        @token ||= connection.auth.create_app_token(ENV['QS_OAUTH_CLIENT_ID'], ENV['QS_OAUTH_CLIENT_SECRET'])
      end

      def self.reset!
        @token = nil
      end
    end

    set :root, ROOT

    register Sinatra::AssetPack

    assets {
      serve '/v1/javascripts', from: 'canvas-app/app/assets/javascripts'
      serve '/v1/stylesheets', from: 'canvas-app/app/assets/stylesheets'
      serve '/v1/images',      from: 'canvas-app/app/assets/images'

      css :application, '/v1/stylesheets/application.css', ['/v1/stylesheets/*.css']
    }

    helpers do
      def connection
        @connection ||= Connection.create
      end

      def token
        TokenStore.token
      end

      def try_twice_and_avoid_token_expiration
        yield
      rescue Service::Client::ServiceError => e
        raise e unless e.error == 'Unauthenticated'
        TokenStore.reset!
        yield
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

    get '/v1/games/:uuid/:venue' do
      return not_found unless params[:uuid]

      game = try_twice_and_avoid_token_expiration do
        Devcenter::Backend::Game.find(params[:uuid], token)
      end

      embedder = Embedder.for(game)
      return halt(403, "Invalid game") unless embedder

      venue = Venue.for(game, params[:venue])
      return halt(404) unless venue

      status embedder.status

      if embedder.respond_to?(:body)
        embedder.body
      else
        embedded_game = erb embedder.template, locals: {game: game}
        erb venue.template, locals: {game: game, embedded_game: embedded_game}
      end
    end
  end
end
