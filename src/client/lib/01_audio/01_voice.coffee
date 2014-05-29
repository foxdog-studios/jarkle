class @Voice
  constructor: (ctx, oscillatorType, @_startGain) ->
    @_oscillator = ctx.createOscillator()
    @_oscillator.type = oscillatorType
    @_oscillator.frequency.value = 0
    @_oscillator.start 0

    @_gain = ctx.createGain()
    @_gain.gain.value = 0

    @_oscillator.connect @_gain
    @_gain.connect ctx.destination

    @_vibratorMultiplier =  Settings.voices.vibrato.multiplier

  _setFrequency: (frequency) ->
    @_oscillator.frequency.value = frequency

  _setDetune: (detune) ->
    @_oscillator.detune.value = detune

  _setGain: (gain) ->
    @_gain.gain.value = gain

  start: (note) ->
    @_setFrequency note.frequency
    @_setGain @_startGain

  move: (note) ->
    @_setFrequency note.frequency

  stop: ->
    @_setGain 0

  detune: (input) ->
    pitchAxis = Singletons.getPitchAxis()
    detuneRatio = input[pitchAxis.inverseAxis] - 0.5
    @_setDetune detuneRatio * @_vibratorMultiplier

