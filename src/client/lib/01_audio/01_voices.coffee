class @Voices
  constructor: (pubsub, @_ctx) ->
    @_voices = {}
    @_listener = new PubsubNoteListener pubsub, this

  _apply: (note, funcName) ->
    @_voices[note.inputId][funcName] note.frequency

  onNoteStart: (note) =>
    unless @_voices[note.inputId]?
      @_voices[note.inputId] = new Voice @_ctx, 'sine'
    @_apply note, 'start'

  onNoteMove: (note) =>
    @_apply note, 'move'

  onNoteStop: (note) =>
    @_apply note, 'stop'

  enable: ->
    @_listener.enable()

  disable: ->
    @_listener.disable()

