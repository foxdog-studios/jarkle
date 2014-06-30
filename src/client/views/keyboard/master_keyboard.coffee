Template.masterKeyboard.created = ->
  Session.set 'enableInputs', true
  Session.set 'coverKeyboard', true
  Session.set 'message'


Template.masterKeyboard.rendered = ->
  timeout = Settings.keyboard.master.timeout
  @_keyboardCoverer = new KeyboardCoverer Singletons.getPubsub(), timeout
  @_keyboardCoverer.enable()

  # TODO: Clean up on destroyed.
  if (signaller = setupWebRtc())?
    signaller.start()
    signaller.createOffer()


Template.masterKeyboard.helpers
  keyboardData: ->
    settings = Settings.keyboard.master

    enableSynth: settings.enableSynth
    isMaster: true
    maxTouches: settings.maxTouches
    pitchAxis: @pitchAxis
    pitches: @pitches
    roomId: @roomId


Template.masterKeyboard.destroyed = ->
  @_keyboardCoverer?.disable()
  Session.set 'message'
  Session.set 'coverKeyboard'
  Session.set 'enableInputs'

