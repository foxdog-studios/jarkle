class @Keys
  constructor: (@canvas, @width, @height, @numNotes, @pubSub) ->
    @canvas.width = @width
    @canvas.height = @height
    @canvasContext = canvas.getContext '2d'
    @pubSub.on TouchController.TOUCH_START, @drawCurrentKey
    @pubSub.on TouchController.TOUCH_MOVE, @moveKey
    @pubSub.on TouchController.TOUCH_END, @clearKey
    @keys = []
    @ids = {}
    for i in [0..@numNotes]
      @keys[i] = 0

  _getNoteNumber: (message) ->
    y = message.pageY / @height
    return Math.floor(y * @numNotes)

  drawCurrentKey: (message) =>
    noteNumber = @_getNoteNumber(message)
    oldNumber = @ids[message.identifier]
    unless oldNumber? and oldNumber == noteNumber
      @ids[message.identifier] = noteNumber
      @keys[noteNumber] += 1
    @canvasContext.fillStyle = rgb2Color 255, 255, 255
    @applyCanvasFunction(message, 'fillRect')

  applyCanvasFunction: (message, func) =>
    noteNumber = @_getNoteNumber(message)
    @_applyCanvasFunction(noteNumber, func)

  _applyCanvasFunction: (noteNumber, func) =>
    yInc = @height / @numNotes
    startY = yInc * noteNumber
    @canvasContext[func] 0, startY, @width, yInc

  clearKey: (message) =>
    noteNumber = @_getNoteNumber(message)
    oldNoteNumber = @ids[message.identifier]
    if oldNoteNumber? and oldNoteNumber != noteNumber
      @_clearKey(oldNoteNumber)
    @_clearKey(noteNumber)

  _clearKey: (noteNumber) ->
    numberOfTimesNotePressed = @keys[noteNumber]
    if numberOfTimesNotePressed == 0
      return
    numberOfTimesNotePressed -= 1
    if numberOfTimesNotePressed == 0
      @_applyCanvasFunction(noteNumber, 'clearRect')
    @keys[noteNumber] = numberOfTimesNotePressed

  moveKey: (message) =>
    noteNumber = @_getNoteNumber(message)
    oldNoteNumber = @ids[message.identifier]
    if oldNoteNumber? and oldNoteNumber != noteNumber
      @_clearKey(oldNoteNumber)
    @drawCurrentKey(message)

