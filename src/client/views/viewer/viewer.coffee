Template.viewer.created = ->
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
  if settings.enableSynth
    Singletons.getVoices().enable()
  Singletons.getNotePublisher().enable()

  # Remote players
  @_streamInput = new StreamInput(
    Singletons.getPubsub(),
    Singletons.getStream(),
    @data.roomId
  )
  @_streamInput.enable()


Template.viewer.rendered = ->
  if Settings.viewer.enableRoomControls
    @_roomControls = new ComputerKeyboardRoomControls @data.roomId
    @_roomControls.enable()


Template.viewer.helpers
  inputsData: ->
    isMaster: true
    maxTouches: Settings.viewer.maxTouches
    trigger: new PubsubInputTrigger Singletons.getPubsub()

  showSidePanel: ->
    Settings.viewer.showSidePanel


Template.viewer.destroyed = ->
  @_roomControls?.disable()
  @_streamInput?.disable()

  Singletons.getNotePublisher().disable()
  if Settings.viewer.enableSynth
    Singletons.getVoices().disable()

  @_messageComp?.stop()
  Session.set 'message'

  Session.set 'showMessage'
  Session.set 'enableInput'

