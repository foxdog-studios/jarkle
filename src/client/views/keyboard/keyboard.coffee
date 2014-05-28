Template.keyboard.created = ->
  if supportsWebAudio() and @data.enableSynth
    Singletons.getVoiceManager().enable()
  Singletons.getKeyPublisher().enable()
  Singletons.getNotePublisher().enable()


Template.keyboard.helpers
  backgroundData: ->
    pitches: @pitches
    pitchAxis: @pitchAxis

  foregroundData: ->
    pitches: @pitches
    pitchAxis: @pitchAxis
    pubsub: @pubsub

  inputsData: ->
    pubsubTrigger = new PubsubInputTrigger Singletons.getPubsub()
    streamTrigger = new StreamInputTrigger Singletons.getStream(), @roomId
    trigger = new CompositeInputTrigger [pubsubTrigger, streamTrigger]

    isMaster: @isMaster
    maxTouches:@maxTouches
    trigger: trigger


Template.keyboard.destroyed = ->
  Singletons.getNotePublisher().disable()
  Singletons.getKeyPublisher().disable()
  if supportsWebAudio() and @data.enableSynth
    Singletons.getVoiceManager().disable()

