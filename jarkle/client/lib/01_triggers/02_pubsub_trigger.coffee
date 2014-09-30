class @PubsubTrigger extends AbstractTrigger
  constructor: (@_pubsub, type)  ->
    super type

  trigger: (type, data) ->
    @_pubsub.trigger type, data

