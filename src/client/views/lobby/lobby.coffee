Template.lobby.helpers
  rooms: ->
    Rooms.find {},
      sort: [
        ['roomId', 'asc']
      ]

