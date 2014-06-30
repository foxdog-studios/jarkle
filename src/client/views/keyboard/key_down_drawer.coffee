class @KeyDownDrawer
  constructor: (@_canvas, @_keyPositions) ->
    @_ctx = @_canvas.getContext '2d'
    @_fillStyle = rgb2Color 255, 255, 255

  onKeyStart: (frequency) =>
    @_ctx.fillStyle = @_fillStyle
    @_apply 'fillRect', frequency

  onKeyStop: (frequency) =>
    @_apply 'clearRect', frequency

  _apply: (name, frequency) ->
    pos = @_keyPositions.getByFrequency frequency
    @_ctx[name] pos.x, pos.y, pos.width, pos.height

