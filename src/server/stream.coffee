@Stream = new Meteor.Stream 'stream'


Stream.permissions.read ->
  true


Stream.permissions.write (eventName, event) ->
  if event.isMaster
    return true
  cursor = Players.find
    playerId: event.userId
    isEnabled: true
  cursor.count() == 1
,
  false

