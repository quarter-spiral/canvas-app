module Canvas::App
  module Embedder
    class Html5 < Base
      def template
        <<-EOS
<iframe src="<%= URI.escape(game.configuration['url']) %>"></iframe>
        EOS
      end
    end
  end
end
