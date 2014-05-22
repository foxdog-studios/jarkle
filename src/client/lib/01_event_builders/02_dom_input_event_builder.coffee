class @DomInputEventBuilder extends InputEventBuilder
  constructor: (@_target, inputName, isMaster) ->
    super inputName, isMaster
    @_$target = $(@_target)

  _calcRatio: (page, offset, size, invert) ->
    # -1 so pixels are 0-indexed.
    ratio = (page - offset - 1) / size

    # The ratio if the event occured on the last pixel.
    maxRatio = 1 - 1 / size

    # Camp the ratio between 0 (inclusive) and 1 (exclusive)
    ratio = Math.max 0, Math.min maxRatio, ratio

    # Invert if required.
    ratio = maxRatio - ratio if invert

    ratio

  build: (event) ->
    offset = @_$target.offset()
    x = @_calcRatio event.pageX, offset.left, @_$target.width(), false
    # Invert to match a) 3D graphics and b) the layout of a piano.
    y = @_calcRatio event.pageY, offset.top, @_$target.height(), true
    super x, y

