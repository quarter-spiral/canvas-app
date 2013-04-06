ENV_KEYS_TO_EXPOSE = ['QS_PLAYERCENTER_BACKEND_URL', 'QS_AUTH_BACKEND_URL', 'QS_SPIRAL_GALAXY_URL']

module Canvas::App
  class AppBuilder
    def initialize
      auth_callback = auth_callback_handler

      @app = Rack::Builder.new do
        # QS Auth
        use Rack::Session::Cookie, key: 'qs_canvas_app', secret: ENV['QS_COOKIE_SECRET']
        use OmniAuth::Builder do
          provider AuthBackend, ENV['QS_OAUTH_CLIENT_ID'], ENV['QS_OAUTH_CLIENT_SECRET']
        end

        map "/auth/auth_backend/callback" do
          run auth_callback
        end

        run App.new
      end
    end

    def call(env)
      @app.call(env)
    end

    protected
    def auth_callback_handler
      Proc.new { |env|
        response = Rack::Response.new('', 301, 'Location' => env['omniauth.origin'])
        response.set_cookie('qs_canvas_authentication', value: JSON.dump(env['omniauth.auth']), path: '/')

        response
      }
    end
  end
end