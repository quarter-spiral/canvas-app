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
          player_info = facebook_client.authenticated_by(facebook_info['oauth_token']).whoami
          venue_data = {
            'name'  => player_info['name'],
            'email' => player_info['email'],
            'venue-id' => player_info['id']
          }
          qs_oauth = context.connection.auth.venue_token(context.token, 'facebook', venue_data)

          tokens = {
            qs: qs_oauth,
            venue: facebook_info['oauth_token']
          }

          context.erb template, locals: {game: game, embedded_game: embedded_game, context: context, tokens: tokens}
        else
          context.redirect facebook_client.unauthenticated.authorization_url(redirect_url: request.url, scopes: [:email])
        end
      end
    end
  end
end
