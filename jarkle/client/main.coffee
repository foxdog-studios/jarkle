TRAIL_HEAD_CONF =
  player1:
    vis:
      obj: 'pug.obj'
      mtl: 'pug.mtl'
  player2:
    vis:
      obj: 'godchilla.obj'
      mtl: 'godchilla.mtl'
  player3:
    vis:
      obj: 'fox.obj'
      mtl: 'fox.mtl'


NUM_KEYBOARD_NOTES = 127
KEYBOARD_START = 0
TIME_OUT = 1000

$ ->
  FastClick.attach(document.body)

MESSAGE_RECIEVED = 'message-recieved'
MIDI_NOTE_ON = 'midi-note-on'
RESTART_BLACKEN = 'restart-blacken'
SKELETON = 'skeleton'
@PAIRS_TOUCHING = 'pairs-touching'

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

@UID = Random.hexString(24)

Template.controller.rendered = ->
  pubSub = new PubSub

  canvas = @find '.controller'
  canvasContext = canvas.getContext '2d'
  canvas.width = window.innerWidth
  canvas.height = window.innerHeight

  noteMap = new MajorKeyNoteMap(NUM_KEYBOARD_NOTES, KEYBOARD_START, 'A',
                                  PENTATONIC_INTERVALS)

  if isViewer()
    webGLDiv = @find '.webGLcontainer'
    webGLSynth = new WebGlSynth(TRAIL_HEAD_CONF, webGLDiv, noteMap, pubSub)

    pubSub.on MESSAGE_RECIEVED, webGLSynth.handleNoteMessage

    # Synth events
    pubSub.on SKELETON, webGLSynth.synth.playSkeletons

    # Visualisation events
    pubSub.on MIDI_NOTE_ON, webGLSynth.webGLVis.updateFoxHeads
    pubSub.on SKELETON, webGLSynth.webGLVis.updateSkeleton
    pubSub.on PAIRS_TOUCHING, webGLSynth.webGLVis.onPairsTouching
  else
    keyboardCanvas = @find '.keyboard'
    keyboard = new Keyboard(keyboardCanvas, window.innerWidth,
                            window.innerHeight, noteMap.getNumberOfNotes(),
                            pubSub, MIDI_NOTE_ON)
    keyboard.drawKeys()

  keysCanvas = @find '.keys'
  keys = new Keys(keysCanvas, window.innerWidth, window.innerHeight,
                  noteMap.getNumberOfNotes(), pubSub)

  controller = @find '.controller'
  touchController = new TouchController controller, pubSub
  noteMessenger = new NoteMessenger(chatStream, pubSub,
                                    NoteMessenger.MESSAGE_SENT)
  pubSub.on NoteMessenger.MESSAGE_SENT, (message) ->
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
    chatStream.on 'midiNoteOn', (noteNumber) ->
      pubSub.trigger MIDI_NOTE_ON, noteNumber

    chatStream.on 'message', (message) ->
      pubSub.trigger MESSAGE_RECIEVED, message

    chatStream.on 'skeleton', (skeleton) ->
      pubSub.trigger SKELETON, skeleton
  else
    blackenScreenTimeout = new BlackScreenTimeout(controller, TIME_OUT)
    pubSub.on NoteMessenger.MESSAGE_SENT, blackenScreenTimeout.restartTimeout

