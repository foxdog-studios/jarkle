@Voice = class Voice
  constructor: (@audioContext, @oscillatorType, @gainOnValue) ->
    @vco = @_createVco()
    @vca = @_createVca()
    @vco.connect @vca
    @vca.connect @audioContext.destination
    return
    window.addEventListener('touchstart', () =>
      # create empty buffer
      buffer = @audioContext.createBuffer(1, 1, 22050)
      source = @audioContext.createBufferSource()
      source.buffer = buffer

      # connect to output (your speakers)
      source.connect(@audioContext.destination)

      # play the file
      if source.noteOn?
        source.noteOn(0)
      else
        source.start(0)

    , false)


  _createVco: ->
    try
      vco = @audioContext.createOscillator()
    catch error
      alert 'Could not create Oscillator node :('
    vco.type = vco[@oscillatorType]
    vco.frequency.value = 0
    if vco.noteOn?
      vco.noteOn(0)
    else
      vco.start(0)
    return vco

  _createVca: ->
    vca = @audioContext.createGainNode()
    vca.gain.value = 0
    return vca

