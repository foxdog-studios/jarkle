Meteor.publish 'room', (roomId) ->
  check roomId, String
  Rooms.find
    roomId: roomId


Meteor.publish 'rooms', ->
  Rooms.find()


Meteor.publish 'player', ->
  Players.find
    playerId: @connection.id


Meteor.publish 'players', ->
  Players.find()

