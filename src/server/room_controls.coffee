# ==============================================================================
# = Queue                                                                      =
# ==============================================================================

queue = new PowerQueue
  isPaused: true


Meteor.startup ->
  queue.add (done) ->
    Players.remove {}
    Rooms.remove {}
    done()
  queue.run()


class @RoomControls
  add = (func) ->
    queue.add (done) ->
      func()
      done()

  @joinRoom: (roomId, playerId, isMaster) ->
    add -> joinRoom roomId, playerId, isMaster

  @leaveRooms: (playerId) ->
    add -> leaveRooms playerId

  @showMessage: (roomId) ->
    add -> showMessage roomId

  @hideMessage: (roomId) ->
    add -> hideMessage roomId

  @enableSinglePlayer: (roomId) ->
    add -> enableSinglePlayer roomId

  @enableAllPlayers: (roomId) ->
    add -> enableAllPlayers roomId

  @disableAllPlayers: (roomId) ->
    add -> disableAllPlayers roomId


# ==============================================================================
# = Room controls                                                              =
# ==============================================================================

joinRoom = (roomId, playerId, isMaster) ->
  # Enable the player if they are a master or that is the default
  # state.
  isEnabled = if isMaster or Settings.players.enableOnJoin
    true
  else
    # The joining player should be enabled if all players in the room
    # are enabled.
    Rooms.findOne(roomId: roomId, allEnabled: true)?

  Players.upsert
    playerId: playerId
  ,
    $set:
      isEnabled: isEnabled
      isMaster: isMaster
      name: generateName()
      roomId: roomId
    $unset:
      singledAt: ''


leaveRooms = (playerId) ->
  player = Players.findOne
    playerId: playerId

  return unless player?

  # If the player is the singularly enabled player in a room, select
  # another player.
  Rooms.find(enabledPlayerId: playerId).forEach (room) ->
    enableSinglePlayer room.roomId

  # Remove the player.
  Players.remove
    playerId: playerId


showMessage = (roomId) ->
  Rooms.upsert
    roomId: roomId
  ,
    $set:
      message: Settings.viewer.message


hideMessage = (roomId) ->
  Rooms.update
    roomId: roomId
  ,
    $unset:
      message: ''


enableSinglePlayer = (roomId) ->
  # Find a player that has never been singularly enabled or the
  # player that was singularly enabled longest ago.
  player = Players.findOne
    isMaster: false
    roomId: roomId
  ,
    sort: [
      ['singledAt', 'asc']
    ]

  if player?
    # Disable all players in the room.
    Players.update
      isEnabled: true
      roomId: roomId
    ,
      $set:
        isEnabled: false
    ,
      multi: true

    # Enable the player.
    Players.update
      playerId: player.playerId
    ,
      $set:
        isEnabled: true
        singledAt: Date.now()

    # Update the room message.
    Rooms.upsert
      roomId: roomId
    ,
      $set:
        allEnabled: false
        enabledPlayerId: player.playerId
        message: player.name
  else
    # Show a message indicating the were no players to enable.
    Rooms.upsert
      roomId: roomId
    ,
      $set:
        allEnabled: false
        message: 'No players :('
      $unset:
        enabledPlayerId: ''


enableAllPlayers = (roomId) ->
  Players.update
    isEnabled: false
    isMaster: false
    roomId: roomId
  ,
    $set:
      isEnabled: true
  ,
    multi: true

  Rooms.upsert
    roomId: roomId
  ,
    $set:
      allEnabled: true
      message: 'Everyone'
    $unset:
      enabledPlayerId: ''


disableAllPlayers = (roomId) ->
  Players.update
    isEnabled: true
    isMaster: false
    roomId: roomId
  ,
    $set:
      isEnabled: false
  ,
    multi: true

  Rooms.upsert
    roomId: roomId
  ,
    $set:
      allEnabled: false
    $unset:
      enabledPlayerId: ''
      message: ''

