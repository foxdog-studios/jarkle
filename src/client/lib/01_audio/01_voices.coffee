class @Voices
  constructor: (@_ctx, @_oscillatorType, @_startGain) ->
    @_voices = {}

  _ensureVoice: (event) ->
    @_makeVoice event unless @_voices[event.inputId]?

  _makeVoice: (note) ->
    @_voices[note.inputId] = new Voice @_ctx, @_oscillatorType, @_startGain

  onNoteStart: (note) ->
    @_ensureVoice(event)
    @_apply note, 'start'

  onNoteMove: (note) ->
    @_apply note, 'move'

  onNoteStop: (note) ->
    @_apply note, 'stop'

  onInputStart: (input) ->
    @_makeVoice input unless @_voices[input.inputId]?
    @_apply input, 'detune'

  onInputMove: (input) ->
    @_apply input, 'detune'

  onInputStop: (input) ->
    @_apply input, 'detune'

  _apply: (note, funcName) ->
    @_voices[note.inputId][funcName] note

