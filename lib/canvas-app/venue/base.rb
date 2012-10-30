module Canvas::App
  module Venue
    class Base
      attr_reader :game

      def initialize(game)
        @game = game
      end

      def template
        Utils.uncamelize_string(name).to_sym
      end

      def response_for(game, embedded_game, context)
        context.erb template, locals: {game: game, context: context, venue: Utils.uncamelize_string(name)}
      end

      protected
      def name
        self.class.name.split('::').last
      end
    end
  end
end
