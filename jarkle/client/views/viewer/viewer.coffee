Template.viewer.rendered = ->
  settings = Settings.viewer

  # Inputs
  Session.set 'enableInputs', settings.enableInputs

  # Message
  Session.set 'showMessage', settings.showMessage
  if settings.showMessage
    @_messageComp = Deps.autorun ->
      room = Rooms.findOne {},
        fields:
          message: 1
      Session.set 'message', room?.message
  else
    Session.set 'message'

  # Synth
  if supportsWebAudio() && settings.enableSynth
    Singletons.getVoiceManager().enable()
  Singletons.getNotePublisher().enable()

  # Remote players
  @_streamInput = new StreamInput(
    Singletons.getPubsub(),
    Singletons.getStream(),
    @data.roomId
  )
  @_streamInput.enable()

  if Settings.viewer.enableRoomControls
    @_roomControls = new ComputerKeyboardRoomControls @data.roomId
    @_roomControls.enable()


Template.viewer.helpers
  inputsData: ->
    isMaster: true
    maxTouches: Settings.viewer.maxTouches
    trigger: new PubsubAndStreamInputTrigger(
      Singletons.getPubsub(),
      Singletons.getStream(),
      @roomId
    )

  showPlayers: ->
    Settings.viewer.showPlayers

  showSidePanel: ->
    Settings.viewer.showSidePanel


Template.viewer.destroyed = ->
  @_roomControls?.disable()
  @_streamInput?.disable()

  Singletons.getNotePublisher().disable()
  if supportsWebAudio() and Settings.viewer.enableSynth
    Singletons.getVoiceManager().disable()

  @_messageComp?.stop()
  Session.set 'message'

  Session.set 'showMessage'
  Session.set 'enableInput'

