module Canvas::App
  module Embedder
    class Html5 < Base
      def template
        <<-EOS
<% url = game.configuration['url'] %>
<iframe name="html5frame" id="html5frame" src="<%= URI.escape(url) %>"></iframe>
<script type="text/javascript">
  var debug = function(message) {
    if (!window.qsDebug) return;
    console.log(message);
  };

  var frameHasSignaledGameIsLoaded = false;
  var frameHasAcknowledgedReceiptOfData = false;

  var sendGameDataToFrame = function() {
    debug("Sending game data to frame");
    if (!frameHasAcknowledgedReceiptOfData) {
      var iframe = document.getElementById('html5frame').contentWindow;
      iframe.postMessage(angular.toJson({type: 'qs-data', data: window.qs}), '*');
      setTimeout(sendGameDataToFrame, 200);
    }
  }

  var messageHandler = function(event) {
    debug("Got a message:")
    debug(event.data)

    var data = angular.fromJson(event.data);
    switch(data.type) {
      case "qs-game-loaded":
        if (!frameHasSignaledGameIsLoaded) {
          debug("Game loaded. Sending info to game frame.");
          sendGameDataToFrame();
          frameHasSignaledGameIsLoaded = true;
        }
        break;
      case "qs-info-received":
        debug("Turning of sending of data to frame");
        frameHasAcknowledgedReceiptOfData = true;
        break;
    }
  }
  window.addEventListener("message", messageHandler, false)
</script>
        EOS
      end
    end
  end
end
