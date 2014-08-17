class @MouseInput
  constructor: (trigger, target, isMaster) ->
    @_builder = new DomInputEventBuilder target, 'mouse', isMaster
    @_downUp = new DomEventListener target,
      mousedown: @_onMouseDown
      mouseup: @_onMouseUp
    @_move = new DomEventListener target,
      mousemove: @_onMouseMove

    monitorFactory = if isMaster
      TimeoutMonitor
    else
      ThrottledMonitor
    @_monitor = new monitorFactory trigger

  _onMouseDown: (domEvent) =>
    domEvent.preventDefault()
    @_monitor.start @_build domEvent
    @_move.enable()

  _onMouseMove: (domEvent) =>
    domEvent.preventDefault()
    @_monitor.move @_build domEvent

  _onMouseUp: (domEvent) =>
    domEvent.preventDefault()
    @_move.disable()
    @_monitor.stop @_build domEvent

  _build: (domEvent) ->
    @_builder.build domEvent

  enable: ->
    @_downUp.enable()

  disable: ->
    @_downUp.disable()
    @_move.disable()

