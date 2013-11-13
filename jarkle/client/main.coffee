TRAIL_HEAD_CONF =
  player1:
    vis:
      obj: 'fox.obj'
      mtl: 'fox.mtl'
    synth:
      oscillatorType: 'SINE'
  player2:
    vis:
      obj: 'godchilla.obj'
      mtl: 'godchilla.mtl'
    synth:
      oscillatorType: 'SAWTOOTH'
  player3:
    isMaster: true
    vis:
      obj: 'pug.obj'
      mtl: 'pug.mtl'
    synth:
      oscillatorType: 'SQUARE'
  player4:
    vis:
      obj: 'dino-head.obj'
      mtl: 'dino-head.mtl'
    synth:
      oscillatorType: 'TRIANGLE'


NUM_KEYBOARD_NOTES = 127
KEYBOARD_START = 0
TIME_OUT = 1000

$ ->
  FastClick.attach(document.body)

MESSAGE_RECIEVED = 'message-recieved'
MIDI_NOTE_ON = 'midi-note-on'
MIDI_DRUM_NOTE_ON = 'midi-drum-note-on'
RESTART_BLACKEN = 'restart-blacken'
SKELETON = 'skeleton'
@PAIRS_TOUCHING = 'pairs-touching'
@CURRENT_PLAYER = 'current-player'

isSupportedSynthDevice = ->
  Meteor.Device.isDesktop() or Meteor.Device.isTV()

hasWebGL = ->
  canvas = document.createElement('canvas')
  window.WebGLRenderingContext \
    and (canvas.getContext('webgl') or canvas.getContext('experimental-webgl'))

hasWebAudio = ->
  window.AudioContext or window.webkitAudioContext

isViewer = ->
  isSupportedSynthDevice() and hasWebGL() and hasWebAudio()

PASSWORD = 'thisDoesNotMatter'

Meteor.startup ->
  Deps.autorun ->
    return
    if Meteor.user() and not isViewer()
      Session.set 'infoMessage', Meteor.user().username
    if Meteor.loggingIn() or Meteor.user()?
      return
    Accounts.createUser
      username: generateName()
      password: PASSWORD
      profile:
        userAgent: navigator.userAgent
    , (error) ->
      if error?
        alert error + 'Hold on'

Template.controller.rendered = ->
  setup(@, false)

Template.master.rendered  = ->
  setup(@, true)

setup = (template, isMaster) ->
  unless isMaster
    # XXX: For the desktop viewer set it to be a master as well.
    isMaster = isViewer()
  Deps.autorun =>
    if Meteor.user()
      Meteor.users.update Meteor.userId(),
        $set:
          isMaster: isMaster

  pubSub = new PubSub

  canvas = template.find '.controller'
  canvasContext = canvas.getContext '2d'
  canvas.width = window.innerWidth
  canvas.height = window.innerHeight

  noteMap = new MajorKeyNoteMap(NUM_KEYBOARD_NOTES, KEYBOARD_START, 'A',
                                  PENTATONIC_INTERVALS)

  if isViewer()
    Meteor.subscribe 'userStatus'

    webGLDiv = template.find '.webGLcontainer'
    webGLSynth = new WebGlSynth(TRAIL_HEAD_CONF, webGLDiv, noteMap, pubSub)
    keyboardController = new KeyboardController window, pubSub

    pubSub.on KeyboardController.KEY_UP, ->
      webGLSynth.pause()

    pubSub.on MESSAGE_RECIEVED, webGLSynth.handleNoteMessage
    pubSub.on MIDI_NOTE_ON, webGLSynth.handleMidiMessage
    pubSub.on MIDI_DRUM_NOTE_ON, webGLSynth.handleDrumMidiMessage

    # Synth events
    pubSub.on SKELETON, webGLSynth.synth.playSkeletons

    # Visualisation events
    pubSub.on MIDI_DRUM_NOTE_ON, webGLSynth.webGLVis.updateFoxHeads
    pubSub.on SKELETON, webGLSynth.webGLVis.updateSkeleton
    pubSub.on PAIRS_TOUCHING, webGLSynth.webGLVis.onPairsTouching
  else
    keyboardCanvas = template.find '.keyboard'
    keyboard = new Keyboard(keyboardCanvas, window.innerWidth,
                            window.innerHeight, noteMap.getNumberOfNotes(),
                            pubSub, MIDI_NOTE_ON)
    keyboard.drawKeys()

  keysCanvas = template.find '.keys'
  keys = new Keys(keysCanvas, window.innerWidth, window.innerHeight,
                  noteMap.getNumberOfNotes(), pubSub)

  controller = template.find '.controller'
  touchController = new TouchController controller, pubSub
  noteMessenger = new NoteMessenger(chatStream, pubSub,
                                    NoteMessenger.MESSAGE_SENT)
  pubSub.on NoteMessenger.MESSAGE_SENT, (message) =>
    message.isMaster = isMaster
    chatStream.emit 'message', message
  pubSub.on TouchController.TOUCH_START, noteMessenger.sendNoteStartMessage
  pubSub.on TouchController.TOUCH_MOVE, noteMessenger.sendNoteContinueMessage
  pubSub.on TouchController.TOUCH_END, noteMessenger.sendNoteEndMessage

  localNoteMessenger = new NoteMessenger chatStream, pubSub, MESSAGE_RECIEVED
  mouseController = new MouseController controller, pubSub

  pubSub.on MouseController.START, localNoteMessenger.sendNoteStartMessage
  pubSub.on MouseController.MOVE, localNoteMessenger.sendNoteContinueMessage
  pubSub.on MouseController.END, localNoteMessenger.sendNoteEndMessage

  if isViewer()
    chatStream.on 'midiNoteOn', (noteInfo) ->
      pubSub.trigger MIDI_NOTE_ON, noteInfo

    chatStream.on 'midiDrumsNoteOn', (noteInfo) ->
      pubSub.trigger MIDI_DRUM_NOTE_ON, noteInfo

    chatStream.on 'message', (message) ->
      pubSub.trigger MESSAGE_RECIEVED, message

    chatStream.on 'skeleton', (skeleton) ->
      pubSub.trigger SKELETON, skeleton

    pubSub.on CURRENT_PLAYER, (player) ->
      chatStream.emit 'currentPlayer', player

  else
    blacken = template.find '.blacken'
    blackenScreenTimeout = new BlackScreenTimeout(blacken, TIME_OUT)
    pubSub.on NoteMessenger.MESSAGE_SENT, =>
      unless Session.get('isCurrentPlayer') == 'off'
        blackenScreenTimeout.restartTimeout()
    unless isMaster
      chatStream.on 'currentPlayer', (player) =>
        if player?
          if player._id == Meteor.userId()
            Session.set('isCurrentPlayer', 'on')
            blackenScreenTimeout.stopTimeout()
          else
            Session.set('isCurrentPlayer', 'off')
            blackenScreenTimeout.stopTimeout()
            blackenScreenTimeout.blackenScreen()
        else
          Session.set('isCurrentPlayer', 'touch')
          blackenScreenTimeout.restartTimeout()

