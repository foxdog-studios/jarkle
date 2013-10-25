rgb2Color = (r,g,b) ->
  "rgb(#{r},#{g},#{b})"

@Keyboard = class Keyboard
  constructor: (@canvas, @width, @height, @numNotes) ->
    @canvas.width = @width
    @canvas.height = @height
    @canvasContext = canvas.getContext '2d'

  drawKeys: ->
    # Draws a rainbow keyboard
    freq = 0.05
    freqR = freq
    freqG = freq
    freqB = freq
    phaseR = 0
    phaseG = 2
    phaseB = 4
    width = 128
    center = 127
    yInc = @height / @numNotes
    for i in [0...@numNotes]
      r = Math.round(Math.sin(freqR * i + phaseR) * width + center)
      g = Math.round(Math.sin(freqG * i + phaseG) * width + center)
      b = Math.round(Math.sin(freqB * i + phaseB) * width + center)
      @canvasContext.fillStyle = rgb2Color(r, g, b)
      @canvasContext.fillRect 0, yInc * i, @width, @height

