module Canvas::App
  module Venue
    class Embedded < Base
      def response_for(game, context)
        request = context.request

        qs_oauth = nil
        @qs_uuid = nil
        player_name = nil

        if auth_cookie = context.request.cookies['qs_canvas_authentication']
          if auth_cookie['info']
            auth_cookie = JSON.parse(auth_cookie)
            qs_oauth = auth_cookie['info']['token']
            @qs_uuid = auth_cookie['info']['uuid']

            context.try_twice_and_avoid_token_expiration do
              context.connection.playercenter.register_player(qs_uuid, game.uuid, 'embedded', context.token)
            end

            player_name = auth_cookie['info']['name']
          end
        end

        context.tokens = {qs: qs_oauth, venue: qs_oauth}
        context.venue = 'embedded'

        super(game, context, uuid: qs_uuid, user_name: player_name)
      end
    end
  end
end