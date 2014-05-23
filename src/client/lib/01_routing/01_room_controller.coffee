class @RoomController extends RouteController
  isMaster: false

  _hasPlayer: ->
    @params? and Players.find(roomId: @params.roomId).count() == 1

  data: ->
    pitchAxis: PitchAxis.parse Settings.pitchAxis
    pitches: Pitches.parse Settings.pitches
    roomId: @params.roomId

  waitOn: ->
    [
      Meteor.subscribe 'room', @params.roomId
      Meteor.subscribe 'player'
      ready: => @_hasPlayer()
    ]

  onBeforeAction: ->
    unless @_isJoining or @_hasPlayer()
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

