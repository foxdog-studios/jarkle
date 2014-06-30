class @PubsubListener extends AbstractListener
  constructor: (@_pubsub, listeners) ->
    super listeners

  on: (type, listener) ->
    @_pubsub.on type, listener

  off: (type, listener) ->
    @_pubsub.off type, listener

