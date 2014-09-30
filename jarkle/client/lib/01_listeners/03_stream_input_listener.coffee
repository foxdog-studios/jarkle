class @StreamInputListener extends StreamListener
  constructor: (stream, roomId, listener) ->
    super stream, roomId,
      'input:start': listener.onInputStart
      'input:move': listener.onInputMove
      'input:stop': listener.onInputStop

