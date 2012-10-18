module Canvas::App
  module Venue
    class Base
      attr_reader :game

      def initialize(game)
        @game = game
      end

      def template
        File.read(File.expand_path("./#{Utils.uncamelize_string(name)}.erb", template_dir))
      end

      def response_for(game, embedded_game, context)
        context.erb template, locals: {game: game, embedded_game: embedded_game, context: context}
      end

      protected
      def template_dir
        File.join(File.dirname(__FILE__), '/views')
      end

      def name
        self.class.name.split('::').last
      end
    end
  end
end
