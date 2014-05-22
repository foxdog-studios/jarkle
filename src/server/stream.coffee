@Stream = new Meteor.Stream 'stream'

Stream.permissions.read ->
  true

Stream.permissions.write ->
  true

