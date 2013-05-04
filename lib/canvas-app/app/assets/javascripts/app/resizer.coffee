$(->
  win = $(window)

  infoContainers = $('#about, #sharing, #preroll, #game')
  gameContainer = $('#html5frame, #qs-embedded-flash-game')

  adoptInfoSizes = ->
    infoContainers.height(gameContainer.height())

  win.resize(adoptInfoSizes)
  adoptInfoSizes()
)