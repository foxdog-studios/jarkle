class @AxisNoteBuilder
  constructor: (@_pitches, @_axis) ->

  build: (input) ->
    inputId: input.inputId
    userId: input.userId
    frequency: @_calcFrequency input

  _calcFrequency: (input) ->
    @_pitches[@_calcPitchIndex input].getFrequency()

  _calcPitchIndex: (input) ->
    index = Math.floor input[@_axis.axis] * @_pitches.length
    index = @_pitches.length - index - 1 if @_axis.inverted
    index

