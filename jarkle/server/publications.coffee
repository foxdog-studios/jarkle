Meteor.publish 'userStatus', ->
  Meteor.users.find 'profile.online': true

