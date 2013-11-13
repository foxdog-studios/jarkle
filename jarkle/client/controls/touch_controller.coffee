class @TouchController
  @TOUCH_START = 'touchstart'
  @TOUCH_MOVE = 'touchmove'
  @TOUCH_END = 'touchend'

  constructor: (@el, @pubSub) ->
    @onGoingTouches = new Array
    @el.addEventListener 'touchstart', @handleStart, false
    @el.addEventListener 'touchend', @handleEnd, false
    @el.addEventListener 'touchcancel', @handleCancel, false
    @el.addEventListener 'touchleave', @handleEnd, false
    @el.addEventListener 'touchmove', @handleMove, false

  handleStart: (evt) =>
    evt.preventDefault()
    touches = evt.changedTouches
    for touch in touches
      touch.type = evt.type
      @onGoingTouches.push(@_copyTouch(touch))
      @pubSub.trigger TouchController.TOUCH_START, touch

  handleEnd: (evt) =>
    evt.preventDefault()
    touches = evt.changedTouches
    for touch in touches
      index = @_ongoingTouchIndexById(touch.identifier)
      touch.type = evt.type
      @pubSub.trigger TouchController.TOUCH_END, touch
      unless index >= 0
        # could not find the touch to end
        continue
      @onGoingTouches.splice index, 1

  handleCancel: (evt) =>
    evt.preventDefault()
    handleEnd(evt)

  handleMove: (evt) =>
    evt.preventDefault()
    touches = evt.changedTouches
    for touch in touches
      touch.type = evt.type
      index = @_ongoingTouchIndexById(touch.identifier)
      @pubSub.trigger TouchController.TOUCH_MOVE, touch
      unless index >= 0
        # Could not find out a touch to continue
        continue
      @onGoingTouches.splice index, 1, @_copyTouch(touch)

  _copyTouch: (touch) ->
    # Some browsers (mobile Safari, for one) re-use touch objects between
    # events, so it's best to copy the bits you care about, rather than
    # referencing the entire object.
    indentifier: touch.indentifier
    pageX: touch.pageX
    pageY: touch.pageY

  _ongoingTouchIndexById: (idToFind) ->
    for ongoingTouch, index in @onGoingTouches
      id = ongoingTouch.identifier
      if id == idToFind
        return index
    return -1

