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
    isMaster: @isMaster
    maxTouches:@maxTouches
    trigger: new PubsubAndStreamInputTrigger(
      Singletons.getPubsub(),
      Singletons.getStream(),
      @roomId
    )


Template.keyboard.destroyed = ->
  Singletons.getNotePublisher().disable()
  Singletons.getKeyPublisher().disable()
  if supportsWebAudio() and @data.enableSynth
    Singletons.getVoiceManager().disable()

