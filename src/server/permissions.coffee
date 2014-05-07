Meteor.users.allow
  update: (userId, doc) ->
    doc._id == userId

