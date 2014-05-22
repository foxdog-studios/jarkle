class @StreamTrigger extends AbstractTrigger
  constructor: (@_stream, @_roomId, type) ->
    super type

  trigger: (type, data) ->
    @_stream.emit @_roomId, type, data

