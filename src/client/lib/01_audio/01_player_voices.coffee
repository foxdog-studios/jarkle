class @PlayerVoices
  constructor: (@_ctx, voices) ->
    @_cycle = cycle _.shuffle _.clone voices
    @_voices = {}

  onNoteStart: (note) ->
    @_makeVoice note unless @_voices[note.userId]?
    @_apply 'onNoteStart', note

  _makeVoice: (note) ->
    {oscillator: oscillatorType, gain: startGain} = @_cycle()
    @_voices[note.userId] = new Voices @_ctx, oscillatorType, startGain

  onNoteMove: (note) ->
    @_apply 'onNoteMove', note

  onNoteStop: (note) ->
    @_apply 'onNoteStop', note

  _apply: (funcName, note) ->
    @_voices[note.userId][funcName] note

