class @StreamSkeletonsListener extends StreamListener
  constructor: (stream, roomId, listener) ->
    super stream, roomId,
      skeletons: listener.onSkeletons

