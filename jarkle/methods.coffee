Meteor.methods
  midiNoteOn: (midiNoteNumber) ->
    chatStream.emit 'midiNoteOn', midiNoteNumber
  skeleton: (skeleton) ->
    chatStream.emit 'skeleton', skeleton

