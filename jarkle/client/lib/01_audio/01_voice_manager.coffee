class @VoiceManager
  constructor: (pubsub, ctx) ->
    @_listeners = [
      new PubsubNoteListener pubsub, this
    ]

    settings = Settings.voices

    if settings.vibrato.enabled
      @_listeners.push new PubsubInputListener pubsub, this

    @_masterVoices = new PlayerVoices ctx, settings.masters
    @_playerVoices = new PlayerVoices ctx, settings.players

  onNoteStart: (note) =>
    @_apply 'onNoteStart', note

  onNoteMove: (note) =>
    @_apply 'onNoteMove', note

  onNoteStop: (note) =>
    @_apply 'onNoteStop', note

  onInputStart: (input) =>
    @_apply 'onInputStart', input

  onInputMove: (input) =>
    @_apply 'onInputMove', input

  onInputStop: (input) =>
    @_apply 'onInputStop', input

  _apply: (funcName, note) ->
    voices = if note.isMaster
      @_masterVoices
    else
      @_playerVoices
    voices[funcName] note

  enable: ->
    for listener in @_listeners
      listener.enable()

  disable: ->
    for listener in @_listeners
      listener.disable()

