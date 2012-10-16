module Canvas::App
  module Venue
    class Facebook < Base

      def error_for(request)
        return [405, 'POST only'] unless request.post?
      end
    end
  end
end
