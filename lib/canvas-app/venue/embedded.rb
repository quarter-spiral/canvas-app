module Canvas::App
  module Venue
    class Embedded < Base
      def response_for(game, context)
        request = context.request

        qs_oauth = nil
        @qs_uuid = nil
        player_name = nil
        qs_firebase_token = nil

        if auth_cookie = context.request.cookies['qs_canvas_authentication']
          if auth_cookie['info']
            auth_cookie = JSON.parse(auth_cookie)
            qs_oauth = auth_cookie['info']['token']
            @qs_uuid = auth_cookie['info']['uuid']
            token_owner = context.env['qs_token_owner'] || context.connection.auth.token_owner(qs_oauth)
            qs_firebase_token = token_owner['firebase-token']

            Thread.new do
              context.try_twice_and_avoid_token_expiration do
                context.connection.playercenter.register_player(qs_uuid, game.uuid, 'embedded', context.token)
                venue_identity = {"venue-id" => auth_cookie['info']['uuid'], "name" => auth_cookie['info']['name']}
                context.connection.auth.attach_venue_identity_to(context.token, auth_cookie['info']['uuid'], 'embedded', venue_identity)
              end
            end

            player_name = auth_cookie['info']['name']
          end
        end

        context.tokens = {qs: qs_oauth, venue: qs_oauth, firebase: qs_firebase_token}
        context.venue = 'embedded'

        super(game, context, uuid: qs_uuid, user_name: player_name)
      end
    end
  end
end