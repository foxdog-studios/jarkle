class @Singletons
  audioContext = null
  keyPublisher = null
  notePublisher = null
  pitchAxis = null
  pubsub = null
  voiceManager = null

  # Construct when the app loads because I believe lazy initialization
  # was the source of bug where messages where received from the server
  # via the stream. My guess is that when the stream was created inside
  # a route the subscriptions it created go cut off when the route
  # changed.
  stream = new Meteor.Stream 'stream'

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
    stream

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

