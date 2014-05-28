class @Voices
  constructor: (@_ctx, voices) ->
    @_cycle = cycle _.shuffle _.clone voices
    @_voices = {}

  onNoteStart: (note) ->
    @_makeVoice note unless @_voices[note.userId]?
    @_apply note, 'start'

  _makeVoice: (note) ->
    userId = note.userId
    {oscillator: oscillatorType, gain: gain} = @_cycle()
    @_voices[note.userId] = new Voice @_ctx, oscillatorType, gain

  onNoteMove: (note) ->
    @_apply note, 'move'

  onNoteStop: (note) ->
    @_apply note, 'stop'

  _apply: (note, funcName) ->
    @_voices[note.userId][funcName] note.frequency

