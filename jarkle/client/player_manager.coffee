class @PlayerManager
  constructor: (@schema) ->
    @userIdToPlayerIdMap = {}
    @playerIds = []
    @currentPlayerIdIndex = 0
    for playerId, playerData of @schema
      @playerIds.push playerId

  getPlayerIdFromUserId: (userId) ->
    playerId = @userIdToPlayerIdMap[userId]
    if playerId?
      return playerId
    playerId = @playerIds[@currentPlayerIdIndex]
    @currentPlayerIdIndex = (@currentPlayerIdIndex + 1) % @playerIds.length
    @userIdToPlayerIdMap[userId] = playerId
    return playerId

