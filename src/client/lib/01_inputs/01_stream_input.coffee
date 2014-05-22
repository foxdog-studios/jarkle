class @StreamInput
  constructor: (pubsub, stream, roomId) ->
    @_trigger = new PubsubInputTrigger pubsub
    @_stream = new StreamInputListener stream, roomId, this
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
    @_stream.enable()

  disable: ->
    @_stream.disable()

