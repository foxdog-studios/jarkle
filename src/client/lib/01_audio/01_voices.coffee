class @Voices
  constructor: (@_ctx, @_oscillatorType, @_startGain) ->
    @_voices = {}

  onNoteStart: (note) ->
    @_makeVoice note unless @_voices[note.inputId]?
    @_apply note, 'start'

  _makeVoice: (note) ->
    @_voices[note.inputId] = new Voice @_ctx, @_oscillatorType, @_startGain

  onNoteMove: (note) ->
    @_apply note, 'move'

  onNoteStop: (note) ->
    @_apply note, 'stop'

  _apply: (note, funcName) ->
    @_voices[note.inputId][funcName] note.frequency

