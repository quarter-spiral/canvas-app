module Canvas::App
  module Embedder
    class Flash  < Base
      def template
        <<-EOS
<% url = URI.escape(game.configuration['url']) %>
<object type="application/x-shockwave-flash" data="<%= url %>" width="1024" height="600">
    <param name="movie" value="<%= url %>" />
    <p>No Flash :'(</p>
</object>
        EOS
      end
    end
  end
end

