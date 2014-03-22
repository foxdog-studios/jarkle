NOTES = ['C', 'C#', 'D', 'D#', 'E', 'F', 'F#', 'G', 'G#', 'A', 'A#', 'B']

NOTE_ON_MIDI_NUMBER = 144

ONLY_MASTERS = 'only masters'

class @WebGlSynth
  constructor: (@schema, @skeletonConfig, @vis, noteMap, @pubSub) ->
    Session.set 'infoMessage', null
    window.AudioContext = window.AudioContext or window.webkitAudioContext
    @synth = new Synth(new AudioContext(), noteMap, pubSub, @schema,
                       skeletonConfig)
    @playerManager = new PlayerManager(@schema)
    if Meteor.settings.public.allowAllPlayersOnStart
      @currentPlayerId = null
    else
      @currentPlayerId = ONLY_MASTERS

  handleNoteMessage: (noteMessage) =>
    userId = noteMessage.userId
    player = @playerManager.getPlayerFromUserId(userId, noteMessage.isMaster)
    if not @currentPlayerId? \
        or @currentPlayerId._id == userId \
        or noteMessage.isMaster
      @synth.handleMessage noteMessage, player.id
      @vis.handleMessage noteMessage, player.id

  _midiNoteNumberToNoteLetter: (midiNoteNumber) ->
    noteIndex = midiNoteNumber % NOTES.length
    return NOTES[noteIndex]

  stopAll: ->
    @synth.stopAll()
    @vis.stopAll()

  pause: ->
    @vis.paused = not @vis.paused

  handleDrumMidiMessage: (noteInfo) =>
    if noteInfo.note == RIDE_CYMBAL_1 and noteInfo.vel >= 120
      @nextPlayer()

  nextPlayer: ->
    @stopAll()
    nextPlayer = @playerManager.getNextActivePlayerId()
    unless nextPlayer?
      console.log 'no players!'
      return
    ua = nextPlayer.profile.userAgent
    if ua.match(/Android/i)
      ua = 'Android'
    if ua.match(/Blackberry/i)
      ua = 'Blackberry'
    if ua.match(/iPhone/i)
      ua = 'iPhone'
    if ua.match(/iPad/i)
      ua = 'iPad'
    if ua.match(/iPod/i)
      ua = 'iPod'
    if ua.match(/IEMobile/i)
      ua = 'Windows phone'
    Session.set 'infoMessage', """
      #{nextPlayer.profile.name} on #{ua}
    """
    @pubSub.trigger CURRENT_PLAYER, nextPlayer
    @currentPlayerId = nextPlayer

  _showConnectMessage: ->
    Session.set 'infoMessage', 'Go to http://fds'

  _allowAllPlayers: ->
    @currentPlayerId = null
    Session.set 'infoMessage', 'EVERYBODY'
    @pubSub.trigger CURRENT_PLAYER,
      _id: 'all'

  _allowMasterPlayersOnly: ->
    # No players (apart from masters)
    Session.set 'infoMessage', null
    @currentPlayerId = ONLY_MASTERS
    @pubSub.trigger CURRENT_PLAYER,
      _id: @currentPlayerId

  _masterOnly: ->
    @_allowMasterPlayersOnly()
    @_showConnectMessage()
    @stopAll()


  handleMidiMessage: (noteInfo) =>
    unless noteInfo.func != NOTE_ON_MIDI_NUMBER
      return
    noteLetter = @_midiNoteNumberToNoteLetter(noteInfo.note)
    switch noteLetter
      when 'B'
        @_masterOnly()
      when 'C'
        @nextPlayer()
      when 'D'
        @_allowAllPlayers()

  handleKeyboardMessage: (key) ->
    switch key
      when 1
        @_masterOnly()
      when 2
        @nextPlayer()
      when 3
        @_allowAllPlayers()

