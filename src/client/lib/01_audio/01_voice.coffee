class @Voice
  constructor: (ctx, oscillatorType) ->
    @_oscillator = ctx.createOscillator()
    @_oscillator.type = oscillatorType
    @_oscillator.frequency.value = 0
    @_oscillator.start 0

    @_gain = ctx.createGainNode()
    @_gain.gain.value = 0

    @_oscillator.connect @_gain
    @_gain.connect ctx.destination

  _setFrequency: (frequency) ->
    @_oscillator.frequency.value = frequency

  _setGain: (gain) ->
    @_gain.gain.value = gain

  start: (frequency) ->
    @_setFrequency frequency
    @_setGain 1

  move: (frequency) ->
    @_setFrequency frequency

  stop: ->
    @_setGain 0

