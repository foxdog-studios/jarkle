Template.lobbyRoomListItem.helpers
  name: ->
    @roomId

  numPlayers: ->
    Players.find(roomId: @roomId).count()

