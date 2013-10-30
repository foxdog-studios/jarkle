THRESHOLD = 200
X_THRESHOLD = THRESHOLD
Y_THRESHOLD = THRESHOLD
Z_THRESHOLD = THRESHOLD

PROXIMITY_PAIRS =
  leftHand: [
    pairPoint: 'rightHand'
    note: 62
  ,
    pairPoint: 'leftShoulder'
    note: 64
  ,
    pairPoint: 'leftHip'
    note: 67
  ]
  rightHand: [
    pairPoint: 'rightShoulder'
    note: 66
  ,
    pairPoint: 'rightHip'
    note: 69
  ]

class @Synth
  constructor: (@audioContext, @noteMap) ->
    @voices = {}

  handleMessage: (message) =>
    if message.noteOn
      @playPad(message.x, message.y, message.identifier)
    else
      @stopPad(message.identifier)

  playPad: (x, y, identifier) ->
    midiNoteNumber = @noteMap.getNote(y)
    @playNote(midiNoteNumber, identifier)

  playNote: (midiNoteNumber, identifier) ->
    voice = @voices[identifier]
    unless voice?
      voice = new Voice @audioContext
      @voices[identifier] = voice
    @playMidiNote(midiNoteNumber, voice)

  playSkeletons: (skeletons) =>
    skeleton = skeletons[0].skeleton
    for pairA, pairs of PROXIMITY_PAIRS
      for pairData in pairs
        pairB = pairData.pairPoint
        pointA = skeleton[pairA]
        pointB = skeleton[pairB]
        id = "#{pairA}#{pairB}"
        if @_pointsInProximity(pointA, pointB)
          @playNote(pairData.note, id)
        else
          @stopPad(id)

  _pointsInProximity: (pointA, pointB) ->
    return Math.abs(pointA.x - pointB.x) < X_THRESHOLD \
      and Math.abs(pointA.y - pointB.y) < Y_THRESHOLD \
      and Math.abs(pointA.z - pointB.z) < Z_THRESHOLD


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

