class @ImageCanvasComposer
  constructor: (@canvas, @imageCanvas) ->
    @canvasContext = @canvas.getContext '2d'

  handleMessage: (point) =>
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

