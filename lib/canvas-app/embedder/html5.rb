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
      var destination = '*'; //FIXME: Use <%= url.gsub(/\\/$/, '').to_json %>


      var receiveConfirmation = function(event) {
        //FIXME: Add security checks back in
        //if (event.origin !== destination) {
        //  return;
        //}
        var data = angular.fromJson(event.data);

        if (data.type === 'qs-info-received') {
          infoReceived = true;
        }
      }
      window.addEventListener("message", receiveConfirmation, false)

      var sendingToFrame = function(frame, data, destination) {
        //This is brute forcing all sub frames :(
        var maxDepth = 1;
        try {
          frame.postMessage(data, destination)
          for (var i = 0; i < maxDepth; i++) {
            sendingToFrame(frame.frames[i], data,destination);
          }
        } catch (e) {
          //FIXME: Use a better approach than "brute-force-and-swallow-all-errors"
        }
      }

      var sendData = function() {
        if (infoReceived) {
          return;
        }
        sendingToFrame(iframe, angular.toJson({type: 'qs-data', data: window.qs}), destination)
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
