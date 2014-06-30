class @KeyboardDrawer
  constructor: (@_canvas, @_keyPositions) ->
    @_ctx = @_canvas.getContext '2d'
    @_phases = @_randomPhases()

  _randomPhases: ->
    randomPhase = ->
      Math.random() * 2
    datum = randomPhase()
    r: datum
    g: datum + randomPhase()
    b: datum + randomPhase()

  draw: ->
    freqR = freqG = freqB = 0.5 * @_keyPositions.getNumKeys()
    width = 128
    center = 127

    for i in [0...@_keyPositions.getNumKeys()]
      r = Math.round(Math.sin(freqR * i + @_phases.r) * width + center)
      g = Math.round(Math.sin(freqG * i + @_phases.g) * width + center)
      b = Math.round(Math.sin(freqB * i + @_phases.b) * width + center)
      @_ctx.fillStyle = rgb2Color r, g, b

      pos = @_keyPositions.getByIndex i
      @_ctx.fillRect pos.x, pos.y, pos.width, pos.height

