class @PubsubInputListener extends PubsubListener
  constructor: (pubsub, listener) ->
    super pubsub,
      'input:start': listener.onInputStart
      'input:move': listener.onInputMove
      'input:stop': listener.onInputStop

