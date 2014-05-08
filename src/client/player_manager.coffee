class @PlayerManager
  constructor: (@schema) ->
    @userIdToPlayerIdMap = {}
    @playerIds = []
    @masterIds = []
    @currentPlayerIdIndex = 0
    @currentPlayerIndex = 0
    for playerId, playerData of @schema
      if playerData.isMaster
        @masterIds.push playerId
      else
        @playerIds.push playerId

  getPlayerFromUserId: (userId, isMaster) ->
    player = @userIdToPlayerIdMap[userId]
    if player?
      return player
    if isMaster
      playerId = @masterIds[0]
    else
      playerId = @playerIds[@currentPlayerIdIndex]
    @currentPlayerIdIndex = (@currentPlayerIdIndex + 1) % @playerIds.length
    player =
      id: playerId
      enabled: true
    @userIdToPlayerIdMap[userId] = player
    return player

  getNextActivePlayerId: ->
    users = Meteor.users.find({isMaster: false}, {sort: _id: 1})
    if users.count() > 0
      nextUser = users.fetch()[@currentPlayerIdIndex]
      @currentPlayerIdIndex = (@currentPlayerIdIndex + 1) % users.count()
      return nextUser
    return null

