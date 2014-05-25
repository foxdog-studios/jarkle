class @StreamDrumHitListener extends StreamListener
  constructor: (stream, roomId, listener) ->
    super stream, roomId,
      drumHit: listener.onDrumHit

