chatStream = new Meteor.Stream 'chat'

IMAGE_SIZE = 64
FACE_SIZE = 128
NUM_KEYBOARD_NOTES = 127

rgb2Color = (r,g,b) ->
  "rgb(#{r},#{g},#{b})"

class Keyboard
  constructor: (@canvas, @width, @height) ->
    @canvas.width = @width
    @canvas.height = @height
    @canvasContext = canvas.getContext '2d'

  drawKeys: ->
    freqR = 0.05
    freqG = 0.05
    freqB = 0.05
    phaseR = 4
    phaseG = 5
    phaseB = 0
    width = 128
    center = 127
    yInc = @height / NUM_KEYBOARD_NOTES
    for i in [0...NUM_KEYBOARD_NOTES]
      r = Math.round(Math.sin(freqR * i + phaseR) * width + center)
      g = Math.round(Math.sin(freqG * i + phaseG) * width + center)
      b = Math.round(Math.sin(freqB * i + phaseB) * width + center)
      @canvasContext.fillStyle = rgb2Color(r, g, b)
      console.log @canvasContext.fillStyle, i, r, g, b
      @canvasContext.fillRect 0, yInc * i, @width, @height


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


  Meteor.startup ->
    window.AudioContext = window.AudioContext or window.webkitAudioContext
    audioContext = new AudioContext()

  playSound = (x, y) ->
    oscillator = audioContext.createOscillator()
    oscillator.type = oscillator.SINE
    midiNote = Math.round(y * NUM_KEYBOARD_NOTES)
    freq =27.5 * Math.pow(2, ((midiNote - 21)/12))
    oscillator.frequency.value = freq
    oscillator.connect(audioContext.destination)
    oscillator.noteOn && oscillator.noteOn(0)
    window.setTimeout((->
      oscillator.disconnect()), 50)


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
      [x, y] = [message.x, message.y]
      playSound(x, y)
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

  Template.controller.events
    'mousedown .controller, touchstart .controller, touchmove .controller': \
        (e) ->
      if e.touches?
        touch =  e.touches[0]
        rawX = touch.pageX
        rawY = touch.pageY
      else
        rawX = e.pageX
        rawY = e.pageY
      x = rawX / window.innerWidth
      y = rawY / window.innerHeight
      sendChat x: x, y: y
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

