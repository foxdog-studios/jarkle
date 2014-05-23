class @RoomController extends RouteController
  isMaster: false

  data: ->
    pitchAxis: PitchAxis.parse Settings.pitchAxis
    pitches: Pitches.parse Settings.pitches
    roomId: @params.roomId

  waitOn: ->
    [
      Meteor.subscribe 'room', @params.roomId
      Meteor.subscribe 'player'
    ]

  onBeforeAction: ->
    unless @_isJoining
      Meteor.call 'joinRoom', @params.roomId, @isMaster, (error, result) =>
        if error?
          message = 'An error occured while attempting to join room.'
          console.error message, error
        @_isJoining = false
      @_isJoining = true

  onStop: ->
    Meteor.call 'leaveRooms', (error, result) ->
      if error?
        message = 'An error occured while attempting to leave rooms.'
        console.error message, error


hasPlayer = (roomId) ->
  Players.find(roomId: roomId).count() == 1

