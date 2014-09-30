class @StreamListener extends AbstractListener
  constructor: (@_stream, roomId, listeners) ->
    roomListeners = {}
    for type, listener of listeners
      roomListeners["#{ roomId }:#{ type }"] = listener
    super roomListeners

  on: (type, listener) ->
    @_stream.on type, listener

  off: (type, listener) ->
    @_stream.removeListener type, listener

