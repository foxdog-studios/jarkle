class @Voices
  constructor: (pubsub, @_ctx) ->
    @_voices = {}
    @_listener = new PubsubNoteListener pubsub, this

  _apply: (note, funcName) ->
    @_voices[note.inputId][funcName] note.frequency

  onNoteStart: (note) =>
    unless @_voices[note.inputId]?
      @_voices[note.inputId] = new Voice @_ctx, 'sine'
    @_apply note, 'start'

  onNoteMove: (note) =>
    @_apply note, 'move'

  onNoteStop: (note) =>
    @_apply note, 'stop'

  enable: ->
    @_listener.enable()

  disable: ->
    @_listener.disable()

###
THRESHOLD = Meteor.settings.public.synthThreshold
X_THRESHOLD = THRESHOLD
Y_THRESHOLD = THRESHOLD
Z_THRESHOLD = THRESHOLD

DEFAULT_OSCILLATOR_TYPE = 'SQUARE'
DEFAULT_GAIN_ON_VALUE = 0.7

class @Synth
  constructor: (@audioContext, @noteMap, @pubSub, @schema, @skeletonConfig) ->
    @voices = {}

  handleMessage: (message, playerId) =>
    id = message.identifier
    if message.noteOn
      @playPad(message.x, message.y, id, playerId)
    else
      @stopPad(id)

  playPad: (x, y, identifier, playerId) ->
    midiNoteNumber = @noteMap.getNote(1 - y, x)
    @playNote(midiNoteNumber, identifier, playerId)

  playNote: (midiNoteNumber, identifier, playerId) ->
    voice = @voices[identifier]
    unless voice?
      if playerId?
        synthData = @schema[playerId].synth
        oscillatorType = synthData.oscillatorType
        gainOnValue = synthData.gainOnValue
      else
        oscillatorType = DEFAULT_OSCILLATOR_TYPE
        gainOnValue = DEFAULT_GAIN_ON_VALUE
      voice = new Voice @audioContext, oscillatorType, gainOnValue
      @voices[identifier] = voice
    @playMidiNote(midiNoteNumber, voice)

  playSkeletons: (skeletons) =>
    if skeletons.length > 0
      skeleton = skeletons[0].skeleton
      for pairA, pairs of @skeletonConfig
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
      for pairA, pairs of @skeletonConfig
        for pairData in pairs
          pairB = pairData.pairPoint
          id = "#{pairA}#{pairB}"
          if @voices[id]? and @voices[id].vca.gain.value > 0
            @pubSub.trigger PAIRS_TOUCHING, pairA, pairB, false
          @stopPad(id)

  playMidiNote: (midiNoteNumber, voice) ->
    noteFrequencyHz = 27.5 * Math.pow(2, (midiNoteNumber - 21) / 12)
    voice.vco.frequency.value = noteFrequencyHz
    voice.vca.gain.value = voice.gainOnValue

  stopPad: (identifier) ->
    voice = @voices[identifier]
    if voice?
      @stop(voice)

  stop: (voice) ->
    voice.vca.gain.value = 0

  stopAll: ->
    for identifier, voice of @voices
      @stop(voice)
###
