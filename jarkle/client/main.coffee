IMAGE_SIZE = 64
FACE_SIZE = 128
NUM_KEYBOARD_NOTES = 127
KEYBOARD_START = 0

sendChat = (message) ->
  chatStream.emit 'message', message

$ ->
  FastClick.attach(document.body)

MESSAGE_RECIEVED = 'message-recieved'
MIDI_NOTE_ON = 'midi-note-on'

audioContext = null
canvasContext = null
canvas = null
dinoImage = null
pubSub = null

faceImage = null

synth = null

isSupportedSynthDevice = ->
  Meteor.Device.isDesktop() or Meteor.Device.isTV()

hasWebGL = ->
  canvas = document.createElement('canvas')
  window.WebGLRenderingContext \
    and (canvas.getContext('webgl') or canvas.getContext('experimental-webgl'))

useWebGL = ->
  isSupportedSynthDevice() and hasWebGL()

Template.controller.rendered = ->
  pubSub = new PubSub

  window.AudioContext = window.AudioContext or window.webkitAudioContext
  noteMap = new MajorKeyNoteMap NUM_KEYBOARD_NOTES, KEYBOARD_START, 'C'
  #noteMap = new ChromaticNoteMap NUM_KEYBOARD_NOTES, KEYBOARD_START
  if window.AudioContext? and isSupportedSynthDevice()
    synth = new Synth(new AudioContext(), noteMap, pubSub, MESSAGE_RECIEVED)

  canvas = @find '.controller'
  canvasContext = canvas.getContext '2d'
  canvas.width = window.innerWidth
  canvas.height = window.innerHeight


  if useWebGL()
    webGLDiv = @find '.webGLcontainer'
    webGLVis = new WebGLVisualisation(webGLDiv, window.innerWidth,
                                      window.innerHeight)
    pubSub.on MESSAGE_RECIEVED, webGLVis.updateCube
    pubSub.on MIDI_NOTE_ON, webGLVis.updateSprite

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
  touchMessage = new TouchMessager chatStream, pubSub

  dinoImage = new ImageCanvas IMAGE_SIZE, IMAGE_SIZE, 'fatterdino.gif'
  dinoImageCanvasComposer = new ImageCanvasComposer controller, dinoImage, pubSub, \
    TouchMessager.MESSAGE_SENT

  unless useWebGL()
    faceImage = new ImageCanvas FACE_SIZE, FACE_SIZE, 'face.png'
    faceImageCanvasComposer = new ImageCanvasComposer controller, faceImage, \
      pubSub, MESSAGE_RECIEVED

  chatStream.on 'message', (message) ->
    pubSub.trigger MESSAGE_RECIEVED, message

  chatStream.on 'midiNoteOn', (noteNumber) ->
    pubSub.trigger MIDI_NOTE_ON, noteNumber

