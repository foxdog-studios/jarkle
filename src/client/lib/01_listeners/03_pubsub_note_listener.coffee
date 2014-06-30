class @PubsubNoteListener extends PubsubListener
  constructor: (pubsub, listener) ->
    super pubsub,
      'note:start': listener.onNoteStart
      'note:move': listener.onNoteMove
      'note:stop': listener.onNoteStop

