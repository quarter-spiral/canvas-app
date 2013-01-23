module Canvas::App
  module Venue
    class SpiralGalaxy < Base
      def response_for(game, embedded_game, context)
        request = context.request

        game_url = File.join(ENV['QS_SPIRAL_GALAXY_URL'], 'play', game.uuid)
        context.redirect game_url and return unless request.post?
        spiral_galaxy_info = context.connection.facebook('none', game.secret).unauthenticated.decode_signed_request(request.params['signed_request'])
        qs_uuid = spiral_galaxy_info['uuid']
        qs_oauth = nil
        player_name = nil

        if qs_uuid
          qs_oauth = spiral_galaxy_info['oauth_token']
          context.try_twice_and_avoid_token_expiration do
            context.connection.playercenter.register_player(qs_uuid, game.uuid, 'spiral-galaxy', qs_oauth)
          end
          player_name = spiral_galaxy_info['name']
        end
        context.tokens = {
          qs: qs_oauth,
          venue: qs_oauth
        }

        context.venue = 'spiral-galaxy'

        context.erb template, locals: {game: game, context: context, uuid: qs_uuid, user_name: player_name}
      end
    end
  end
end