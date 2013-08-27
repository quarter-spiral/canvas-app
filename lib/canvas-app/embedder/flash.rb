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
      setTimeout(function() {window.QS.setup()}, 500);
    }
  };
  window.QS = qsSetupPlaceholder;
</script>

<script src="<%= sdk_url %>" type="text/javascript" async></script>

<% fluid = game.configuration["fluid-size"] %>
<% sizes = game.configuration["sizes"] %>

<object type="application/x-shockwave-flash" id="qs-embedded-flash-game" data="<%= url %>" <% if fluid %>style="width:100%;height:100%;min-width:<%= sizes.first['width'] %>;min-height:<%= sizes.first['height'] %>px;"<% end %> class="<%= fluid ? 'fluid-size' : 'fixed-size' %>">
  <param name="movie" value="<%= url %>">
  <param name="wmode" value="direct">
  <param name="FlashVars" value="qsCanvasHost=<%= canvas_host %>" />
  <param name="allowScriptAccess" value="always">
  <embed name="qsEmbeddedFlashGame" type="application/x-shockwave-flash" href="<%= url %>" allowscriptaccess="always" FlashVars="qsCanvasHost=<%= canvas_host %>">
  </embed>
</object>

<% unless fluid %>
  <script src="/v1/javascripts/app/resize_helpers.js" type="text/javascript"></script>
  <script type="text/javascript">
    adoptSizes(jQuery('#qs-embedded-flash-game'), <%= sizes.to_json %>);
  </script>
<% end %>
        EOS
      end
    end
  end
end

