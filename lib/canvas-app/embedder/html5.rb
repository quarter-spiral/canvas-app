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
      var infoReceived = false;
      var destination = <%= url.gsub(/\\/$/, '').to_json %>;


      var receiveConfirmation = function(event) {
        if (event.origin !== destination) {
          return;
        }
        var data = angular.fromJson(event.data);

        if (data.type === 'qs-info-received') {
          infoReceived = true;
        }
      }
      window.addEventListener("message", receiveConfirmation, false)

      var sendData = function() {
        if (infoReceived) {
          return;
        }
        iframe.postMessage(angular.toJson({type: 'qs-data', data: window.qs}), destination)
        setTimeout(sendData, 500)
      };
      sendData();
    });
  });
</script>
        EOS
      end
    end
  end
end
