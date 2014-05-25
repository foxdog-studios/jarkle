class @StreamInput
  constructor: (pubsub, stream, roomId) ->
    @_trigger = new PubsubInputTrigger pubsub
    @_listener = new StreamInputListener stream, roomId, this
    @_monitors = {}

  onInputStart: (input) =>
    id = input.inputId
    unless (monitor = @_monitors[id])?
      @_monitors[id] = monitor = new TimeoutMonitor @_trigger
    monitor.start input

  onInputMove: (input) =>
    if (monitor = @_monitors[input.inputId])?
      monitor.move input

  onInputStop: (input) =>
    id = input.inputId
    if (monitor = @_monitors[id])?
      delete @_monitors[id]
      monitor.stop input

  enable: ->
    @_listener.enable()

  disable: ->
    @_listener.disable()
    for inputId, monitor of @_monitors
      monitor.forceStop()
    @_monitors = {}

