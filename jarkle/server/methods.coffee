Meteor.methods
  messageSent: (roomName, args) ->
    chatStream.emit roomName, args

