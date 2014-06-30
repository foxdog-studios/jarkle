class @LobbyController extends RouteController
  template: 'lobby'

  onRun: ->
    Meteor.call 'leaveRooms', (error, result) ->
      if error?
        console.error 'An error occured while leaving all rooms', error

  waitOn: ->
    [
      Meteor.subscribe 'players'
      Meteor.subscribe 'rooms'
    ]

