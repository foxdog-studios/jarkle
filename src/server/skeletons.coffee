Meteor.methods
  skeletons: (roomId, skeletons) ->
    check roomId, String
    check skeletons, [Object]
    Stream.emit "#{ roomId }:skeletons", skeletons

