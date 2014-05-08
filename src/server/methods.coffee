Meteor.methods
  messageSent: (roomName, args) ->
    chatStream.emit roomName, args

  midiNoteOn: (noteInfo) ->
    chatStream.emit 'midiNoteOn', noteInfo

  midiDrumsNoteOn: (noteInfo) ->
    chatStream.emit 'midiDrumsNoteOn', noteInfo

  skeleton: (skeleton) ->
    chatStream.emit 'skeleton', skeleton

