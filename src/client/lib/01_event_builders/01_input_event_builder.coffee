class @InputEventBuilder
  constructor: (@_inputName, @_isMaster) ->

  build: (x, y) ->
    player = Players.findOne {},
      fields:
        playerId: 1
    playerId = player.playerId

    inputId: "#{ playerId }:#{ @_inputName }"
    userId: playerId
    isMaster: @_isMaster
    x: x
    y: y

