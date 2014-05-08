Meteor.publish 'userStatus', ->
  Meteor.users.find 'status.online': true

