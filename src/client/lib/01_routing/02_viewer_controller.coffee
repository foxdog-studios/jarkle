class @ViewerController extends RoomController
  isMaster: true

  waitOn: ->
    handles = super()
    handles.push Meteor.subscribe 'playerCount', @data().roomId
    handles

  template: 'viewer'

