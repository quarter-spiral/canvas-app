module Canvas::App
  module Embedder
    class Flash  < Base
      def template
        <<-EOS
<% canvas_host = URI.escape(request.host) %>
<% url = URI.escape(game.configuration['url']) %>
<% url.gsub!('http://', 'https://') if request.scheme == 'https' && !params[:nossl] %>

<% sdk_url = File.join(ENV['QS_SDK_APP_URL'], '/javascripts/sdk.js') %>
<script>
  var qsSetupPlaceholder;

  qsSetupPlaceholder = {
    setup: function() {
      setTimeout(function() {windows.QS.setup()}, 500);
    }
  };
  windows.QS = qsSetupPlaceholder;
</script>

<script src="<%= sdk_url %>" type="text/javascript" async></script>

<object type="application/x-shockwave-flash" width="1024" height="600" id="qs-embedded-flash-game">
  <param name="movie" value="<%= url %>">
  <param name="wmode" value="opaque">
  <param name="FlashVars" value="qsCanvasHost=<%= canvas_host %>" />
  <param name="allowScriptAccess" value="always">
  <embed name="qsEmbeddedFlashGame" type="application/x-shockwave-flash" href="<%= url %>" allowscriptaccess="always" FlashVars="qsCanvasHost=<%= canvas_host %>">
  </embed>
</object>
        EOS
      end
    end
  end
end

