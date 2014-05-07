@ImageCanvas = class ImageCanvas
  constructor: (@width, @height, @src) ->
    @loaded = false
    @canvas = document.createElement 'canvas'
    @canvas.width = @width
    @canvas.height = @height
    @_canvasContext = @canvas.getContext '2d'
    @_image = new Image()
    @_image.onload = =>
      @_canvasContext.drawImage @_image, 0, 0, @width, @height
      @loaded = true
    @_image.src = @src
