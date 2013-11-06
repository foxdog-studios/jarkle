NOTES = ['C', 'C#', 'D', 'D#', 'E', 'F', 'F#', 'G', 'G#', 'A', 'A#', 'B']

NOTE_ON_MIDI_NUMBER = 144

class @WebGlSynth
  constructor: (@schema, el, noteMap, @pubSub) ->
    Session.set 'infoMessage', null
    window.AudioContext = window.AudioContext or window.webkitAudioContext
    @synth = new Synth(new AudioContext(), noteMap, pubSub, @schema)
    @webGLVis = new WebGLVisualisation(el, window.innerWidth,
                                      window.innerHeight, @schema)
    @playerManager = new PlayerManager(@schema)
    @currentPlayerId = null

  handleNoteMessage: (noteMessage) =>
    userId = noteMessage.userId
    player = @playerManager.getPlayerFromUserId(userId, noteMessage.isMaster)
    if not @currentPlayerId? \
        or @currentPlayerId._id == userId \
        or noteMessage.isMaster
      @synth.handleMessage noteMessage, player.id
      @webGLVis.updateCube noteMessage, player.id

  _midiNoteNumberToNoteLetter: (midiNoteNumber) ->
    noteIndex = midiNoteNumber % NOTES.length
    return NOTES[noteIndex]

  stopAll: ->
    @synth.stopAll()
    @webGLVis.stopAll()

  handleDrumMidiMessage: (noteInfo) =>
    if noteInfo.note == RIDE_CYMBAL_1
      @nextPlayer()

  nextPlayer: ->
    @stopAll()
    nextPlayer = @playerManager.getNextActivePlayerId()
    if nextPlayer?
      Session.set 'infoMessage', nextPlayer.profile.userAgent
      @pubSub.trigger CURRENT_PLAYER, nextPlayer
    @currentPlayerId = nextPlayer

  handleMidiMessage: (noteInfo) =>
    unless noteInfo.func != NOTE_ON_MIDI_NUMBER
      return
    noteLetter = @_midiNoteNumberToNoteLetter(noteInfo.note)
    switch noteLetter
      when 'B'
        Session.set 'infoMessage', 'Go to http://fds'
      when 'C'
        # Next player
        @nextPlayer()
      when 'D'
        # All players
        @currentPlayerId = null
        Session.set 'infoMessage', null
        @pubSub.trigger CURRENT_PLAYER, nextPlayer
      when 'E'
        # No players (apart from masters)
        Session.set 'infoMessage', null
        @currentPlayerId = 'only masters'
        @pubSub.trigger CURRENT_PLAYER,
          _id: @currentPlayerId
      when 'F'
        # Clear sounds
        @stopAll()

