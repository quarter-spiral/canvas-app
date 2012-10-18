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
          friends = facebook_client.authenticated_by(facebook_info['oauth_token']).friends_of(facebook_user_id)

          context.erb template, locals: {game: game, embedded_game: embedded_game, context: context, facebook_info: facebook_info, friends: friends}
        else
          context.redirect facebook_client.unauthenticated.authorization_url(redirect_url: request.url, scopes: [])
        end
      end
    end
  end
end
