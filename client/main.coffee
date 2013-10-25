IMAGE_SIZE = 64
FACE_SIZE = 128
NUM_KEYBOARD_NOTES = 127
KEYBOARD_START = 0


sendChat = (message) ->
  chatStream.emit 'message', message

$ ->
  FastClick.attach(document.body)

audioContext = null
canvasContext = null
canvas = null
image = new Image()
imageCanvas = null
imageCanvasContext = null
imageLoaded = false

face = new Image()
faceCanvas = null
faceCanvasContext = null
faceLoaded = false

synth = null


isSupportedSynthDevice = ->
  Meteor.Device.isDesktop() or Meteor.Device.isTV()

Meteor.startup ->
  window.AudioContext = window.AudioContext or window.webkitAudioContext
  if isSupportedSynthDevice()
    synth = new Synth(new AudioContext(), NUM_KEYBOARD_NOTES, KEYBOARD_START)

Template.controller.rendered = ->
  keyboardCanvas = @find '.keyboard'
  keyboard = new Keyboard(keyboardCanvas, window.innerWidth,
                          window.innerHeight, NUM_KEYBOARD_NOTES)
  keyboard.drawKeys()


  imageCanvas = document.createElement 'canvas'
  imageCanvas.width = IMAGE_SIZE
  imageCanvas.height = IMAGE_SIZE
  imageCanvasContext = imageCanvas.getContext '2d'

  image.onload = =>
    imageCanvasContext.drawImage image, 0, 0, IMAGE_SIZE, IMAGE_SIZE
    imageLoaded = true
  image.src = 'fatterdino.gif'

  faceCanvas = document.createElement 'canvas'
  faceCanvas.width = FACE_SIZE
  faceCanvas.height = FACE_SIZE
  faceCanvasContext = faceCanvas.getContext '2d'

  face.onload = =>
    faceCanvasContext.drawImage face, 0, 0, FACE_SIZE, FACE_SIZE
    faceLoaded = true
  face.src = 'face.png'

  chatStream.on 'message', (message) ->
    [x, y, noteOn] = [message.x, message.y, message.noteOn]
    if isSupportedSynthDevice()
      if noteOn
        synth.playPad(x, y)
      else
        synth.stop()
        return
    updateBackgroundColour(x, y)
    rawX = x * window.innerWidth
    rawY = y * window.innerHeight
    faceX = rawX - FACE_SIZE / 2
    faceY = rawY - FACE_SIZE / 2
    if faceLoaded
      canvasContext.drawImage faceCanvas, faceX, faceY,  FACE_SIZE, FACE_SIZE

  canvas = @find '.controller'
  canvasContext = canvas.getContext '2d'
  canvas.width = window.innerWidth
  canvas.height = window.innerHeight

updateBackgroundColour = (x, y) ->
  bgColor = "rgb(#{Math.round(x * 255)}, 40, #{Math.round(y * 255)})"
  document.body.style.backgroundColor = bgColor

getXYFromEvent = (e) ->
  if e.touches?
    touch =  e.touches[0]
    rawX = touch.pageX
    rawY = touch.pageY
  else
    rawX = e.pageX
    rawY = e.pageY
  x = rawX / window.innerWidth
  y = rawY / window.innerHeight
  return rawX: rawX, rawY: rawY, x: x, y: y

Template.controller.events
  'mousedown .controller, touchstart .controller, touchmove .controller': \
      (e) ->
    e.preventDefault()
    {rawX, rawY, x, y} = getXYFromEvent(e)
    sendChat x: x, y: y, noteOn: true
    if window.innerWidth != canvas.width
      canvas.width = window.innerWidth
      canvas.height = window.innerHeight
    canvasContext.fillStyle = 'rgb(65, 255, 180)'
    if imageLoaded
      imageX = rawX - IMAGE_SIZE / 2
      imageY = rawY - IMAGE_SIZE / 2
      canvasContext.drawImage imageCanvas, imageX, imageY,  \
          IMAGE_SIZE, IMAGE_SIZE
    updateBackgroundColour x, y

  'mouseup .controller, touchcancel .controller, touchend .controller': (e) ->
    e.preventDefault()
    sendChat x: null, y: null, noteOn: false


