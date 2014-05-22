Meteor.methods
  joinRoom: (roomId, isMaster) ->
    check roomId, String
    check isMaster, Boolean
    RoomControls.joinRoom roomId, @connection.id, isMaster
    undefined

  leaveRooms: ->
    RoomControls.leaveRooms @connection.id
    undefined

  showMessage: (roomId) ->
    check roomId, String
    RoomControls.showMessage roomId
    undefined

  hideMessage: (roomId) ->
    check roomId, String
    RoomControls.hideMessage roomId
    undefined

  enableSinglePlayer: (roomId) ->
    check roomId, String
    RoomControls.enableSinglePlayer roomId
    undefined

  enableAllPlayers: (roomId) ->
    check roomId, String
    RoomControls.enableAllPlayers roomId
    undefined

  disableAllPlayers: (roomId) ->
    check roomId, String
    RoomControls.disableAllPlayers roomId
    undefined

