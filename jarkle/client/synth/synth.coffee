THRESHOLD = 200
X_THRESHOLD = THRESHOLD
Y_THRESHOLD = THRESHOLD
Z_THRESHOLD = THRESHOLD

PROXIMITY_PAIRS =
  leftHand: [
    pairPoint: 'rightHand'
    note: 56
  ,
    pairPoint: 'leftShoulder'
    note: 58
  ,
    pairPoint: 'leftHip'
    note: 65
  ]
  rightHand: [
    pairPoint: 'rightShoulder'
    note: 63
  ,
    pairPoint: 'rightHip'
    note: 62
  ,
    pairPoint: 'leftShoulder'
    note: 60
  ]

DEFAULT_OSCILLATOR_TYPE = 'SQUARE'

class @Synth
  constructor: (@audioContext, @noteMap, @pubSub, @schema) ->
    @voices = {}

  handleMessage: (message, playerId) =>
    if message.noteOn
      @playPad(message.x, message.y, message.identifier, playerId)
    else
      @stopPad(message.identifier)

  playPad: (x, y, identifier, playerId) ->
    midiNoteNumber = @noteMap.getNote(1 - y)
    @playNote(midiNoteNumber, identifier, playerId)

  playNote: (midiNoteNumber, identifier, playerId) ->
    voice = @voices[identifier]
    unless voice?
      if playerId?
        oscillatorType = @schema[playerId].synth.oscillatorType
      else
        oscillatorType = DEFAULT_OSCILLATOR_TYPE
      voice = new Voice @audioContext, oscillatorType
      @voices[identifier] = voice
    @playMidiNote(midiNoteNumber, voice)

  playSkeletons: (skeletons) =>
    if skeletons.length > 0
      skeleton = skeletons[0].skeleton
      for pairA, pairs of PROXIMITY_PAIRS
        for pairData in pairs
          pairB = pairData.pairPoint
          pointA = skeleton[pairA]
          pointB = skeleton[pairB]
          id = "#{pairA}#{pairB}"
          if @_pointsInProximity(pointA, pointB)
            @pubSub.trigger PAIRS_TOUCHING, pairA, pairB, true
            @playNote(pairData.note, id)
          else
            if @voices[id]? and @voices[id].vca.gain.value > 0
              @pubSub.trigger PAIRS_TOUCHING, pairA, pairB, false
            @stopPad(id)
    else
      for pairA, pairs of PROXIMITY_PAIRS
        for pairData in pairs
          pairB = pairData.pairPoint
          id = "#{pairA}#{pairB}"
          if @voices[id]? and @voices[id].vca.gain.value > 0
            @pubSub.trigger PAIRS_TOUCHING, pairA, pairB, false
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

  stopAll: ->
    for identifier, voice of @voices
      @stop(voice)

