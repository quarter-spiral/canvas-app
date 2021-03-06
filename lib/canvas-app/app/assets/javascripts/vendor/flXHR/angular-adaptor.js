if (window.XDomainRequest !== undefined) {
  var originalXMLHttpRequest = window.originalXMLHttpRequest

  document.write('<script src="/v1/javascripts-flXHR/swfobject.js"></script>');
  document.write('<script src="/v1/javascripts-flXHR/checkplayer.js"></script>');

  var checkFlashVersion = function() {
    if ((typeof flensed) === 'undefined' || (typeof flensed.checkplayer) === 'undefined' || (typeof swfobject) === 'undefined') {
      setTimeout(checkFlashVersion, 500);
      return;
    }

    new flensed.checkplayer(flensed.flXHR.MIN_PLAYER_VERSION, function(checkplayer) {
      if (!checkplayer.checkPassed) {
        document.documentElement.className += " qs-flash-version-unsupported";
      }
    }, false);
  };
  checkFlashVersion();


  window.XMLHttpRequest = function() {
    flXHR = new flensed.flXHR();

    flXHR.xmlResponseText = false;
    flXHR.binaryResponseBody = true;

    var originalGetAllResponseHeaders = flXHR.getAllResponseHeaders;
    flXHR.getAllResponseHeaders = function() {
      return originalGetAllResponseHeaders().join("\n")
    };

    var originalOpen = flXHR.open;
    flXHR.open = function() {
      this.__angular_flxhr_request_headers = [];
      var method = arguments[0];
      if (method !== 'POST' && method !== 'GET') {
        flXHR.setRequestHeader('FAKE-METHOD', method)
        method = 'POST';
        arguments[0] = method;
      }
      this.__angular_flxhr_adaptor_http_method = method;
      this.__angular_flxhr_original_arguments = arguments;
    }

    var originalSetRequestHeader = flXHR.setRequestHeader;
    flXHR.setRequestHeader = function(header, value) {
      if (header === 'Authorization' && value !== undefined && value.match !== undefined && value.match(/^Bearer /)) {
        // Turn Authorization header into query param
        var newArguments = this.__angular_flxhr_original_arguments;
        var url = newArguments[1];
        if (url.match(/\?/)) {
          url = url + "&";
        } else {
          url = url + "?";
        }
        url = url + "oauth_token=" + value.replace(/^Bearer /, '');
        this.__angular_flxhr_original_arguments[1] = url;
      } else {
        this.__angular_flxhr_request_headers.push([header, value])
      }
    }

    var originalSend = flXHR.send;
    flXHR.send = function() {
      var newArguments = this.__angular_flxhr_original_arguments;
      var url = newArguments[1];
      if (url.match(/\?/)) {
        url = url + "&";
      } else {
        url = url + "?";
      }
      var randomSeed =  Math.floor((1 + Math.random()) * 0x1000000).toString(16) + (new Date().getTime().toString());
      url = url + "_id_random_seed=" + randomSeed;
      this.__angular_flxhr_original_arguments[1] = url;

      originalOpen.apply(this, this.__angular_flxhr_original_arguments);
      var headersToSet = this.__angular_flxhr_request_headers;
      for (var i = 0; i < headersToSet.length; i++) {
        originalSetRequestHeader.call(this, headersToSet[i][0], headersToSet[i][1]);
      }

      if (this.__angular_flxhr_adaptor_http_method === 'POST' && (arguments[0] === undefined || arguments[0] === null || arguments[0] === "")) {
        flXHR.setRequestHeader("Content-Type", "application/json");
        arguments[0] = '{}';
      }

      flXHR.setRequestHeader("Content-Type", "application/json");

      originalSend.apply(this, arguments);
    }

    return flXHR;
  }
}

if (((typeof XMLHttpRequest) === 'undefined' || (typeof new XMLHttpRequest().withCredentials) === 'undefined') && (typeof window.XDomainRequest) === 'undefined') {
    document.documentElement.className += " qs-browser-unsupported";
}