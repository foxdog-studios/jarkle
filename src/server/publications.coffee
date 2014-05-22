Meteor.publish 'room', (roomId) ->
  check roomId, String
  Rooms.find
    roomId: roomId


Meteor.publish 'player', ->
  Players.find
    playerId: @connection.id

