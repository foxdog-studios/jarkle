class @AxisNoteBuilder
  constructor: (@_pitches, @_axis) ->

  build: (input) ->
    frequency: @_calcFrequency input
    inputId: input.inputId
    isMaster: input.isMaster
    userId: input.userId

  _calcFrequency: (input) ->
    @_pitches[@_calcPitchIndex input].getFrequency()

  _calcPitchIndex: (input) ->
    index = Math.floor input[@_axis.axis] * @_pitches.length
    index = @_pitches.length - index - 1 if @_axis.inverted
    index

