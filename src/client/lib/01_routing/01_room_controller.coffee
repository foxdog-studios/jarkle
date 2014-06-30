class @RoomController extends RouteController
  isMaster: false

  _hasPlayer: ->
    @params? and Players.find(roomId: @data().roomId).count() == 1

  _getRoomId: ->
    #  The URL parameter roomId will only exist when rooms are enabled.
    if Settings.enableRooms
      @params.roomId
    else
      'jarkle'

  data: ->
    pitchAxis: PitchAxis.parse Settings.pitchAxis
    pitches: Pitches.parse Settings.pitches
    roomId: @_getRoomId()

  waitOn: ->
    [
      Meteor.subscribe 'room', @data().roomId
      Meteor.subscribe 'player'
      ready: => @_hasPlayer()
    ]

  onBeforeAction: ->
    unless @_isJoining or @_hasPlayer()
      Meteor.call 'joinRoom', @data().roomId, @isMaster, (error, result) =>
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

