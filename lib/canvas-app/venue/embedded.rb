module Canvas::App
  module Venue
    class Embedded < Base
      def response_for(game, embedded_game, context)
        request = context.request

        context.tokens = {qs: nil, venue: nil}
        context.venue = 'embedded'
        context.erb template, locals: {game: game, context: context}
      end
    end
  end
end