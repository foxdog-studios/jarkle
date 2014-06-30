class @PlayerVoices
  constructor: (@_ctx, voices) ->
    @_cycle = cycle _.shuffle _.clone voices
    @_voices = {}

  _ensureVoices: (event) ->
    @_makeVoices event unless @_voices[event.userId]?

  _makeVoices: (note) ->
    {oscillator: oscillatorType, gain: startGain} = @_cycle()
    @_voices[note.userId] = new Voices @_ctx, oscillatorType, startGain

  onNoteStart: (note) =>
    @_ensureVoices(note)
    @_apply 'onNoteStart', note

  onNoteMove: (note) ->
    @_apply 'onNoteMove', note

  onNoteStop: (note) ->
    @_apply 'onNoteStop', note

  onInputStart: (input) =>
    @_ensureVoices(input)
    @_apply 'onInputStart', input

  onInputMove: (input) ->
    @_apply 'onInputMove', input

  onInputStop: (input) ->
    @_apply 'onInputStop', input

  _apply: (funcName, note) ->
    @_voices[note.userId][funcName] note

