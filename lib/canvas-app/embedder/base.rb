module Canvas::App
  module Embedder
    class Base
      def initialize(game)
        @game = game
      end

      def status
        200
      end
    end
  end
end
