@Synth = class Synth
  constructor: (@audioContext, @numNotes, @startNote, @pubSub, @eventType) ->
    @vco = @_createVco()
    @vca = @_createVca()
    @vco.connect @vca
    @vca.connect @audioContext.destination
    @pubSub.on @eventType, @handleMessage

  handleMessage: (message) =>
    if message.noteOn
      @playPad(message.x, message.y)
    else
      @stop()

  playPad: (x, y) ->
    midiNoteNumber = Math.round(y * @numNotes) + @startNote
    @playMidiNote(midiNoteNumber)

  playMidiNote: (midiNoteNumber) ->
    noteFrequencyHz = 27.5 * Math.pow(2, (midiNoteNumber - 21) / 12)
    @vco.frequency.value = noteFrequencyHz
    @vca.gain.value = 1

  stop: ->
    @vca.gain.value = 0

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

