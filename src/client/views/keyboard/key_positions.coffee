class @KeyPositions
  constructor: (@_canvas, @_pitches, pitchAxis) ->
    @_axis = pitchAxis.axis
    @_inverted = pitchAxis.inverted
    @_numKeys = @_pitches.length

  calcPositions: ->
    @_byFrequency = {}
    @_byIndex = []

    width = @_calcWidth()
    height = @_calcHeight()

    for pitch, index in @_pitches
      position =
        x: @_calcX index
        y: @_calcY index
        width: width
        height: height

      @_byFrequency[pitch.getFrequency()] = position
      @_byIndex.push position

  _calcWidth: ->
    @_calcSize 'x', 'width'

  _calcHeight: ->
    @_calcSize 'y', 'height'

  _calcSize: (axis, dimension) ->
    size = @_canvas[dimension]
    if @_axis == axis
      size = Math.ceil size / @_numKeys
    size

  _calcX: (keyIndex) ->
    @_calcOffset 'x', 'width', keyIndex

  _calcY: (keyIndex) ->
    @_calcOffset 'y', 'height', keyIndex

  _calcOffset: (axis, dimension, keyIndex) ->
    if @_axis == axis
      size = @_canvas[dimension]
      offset = size * keyIndex / @_numKeys
      if (axis == 'x' and @_inverted)  or (axis == 'y' and not @_inverted)
        offset = size - offset - size / @_numKeys
      Math.ceil offset
    else
      0

  getByFrequency: (frequency) ->
    @_byFrequency[frequency]

  getByIndex: (pitchIndex) ->
    @_byIndex[pitchIndex]

  getNumKeys: ->
    @_pitches.length

