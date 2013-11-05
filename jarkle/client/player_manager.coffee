class @PlayerManager
  constructor: (@schema) ->
    @userIdToPlayerIdMap = {}
    @playerIds = []
    @currentPlayerIdIndex = 0
    @currentPlayerIndex = 0
    for playerId, playerData of @schema
      @playerIds.push playerId

  getPlayerFromUserId: (userId) ->
    player = @userIdToPlayerIdMap[userId]
    if player?
      return player
    playerId = @playerIds[@currentPlayerIdIndex]
    @currentPlayerIdIndex = (@currentPlayerIdIndex + 1) % @playerIds.length
    player =
      id: playerId
      enabled: true
    @userIdToPlayerIdMap[userId] = player
    return player

  getNextActivePlayerId: ->
    users = Meteor.users.find({}, {sort: _id: 1})
    if users.count() > 0
      nextUser = users.fetch()[@currentPlayerIdIndex]
      @currentPlayerIdIndex = (@currentPlayerIdIndex + 1) % users.count()
      return nextUser
    return null

