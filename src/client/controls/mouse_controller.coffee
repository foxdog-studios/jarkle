class @MouseController
  @START = 'mouse-start'
  @END = 'mouse-end'
  @MOVE = 'mouse-move'

  constructor: (@el, @pubSub) ->
    @el.addEventListener 'mousedown', @handleStart, false
    @el.addEventListener 'mouseup', @handleEnd, false
    @isOn = false

  testCtrl: (evt) ->
    evt.ctrlKey

  handleStart: (evt) =>
    @el.addEventListener 'mousemove', @handleMove, false
    if @testCtrl(evt)
      return
    evt.identifier = 'mouse'
    @pubSub.trigger MouseController.START, evt
    @isOn = true

  handleMove: (evt) =>
    if @testCtrl(evt)
      return
    evt.identifier = 'mouse'
    # The ctrl key could have been held down on the mouse start, so this could
    # in fact be the beginning of the stroke.
    if @isOn
      eventType = MouseController.MOVE
    else
      eventType = MouseController.START
    @pubSub.trigger eventType, evt

  handleEnd: (evt) =>
    @el.removeEventListener 'mousemove', @handleMove, false
    evt.identifier = 'mouse'
    @pubSub.trigger MouseController.END, evt
    @isOn = false
