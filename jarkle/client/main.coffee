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

Template.controller.rendered = ->
  pubSub = new PubSub

  window.AudioContext = window.AudioContext or window.webkitAudioContext
  if isSupportedSynthDevice()
    synth = new Synth(new AudioContext(), NUM_KEYBOARD_NOTES, KEYBOARD_START,
      pubSub, MESSAGE_RECIEVED)

  canvas = @find '.controller'
  canvasContext = canvas.getContext '2d'
  canvas.width = window.innerWidth
  canvas.height = window.innerHeight

  keyboardCanvas = @find '.keyboard'
  keyboard = new Keyboard(keyboardCanvas, window.innerWidth,
                          window.innerHeight, NUM_KEYBOARD_NOTES,
                          pubSub, MIDI_NOTE_ON)
  keyboard.drawKeys()

  controller = @find '.controller'
  touchController = new TouchController controller, pubSub
  touchMessage = new TouchMessager chatStream, pubSub

  dinoImage = new ImageCanvas IMAGE_SIZE, IMAGE_SIZE, 'fatterdino.gif'
  dinoImageCanvasComposer = new ImageCanvasComposer canvas, dinoImage, pubSub, \
    TouchMessager.MESSAGE_SENT

  faceImage = new ImageCanvas FACE_SIZE, FACE_SIZE, 'face.png'
  faceImageCanvasComposer = new ImageCanvasComposer canvas, faceImage, pubSub, \
    MESSAGE_RECIEVED

  chatStream.on 'message', (message) ->
    pubSub.trigger MESSAGE_RECIEVED, message

  chatStream.on 'midiNoteOn', (noteNumber) ->
    pubSub.trigger MIDI_NOTE_ON, noteNumber

