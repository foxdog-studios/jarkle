class @PubsubKeyListener extends PubsubListener
  constructor: (pubsub, listener) ->
    super pubsub,
      'key:start': listener.onKeyStart
      'key:move': listener.onKeyMove
      'key:stop': listener.onKeyStop

