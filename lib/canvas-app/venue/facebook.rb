module Canvas::App
  module Venue
    class Facebook < Base
      class FriendUpdate
        def self.default_job_options(data)
          {retries: 5}
        end

        def self.perform(job)
          data = job.data

          connection = Connection.create
          facebook_client = connection.facebook(data['app_id'], data['app_secret'])
          authenticated_client = facebook_client.authenticated_by(data['facebook_token'])
          friends = authenticated_client.friends_of(data['facebook_id'])
          friends.map! {|f| {"venue-id" => f.identifier, "name" => f.name, "email" => f.email}}

          job.heartbeat

          connection.playercenter.update_friends_of(data['uuid'], data['qs_token'], 'facebook', friends)
        end
      end

      def response_for(game, context)
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
          qs_oauth = nil
          @qs_uuid = nil
          qs_firebase_token = nil
          context.try_twice_and_avoid_token_expiration do
            qs_oauth = context.connection.auth.venue_token(context.token, 'facebook', venue_data)
            token_owner = context.connection.auth.token_owner(qs_oauth)
            @qs_uuid = token_owner['uuid']
            qs_firebase_token = token_owner['firebase-token']

            Thread.new do
              context.connection.playercenter.register_player(qs_uuid, game.uuid, 'facebook', context.token)
            end
          end

          context.tokens = {
            qs: qs_oauth,
            venue: facebook_info['oauth_token'],
            firebase: qs_firebase_token
          }
          context.venue = 'facebook'

          Job.run_in_background(FriendUpdate,
            'app_id' => app_id,
            'app_secret' => app_secret,
            'facebook_token' => context.tokens[:venue],
            'facebook_id' => player_info['id'],
            'qs_token' => context.tokens[:qs],
            'uuid' => qs_uuid
          )

          super(game, context, uuid: qs_uuid, user_name: player_info['name'])
        else
          authorization_url = facebook_client.unauthenticated.authorization_url(redirect_url: request.url, scopes: [:email])
          @response = "<html><head><title>Authorizing app</title></head><body><script>top.location.href=#{JSON.dump(authorization_url)};</script></body></html>"
        end
      end
    end
  end
end
