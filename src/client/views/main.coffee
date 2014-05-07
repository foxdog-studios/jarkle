NUM_KEYBOARD_NOTES = 127
KEYBOARD_START = 0
TIME_OUT = 1000
IMAGE_SIZE = 64
IMAGE_SRC = 'finaldino.gif'

$ ->
  FastClick.attach(document.body)

MESSAGE_RECIEVED = 'message-recieved'
MIDI_NOTE_ON = 'midi-note-on'
MIDI_DRUM_NOTE_ON = 'midi-drum-note-on'
RESTART_BLACKEN = 'restart-blacken'
SKELETON = 'skeleton'
@PAIRS_TOUCHING = 'pairs-touching'
@CURRENT_PLAYER = 'current-player'

@isLocalSynth = ->
  Router.current()?.params.localSynth

isSupportedSynthDevice = ->
  isLocalSynth() or Meteor.Device.isDesktop() or Meteor.Device.isTV()

hasWebGL = ->
  canvas = document.createElement('canvas')
  window.WebGLRenderingContext \
    and (canvas.getContext('webgl') or canvas.getContext('experimental-webgl'))

hasWebAudio = ->
  unless window.AudioContext or window.webkitAudioContext
    return false
  window.AudioContext = window.AudioContext or window.webkitAudioContext
  a = new window.AudioContext
  return a.createOscillator?

setBackground = ->
  bgImage = new Image()
  $(bgImage).addClass('bg-image')
  $('body').append(bgImage)
  bgImage.src = Meteor.settings.public.background

@isViewer = ->
  isSupportedSynthDevice() and hasWebAudio()

@createRoomEventName = (eventName) ->
  if Meteor.settings.public.rooms
    "#{Session.get('roomId')}-#{eventName}"
  else
    eventName

PASSWORD = 'thisDoesNotMatter'

Meteor.startup ->
  Deps.autorun ->
    if Meteor.user() and not isViewer()
      if Meteor.settings.public.isInGFunkMode
        Session.set('infoMessage',
          "Open #{jarkleDomainAndPath()} on a laptop/desktop then touch me")
      else
        Session.set 'infoMessage', "#{Meteor.user().profile.name}"
    if Meteor.loggingIn() or Meteor.user()?
      return
    Accounts.createUser
      username: Random.hexString(32)
      password: PASSWORD
      profile:
        userAgent: navigator.userAgent
        name: generateName()
    , (error) ->
      if error?
        # XXX: Just log the error
        console.log "Error creating user #{error}"

Template.controller.rendered = ->
  if not @renderedOnce
    @renderedOnce = true
    setup(@, false)

Template.master.rendered  = ->
  if not @renderedOnce
    @renderedOnce = true
    setup(@, true)

setupWebRtc = ->
  return unless Meteor.settings.public.useWebRTCForMaster
  # This is the config used to create the RTCPeerConnection
  servers =
    iceServers: [
      url: 'stun:stun.l.google.com:19302'
    ]

  config = {}

  dataChannelConfig =
    ordered: false
    maxRetransmitTime: 0

  # Try and create an RTCPeerConnection if supported
  if RTCPeerConnection?
    return webRTCSignaller = new @WebRTCSignaller('webRTCChannel',
                                                  servers,
                                                  config,
                                                  dataChannelConfig)
  else
    console.error 'No RTCPeerConnection available :('
  return undefined


