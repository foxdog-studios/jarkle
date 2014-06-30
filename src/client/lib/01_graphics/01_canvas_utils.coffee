class @CanvasUtils
  @resize: (canvas) ->
    $canvas = $(canvas)
    canvas.width = $canvas.width()
    canvas.height = $canvas.height()

