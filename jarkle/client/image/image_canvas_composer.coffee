@ImageCanvasComposer = class ImageCanvasComposer
  constructor: (@canvas, @imageCanvas, @pubSub, @eventType) ->
    @canvasContext = @canvas.getContext '2d'
    @pubSub.on @eventType, @composeImage

  composeImage: (point) =>
    canvasX = point.x * @canvas.width
    canvasY = point.y * @canvas.height
    centeredImageX = canvasX - @imageCanvas.width / 2
    centeredImageY = canvasY - @imageCanvas.height / 2
    if @imageCanvas.loaded
      @canvasContext.drawImage \
        @imageCanvas.canvas, \
        centeredImageX, \
        centeredImageY, \
        @imageCanvas.width, \
        @imageCanvas.height