setup = (template, isMaster) ->
  unless isMaster
    # XXX: For the desktop viewer set it to be a master as well.
    isMaster = isViewer()
  Deps.autorun (computation) =>
    if Meteor.user()
      Meteor.users.update Meteor.userId(),
        $set:
          isMaster: isMaster
      computation.stop()

  pubSub = new PubSub

  canvas = template.find '.controller'
  canvasContext = canvas.getContext '2d'
  canvas.width = window.innerWidth
  canvas.height = window.innerHeight

  # XXX: Every canvas needs this resizing stuff so it should be moved out
  # somewhere.
  $(window).resize ->
    canvas.width = $(window).width()
    canvas.height = $(window).height()

  if Meteor.settings.public.useCustomNoteMap
    noteMap = new CustomNoteMap(Meteor.settings.public.customNoteMap,
                                Meteor.settings.public.customNoteMapOffset)
  else
    noteMap = new MajorKeyNoteMap(NUM_KEYBOARD_NOTES, KEYBOARD_START, 'A',
                                  PENTATONIC_INTERVALS)

  controller = template.find '.controller'
  if isViewer()
    setBackground()

    webRTCSignaller = setupWebRtc()
    if webRTCSignaller?
      Deps.autorun =>
        message = webRTCSignaller.getMessage()
        if message?
          message = JSON.parse(message)
          pubSub.trigger MESSAGE_RECIEVED, message

    $('#myModal').modal()
    Meteor.subscribe 'userStatus'

    trailHeadConfig = Meteor.settings.public.trailHeadConf

    if hasWebGL() and not Router.current().params.disableWebGL
      webGLDiv = template.find '.webGLcontainer'

      vis = new WebGLVisualisation(webGLDiv, window.innerWidth,
                                        window.innerHeight, trailHeadConfig,
                                  Meteor.settings.public.particleTexture,
                                  Meteor.settings.public.inc,
                                  Meteor.settings.public.incAxis)

      # Visualisation events
      pubSub.on MIDI_DRUM_NOTE_ON, vis.updateFoxHeads
      pubSub.on SKELETON, vis.updateSkeleton
      pubSub.on PAIRS_TOUCHING, vis.onPairsTouching
    else
      faceImage = new ImageCanvas IMAGE_SIZE, IMAGE_SIZE, IMAGE_SRC
      vis = new ImageCanvasComposer controller, faceImage

    skeletonConfig = Meteor.settings.public.skeletonConf

    webGLSynth = new WebGlSynth(trailHeadConfig, skeletonConfig, vis, noteMap,
                                pubSub)
    keyboardController = new KeyboardController window, pubSub

    pubSub.on KeyboardController.KEY_UP, (key) ->
      switch key
        when 'P'
          webGLSynth.pause()
        when 1, 2, 3, 4, 5
          webGLSynth.handleKeyboardMessage(key)

    pubSub.on MESSAGE_RECIEVED, webGLSynth.handleNoteMessage
    pubSub.on MIDI_NOTE_ON, webGLSynth.handleMidiMessage
    pubSub.on MIDI_DRUM_NOTE_ON, webGLSynth.handleDrumMidiMessage

    # Synth events
    pubSub.on SKELETON, webGLSynth.synth.playSkeletons
  else
    if isMaster
      webRTCSignaller = setupWebRtc()
      if webRTCSignaller?
        webRTCSignaller.start()
        webRTCSignaller.createOffer()

    keyboardCanvas = template.find '.keyboard'
    keyboard = new Keyboard(keyboardCanvas, window.innerWidth,
                            window.innerHeight, noteMap.getNumberOfNotes(),
                            pubSub, MIDI_NOTE_ON)
    keyboard.drawKeys()

  keysCanvas = template.find '.keys'
  keys = new Keys(keysCanvas, window.innerWidth, window.innerHeight,
                  noteMap.getNumberOfNotes(), pubSub)

  touchController = new TouchController controller, pubSub
  noteMessenger = new NoteMessenger(chatStream, pubSub,
                                    NoteMessenger.MESSAGE_SENT)

  lastMessageReceivedMap = {}
  # Forward note message to the chat stream
  pubSub.on NoteMessenger.MESSAGE_SENT, (message) =>
    # Don't send unless our controller is "on"
    return unless isMaster or Session.get('isCurrentPlayer') == 'on'
    message.isMaster = isMaster
    if webRTCSignaller?
      webRTCSignaller.sendData(JSON.stringify(message))
      return
    if message.type == 'start' or message.type == 'continue'
      lastMessageReceived = lastMessageReceivedMap[message.originalIdentifier]
      if Meteor.settings.public.waitForReplyBeforeSend
        # Don't play the note if the previous one has not been confirmed as
        # received.
        return if lastMessageReceived? and not lastMessageReceived
    lastMessageReceivedMap[message.originalIdentifier] = false
    Meteor.call 'messageSent', createRoomEventName('message'), message, ->
      lastMessageReceivedMap[message.originalIdentifier] = true

  localNoteMessenger = new NoteMessenger chatStream, pubSub, MESSAGE_RECIEVED
  mouseController = new MouseController controller, pubSub

  # Touch for both local and remote messages
  for messenger in [noteMessenger, localNoteMessenger]
    pubSub.on TouchController.TOUCH_START, messenger.sendNoteStartMessage
    pubSub.on TouchController.TOUCH_MOVE, messenger.sendNoteContinueMessage
    pubSub.on TouchController.TOUCH_END, messenger.sendNoteEndMessage

  # Only hook up mouse controls for local messages
  pubSub.on MouseController.START, localNoteMessenger.sendNoteStartMessage
  pubSub.on MouseController.MOVE, localNoteMessenger.sendNoteContinueMessage
  pubSub.on MouseController.END, localNoteMessenger.sendNoteEndMessage

  if isViewer()
    chatStream.on createRoomEventName('midiNoteOn'), (noteInfo) ->
      pubSub.trigger MIDI_NOTE_ON, noteInfo

    chatStream.on 'midiDrumsNoteOn', (noteInfo) ->
      pubSub.trigger MIDI_DRUM_NOTE_ON, noteInfo

    chatStream.on createRoomEventName('message'), (message) ->
      pubSub.trigger MESSAGE_RECIEVED, message

    chatStream.on 'skeleton', (skeleton) ->
      pubSub.trigger SKELETON, skeleton

    pubSub.on CURRENT_PLAYER, (player) ->
      chatStream.emit createRoomEventName('currentPlayer'), player

  else
    blacken = template.find '.blacken'
    blackenScreenTimeout = new BlackScreenTimeout(blacken, TIME_OUT)
    pubSub.on NoteMessenger.MESSAGE_SENT, =>
      unless Session.get('isCurrentPlayer') == 'off'
        blackenScreenTimeout.restartTimeout()
    unless isMaster
      chatStream.on createRoomEventName('currentPlayer'), (player) =>
        if player?
          if player._id == Meteor.userId() or player._id == 'all'
            Session.set('isCurrentPlayer', 'on')
            blackenScreenTimeout.stopTimeout()
          else
            Session.set('isCurrentPlayer', 'off')
            blackenScreenTimeout.stopTimeout()
            blackenScreenTimeout.blackenScreen()
        else
          Session.set('isCurrentPlayer', 'touch')
          blackenScreenTimeout.restartTimeout()
