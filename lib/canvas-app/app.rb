require 'sinatra'
require 'sinatra/assetpack'
require 'uri'

module Canvas::App
  class App < Sinatra::Base
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

      include Rack::Utils
      alias_method :h, :escape_html
    end

    template = <<-EOS
<!DOCTYPE html>
<html lang="en-us">
    <head>
      <title><%=h game.name %></title>
      <%= css :application, :media => 'screen' %>
    </head>
    <body>
    </body>
      <h1><%=h game.name %></h1>

      <%= embedded_game %>
    </body>
</html>
    EOS

    get '/v1/games/:uuid' do
      return not_found unless params[:uuid]
      game = connection.datastore.get(:public, params[:uuid])
      return not_found unless game
      game = game['game']
      return halt(403, "Entity not a game") unless game
      game = Devcenter::Backend::Game.new(game)

      embedder = Embedder.for(game)
      return halt(403, "Invalid game") unless embedder

      status embedder.status

      if embedder.respond_to?(:body)
        embedder.body
      else
        embedded_game = erb embedder.template, locals: {game: game}
        erb template, locals: {game: game, embedded_game: embedded_game}
      end
    end
  end
end
