jQuery(->
  win = jQuery(window)

  infoContainers = jQuery('#about, #sharing, #preroll, #game')
  gameContainer = jQuery('#html5frame, #qs-embedded-flash-game')

  adoptInfoSizes = ->
    infoContainers.height(gameContainer.height())

  win.resize(adoptInfoSizes)
  adoptInfoSizes()

  return unless qs.info.sizes.fluid
  iframe = jQuery('#html5frame')
  return unless iframe.length > 0

  topBar = jQuery('#header')
  socialBar = jQuery('#socialBar')
  minHeight = (qs.info.sizes.sizes[0] || {}).height
  adoptIframeSize = ->
    newHeight = win.height() - topBar.height() - socialBar.height() - 1
    newHeight = minHeight if minHeight and newHeight < minHeight
    iframe.css(height: newHeight)

  win.on('resize', adoptIframeSize)
  adoptIframeSize()
  win.resize()
)