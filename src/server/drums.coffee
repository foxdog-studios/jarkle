Meteor.methods
  drumHit: (roomId, drumName) ->
    check roomId, String
    check drumName, String
    Stream.emit "#{ roomId }:drumHit", drumName

