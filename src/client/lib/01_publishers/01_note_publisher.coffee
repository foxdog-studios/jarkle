class @NotePublisher
  constructor: (pubsub, @_noteBuilder) ->
    @_listener = new PubsubInputListener pubsub, this
    @_monitors = {}
    @_trigger = new PubsubNoteTrigger pubsub

  onInputStart: (input) =>
    note = @_noteBuilder.build input
    unless (monitor = @_monitors[note.inputId])?
      @_monitors[note.inputId] = monitor = new Monitor @_trigger
    monitor.frequency = note.frequency
    monitor.start note

  onInputMove: (input) =>
    note = @_noteBuilder.build input
    monitor = @_monitors[note.inputId]
    if note.frequency != monitor.frequency
      monitor.frequency = note.frequency
      monitor.move note

  onInputStop: (input) =>
    note = @_noteBuilder.build input
    monitor = @_monitors[note.inputId]
    delete @_monitors[note.inputId]
    monitor.stop note

  enable: ->
    @_listener.enable()

  disable: ->
    @_listener.disable()

