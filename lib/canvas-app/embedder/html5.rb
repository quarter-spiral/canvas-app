module Canvas::App
  module Embedder
    class Html5 < Base
      def template
        <<-EOS
<% url = game.configuration['url'] %>
<iframe name="html5frame" id="html5frame" src="<%= URI.escape(url) %>"></iframe>
<script type="text/javascript">
  $(function() {
    $('iframe#html5frame').load(function() {
      var iframe = frames[0];
      var sendData = function() {
        iframe.postMessage('bla', '*');
        iframe.postMessage({type: 'qs-data', data: window.qs}, <%= File.join(url, '/').to_json %>)
      };
      sendData();
      setTimeout(sendData, 500)
    });
  });
</script>
        EOS
      end
    end
  end
end
