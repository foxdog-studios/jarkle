Meteor.onConnection (connection) ->
  connection.onClose ->
    RoomControls.leaveRooms connection.id

