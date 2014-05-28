class @PubsubAndStreamInputTrigger extends CompositeInputTrigger
  constructor: (pubsub, stream, roomId) ->
    pubsubTrigger = new PubsubInputTrigger Singletons.getPubsub()
    streamTrigger = new StreamInputTrigger Singletons.getStream(), roomId
    super [pubsubTrigger, streamTrigger]

