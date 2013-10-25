chatStream = new Meteor.Stream 'chat'

IMAGE_SIZE = 64
FACE_SIZE = 128
NUM_KEYBOARD_NOTES = 127
KEYBOARD_START = 0

rgb2Color = (r,g,b) ->
  "rgb(#{r},#{g},#{b})"

class Keyboard
  constructor: (@canvas, @width, @height) ->
    @canvas.width = @width
    @canvas.height = @height
    @canvasContext = canvas.getContext '2d'

  drawKeys: ->
    # Draws a rainbow keyboard
    freq = 0.5
    freqR = freq
    freqG = freq
    freqB = freq
    phaseR = 0
    phaseG = 2
    phaseB = 4
    width = 128
    center = 127
    yInc = @height / NUM_KEYBOARD_NOTES
    for i in [0...NUM_KEYBOARD_NOTES]
      r = Math.round(Math.sin(freqR * i + phaseR) * width + center)
      g = Math.round(Math.sin(freqG * i + phaseG) * width + center)
      b = Math.round(Math.sin(freqB * i + phaseB) * width + center)
      @canvasContext.fillStyle = rgb2Color(r, g, b)
      @canvasContext.fillRect 0, yInc * i, @width, @height

class Synth
  constructor: (@audioContext) ->
    @vco = @_createVco()
    @vca = @_createVca()
    @vco.connect @vca
    @vca.connect @audioContext.destination

  playPad: (x, y) ->
    midiNoteNumber = Math.round(y * NUM_KEYBOARD_NOTES) + KEYBOARD_START
    @playMidiNote(midiNoteNumber)

  playMidiNote: (midiNoteNumber) ->
    noteFrequencyHz = 27.5 * Math.pow(2, (midiNoteNumber - 21) / 12)
    @vco.frequency.value = noteFrequencyHz
    @vca.gain.value = 1

  stop: ->
    @vca.gain.value = 0

  _createVco: ->
    vco = @audioContext.createOscillator()
    vco.type = vco.SQUARE
    vco.frequency.value = 0
    vco.start(0)
    vco

  _createVca: ->
    vca = @audioContext.createGain()
    vca.gain.value = 0
    vca


if Meteor.isClient
  sendChat = (message) ->
    chatStream.emit 'message', message
  $ ->
    FastClick.attach(document.body)

  audioContext = null
  canvasContext = null
  midicps= null
  synth = null
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


  Meteor.startup ->
    window.AudioContext = window.AudioContext or window.webkitAudioContext
    synth = new Synth(new AudioContext())

  Template.controller.rendered = ->
    keyboardCanvas = @find '.keyboard'
    keyboard = new Keyboard(keyboardCanvas, window.innerWidth,
                            window.innerHeight)
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


