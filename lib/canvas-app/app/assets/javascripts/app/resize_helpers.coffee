@adoptSizes = (container, sizes) ->
  win = jQuery(window)

  resize = ->
    width = win.width()
    height = win.height()
    bestSize = null
    i = 0

    while i < sizes.length
      size = sizes[i]
      bestSize = size  if size.width <= width and size.height <= height and (bestSize is null or bestSize.width * bestSize.height < size.width * size.height)
      i++
    bestSize = sizes[0]  if bestSize is null
    container.width(bestSize.width).height bestSize.height

  resize()
  win.resize resize
