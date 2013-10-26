Meteor.methods
  midiNoteOn: (midiNoteNumber) ->
    chatStream.emit 'midiNoteOn', midiNoteNumber

