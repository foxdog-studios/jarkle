class @KeyPublisher
  constructor: (pubsub, pitches) ->
    @_numNotesPerPitch = {}
    for pitch in pitches
      @_numNotesPerPitch[pitch.getFrequency()] = 0

    @_listener = new PubsubNoteListener pubsub, this
    @_trigger = new PubsubKeyTrigger pubsub

  onNoteStart: (note) =>
    @_inc note.frequency

  onNoteMove: (note) =>
    @_dec note.previous.frequency
    @_inc note.frequency

  onNoteStop: (note) =>
    @_dec note.frequency

  # TODO: We may receive frequencies that we don't have keys for. For
  #       example, if the note originates from the skeleton, not the
  #       keyboard. As a work around, we check beforehand. Ideally
  #       we could limit our subscriptions.

  _inc: (frequency) ->
    if @_numNotesPerPitch[frequency]?
      if (@_numNotesPerPitch[frequency] += 1) == 1
        @_trigger.start frequency

  _dec: (frequency) ->
    if @_numNotesPerPitch[frequency]?
      if (@_numNotesPerPitch[frequency] -= 1) == 0
        @_trigger.stop frequency

  enable: ->
    @_listener.enable()

  disable: ->
    @_listener.disable()

