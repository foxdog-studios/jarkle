class @TouchInput
  constructor: (trigger, target, isMaster, maxTouches) ->
    @_builder = new DomInputEventBuilder target, isMaster

    @_listener = new DomEventListener target,
      touchstart: @_onEventStart
      touchmove: @_onEventMove
      touchend: @_onEventStop
      touchcancel: @_onEventStop
      touchleave: @_onEventStop

    @_monitors = for index in [0...maxTouches]
      monitor = new TimeoutMonitor trigger
      inputId = "touch-#{ index }"
      monitor.eventBuilder = new DomInputEventBuilder target, inputId, isMaster
      monitor

    @_freeMonitors = @_monitors.splice 0

  _onEventStart: (domEvent) =>
    @_onEvent @_onTouchStart, domEvent

  _onEventMove: (domEvent) =>
    @_onEvent @_onTouchMove, domEvent

  _onEventStop: (domEvent) =>
    @_onEvent @_onTouchStop, domEvent

  _onEvent: (func, domEvent) ->
    domEvent.preventDefault()
    for touch in domEvent.changedTouches
      func.call this, touch

  _onTouchStart: (touch) ->
    id = touch.identifier

    # Touches should never start twice without stopping. If this happens,
    # ignore the second start.
    return if @_touches[id]?

    # If the maximum number of touches has been exceeded, ignore this
    # new touch.
    return if _.isEmpty @_freeMonitors

    # Assign a monitor to the new touch and call start
    @_touches[id] = monitor = @_freeMonitors.pop()
    @_applyMonitor monitor, 'start', touch

  _onTouchMove: (touch) ->
    # Ignore this move if the start event was never received or it was
    # ignored.
    if (monitor = @_touches[touch.identifier])?
      @_applyMonitor monitor, 'move', touch

  _onTouchStop: (touch) ->
    id = touch.identifier

    # Ignore this stop event if the corresponding start event was not
    # received or was ignored.
    return unless (monitor = @_touches[id])?

    # Free the monitor and call stop.
    delete @_touches[id]
    @_freeMonitors.push monitor
    @_applyMonitor monitor, 'stop', touch

  _applyMonitor: (monitor, funcName, touch) ->
    monitor[funcName] monitor.eventBuilder.build touch

  enable: ->
    @_touches = {}
    @_listener.enable()

  disable: ->
    @_listener.disable()
    for _, monitor of @_touches
      monitor.forceStop()
      @_freeMonitors.push monitor
    @_touches = {}

