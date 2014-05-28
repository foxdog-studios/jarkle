class @Singletons
  audioContext = null
  keyPublisher = null
  notePublisher = null
  pubsub = null
  stream = null
  voiceManager = null

  @getAudioContext: ->
    audioContext ?= new window.AudioContext

  @getKeyPublisher: ->
    keyPublisher ?= new KeyPublisher Singletons.getPubsub(), makePitches()

  @getNotePublisher: ->
    notePublisher ?= new NotePublisher Singletons.getPubsub(), makeNoteBuilder()

  @getPubsub: ->
    pubsub ?= new Pubsub

  @getStream: ->
    stream ?= new Meteor.Stream 'stream'

  @getVoiceManager: ->
    voiceManager ?= new VoiceManager(
      Singletons.getPubsub(),
      Singletons.getAudioContext()
    )


makeNoteBuilder = ->
  new AxisNoteBuilder makePitches(), makePitchAxis()


makePitchAxis = ->
  PitchAxis.parse Settings.pitchAxis


makePitches = ->
  Pitches.parse Settings.pitches

