Meteor.methods
  midiNoteOn: (noteInfo) ->
    chatStream.emit 'midiNoteOn', noteInfo
  midiDrumsNoteOn: (noteInfo) ->
    chatStream.emit 'midiDrumsNoteOn', noteInfo
  skeleton: (skeleton) ->
    chatStream.emit 'skeleton', skeleton

