NOTES = ['C', 'C#', 'D', 'D#', 'E', 'F', 'F#', 'G', 'G#', 'A', 'A#', 'B']

NOTE_ON_MIDI_NUMBER = 144

class @WebGlSynth
  constructor: (@schema, el, noteMap, @pubSub) ->
    window.AudioContext = window.AudioContext or window.webkitAudioContext
    @synth = new Synth(new AudioContext(), noteMap, pubSub, @schema)
    @webGLVis = new WebGLVisualisation(el, window.innerWidth,
                                      window.innerHeight, @schema)
    @playerManager = new PlayerManager(@schema)
    @currentPlayerId = null

  handleNoteMessage: (noteMessage) =>
    userId = noteMessage.userId
    player = @playerManager.getPlayerFromUserId(userId)
    if not @currentPlayerId? \
        or @currentPlayerId._id == userId \
        or noteMessage.isMaster
      @synth.handleMessage noteMessage, player.id
      @webGLVis.updateCube noteMessage, player.id

  _midiNoteNumberToNoteLetter: (midiNoteNumber) ->
    noteIndex = midiNoteNumber % NOTES.length
    return NOTES[noteIndex]

  handleMidiMessage: (noteInfo) =>
    unless noteInfo.func != NOTE_ON_MIDI_NUMBER
      return
    noteLetter = @_midiNoteNumberToNoteLetter(noteInfo.note)
    switch noteLetter
      when 'C'
        nextPlayer = @playerManager.getNextActivePlayerId()
        if nextPlayer?
          Session.set 'infoMessage', nextPlayer.profile.userAgent
          @pubSub.trigger CURRENT_PLAYER, nextPlayer
        @currentPlayerId = nextPlayer
      when 'D'
        @currentPlayerId = null
        Session.set 'infoMessage', null
        @pubSub.trigger CURRENT_PLAYER, nextPlayer
      when 'E'
        @synth.stopAll()
        @webGLVis.stopAll()

