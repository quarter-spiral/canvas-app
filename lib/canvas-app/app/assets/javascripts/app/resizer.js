function adoptSizes(container, sizes) {
  var win = $(window);

  var resize = function() {
    var width = win.width();
    var height = win.height();
    var bestSize = null;

    for (var i = 0; i < sizes.length; i++) {
      var size = sizes[i];
      if (size.width <= width && size.height <= height && (bestSize === null || bestSize.width * bestSize.height < size.width * size.height)) {
        bestSize = size;
      }
    };

    if (bestSize === null) {
      bestSize = sizes[0];
    }
    container.width(bestSize.width).height(bestSize.height);
  };
  resize();
  win.resize(resize);
}