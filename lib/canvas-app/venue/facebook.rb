module Canvas::App
  module Venue
    class Facebook < Base
      def response_for(game, embedded_game, context)
        request = context.request

        app_id = game.venues['facebook']['app-id']
        app_secret = game.venues['facebook']['app-secret']

        facebook_client = context.connection.facebook(app_id, app_secret)

        context.redirect facebook_client.unauthenticated.app_url and return unless request.post?

        facebook_info = facebook_client.unauthenticated.decode_signed_request(request.params['signed_request'])
        facebook_user_id = facebook_info['user_id']

        if facebook_user_id
          authenticated_client = facebook_client.authenticated_by(facebook_info['oauth_token'])
          player_info = authenticated_client.whoami
          venue_data = {
            'name'  => player_info['name'],
            'email' => player_info['email'],
            'venue-id' => player_info['id']
          }
          qs_oauth = context.connection.auth.venue_token(context.token, 'facebook', venue_data)
          qs_uuid = context.connection.auth.token_owner(qs_oauth)['uuid']

          context.tokens = {
            qs: qs_oauth,
            venue: facebook_info['oauth_token']
          }
          context.venue = 'facebook'

          friends = authenticated_client.friends_of(player_info['id'])
          friends.map! {|f| {"venue-id" => f.identifier, "name" => f.name, "email" => f.email}}

          context.connection.playercenter.update_friends_of(qs_uuid, qs_oauth, context.venue, friends)

          context.erb template, locals: {game: game, context: context}
        else
          context.redirect facebook_client.unauthenticated.authorization_url(redirect_url: request.url, scopes: [:email])
        end
      end
    end
  end
end
