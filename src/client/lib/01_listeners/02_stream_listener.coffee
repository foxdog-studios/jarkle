class @StreamListener extends AbstractListener
  constructor: (@_stream, roomId, listeners) ->
    @_roomId = roomId

    wrapper = {}
    wrapper[roomId] = (type, data) ->
      if (listener = listeners[type])?
        listener data

    super wrapper

  on: (type, listener) ->
    @_stream.on type,  listener

  off: (type, listener) ->
    @_stream.removeListener type, listener

