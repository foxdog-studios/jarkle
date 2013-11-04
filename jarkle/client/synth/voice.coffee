@Voice = class Voice
  constructor: (@audioContext) ->
    @vco = @_createVco()
    @vca = @_createVca()
    @vco.connect @vca
    @vca.connect @audioContext.destination

  _createVco: ->
    vco = @audioContext.createOscillator()
    vco.type = vco.SQUARE
    vco.frequency.value = 0
    vco.start(0)
    vco

  _createVca: ->
    vca = @audioContext.createGain()
    vca.gain.value = 0
    vca

