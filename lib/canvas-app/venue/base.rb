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

      def error_for(request)
        nil
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
