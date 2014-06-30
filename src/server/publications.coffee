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


Meteor.publish 'playerCount', (roomId) ->
  check roomId, String
  count = 0
  initializing = true

  handle = Players.find(roomId: roomId).observeChanges
    added: (id) =>
      count++
      unless initializing
        @changed 'counts', roomId, count: count

    removed: (id) =>
      count--
      @changed 'counts', roomId, count: count

  initializing = false
  @added 'counts', roomId, count: count
  @ready()

  @onStop ->
    handle.stop()

