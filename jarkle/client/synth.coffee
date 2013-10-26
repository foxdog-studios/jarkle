@Synth = class Synth
  constructor: (@audioContext, @numNotes, @startNote, @pubSub, @eventType) ->
    @pubSub.on @eventType, @handleMessage
    @voices = {}

  handleMessage: (message) =>
    if message.noteOn
      @playPad(message.x, message.y, message.identifier)
    else
      @stopPad(message.identifier)

  playPad: (x, y, identifier) ->
    midiNoteNumber = Math.round(y * @numNotes) + @startNote
    voice = @voices[identifier]
    unless voice?
      voice = new Voice @audioContext
      @voices[identifier] = voice
    @playMidiNote(midiNoteNumber, voice)

  playMidiNote: (midiNoteNumber, voice) ->
    noteFrequencyHz = 27.5 * Math.pow(2, (midiNoteNumber - 21) / 12)
    voice.vco.frequency.value = noteFrequencyHz
    voice.vca.gain.value = 1

  stopPad: (identifier) ->
    voice = @voices[identifier]
    if voice?
      @stop(voice)

  stop: (voice) ->
    voice.vca.gain.value = 0

