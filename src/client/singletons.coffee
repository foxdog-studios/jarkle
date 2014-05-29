class @Singletons
  audioContext = null
  keyPublisher = null
  notePublisher = null
  pitchAxis = null
  pubsub = null
  stream = null
  voiceManager = null

  @getAudioContext: ->
    audioContext ?= new window.AudioContext

  @getKeyPublisher: ->
    keyPublisher ?= new KeyPublisher Singletons.getPubsub(), makePitches()

  @getNotePublisher: ->
    notePublisher ?= new NotePublisher Singletons.getPubsub(), makeNoteBuilder()

  @getPitchAxis: ->
    pitchAxis ?= PitchAxis.parse Settings.pitchAxis

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
  new AxisNoteBuilder makePitches(), Singletons.getPitchAxis()


makePitchAxis = ->
  PitchAxis.parse Settings.pitchAxis


makePitches = ->
  Pitches.parse Settings.pitches

