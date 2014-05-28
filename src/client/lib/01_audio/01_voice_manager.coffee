class @VoiceManager
  constructor: (pubsub, ctx) ->
    @_listener = new PubsubNoteListener pubsub, this

    settings = Settings.voices
    @_masterVoices = new Voices ctx, settings.masters
    @_playerVoices = new Voices ctx, settings.players

  onNoteStart: (note) =>
    @_apply 'onNoteStart', note

  onNoteMove: (note) =>
    @_apply 'onNoteMove', note

  onNoteStop: (note) =>
    @_apply 'onNoteStop', note

  _apply: (funcName, note) ->
    voices = if note.isMaster
      @_masterVoices
    else
      @_playerVoices
    voices[funcName] note

  enable: ->
    @_listener.enable()

  disable: ->
    @_listener.disable()

