class @Keys
  constructor: (@canvas, @width, @height, @numNotes, @pubSub) ->
    @canvas.width = @width
    @canvas.height = @height
    @canvasContext = canvas.getContext '2d'
    @pubSub.on TouchController.TOUCH_START, @drawCurrentKey
    @pubSub.on TouchController.TOUCH_END, @clearKey
    @keys = []
    for i in [0..@numNotes]
      @keys[i] = 0

  drawCurrentKey: (message) =>
    @canvasContext.fillStyle = rgb2Color 255, 255, 255
    @applyCanvasFunction(message, 'fillRect')

  applyCanvasFunction: (message, func) =>
    yInc = @height / @numNotes
    y = message.pageY / @height
    noteNumber = Math.round(y * @numNotes)
    @keys[noteNumber] += 1
    startY = yInc * noteNumber
    @canvasContext[func] 0, startY, @width, yInc

  clearKey: (message) =>
    y = message.pageY / @height
    noteNumber = Math.round(y * @numNotes)
    numberOfTimesNotePressed = @keys[noteNumber]
    if numberOfTimesNotePressed == 0
      return
    numberOfTimesNotePressed -= 1
    if numberOfTimesNotePressed == 0
      @applyCanvasFunction(message, 'clearRect')
    @keys[noteNumber] = numberOfTimesNotePressed


