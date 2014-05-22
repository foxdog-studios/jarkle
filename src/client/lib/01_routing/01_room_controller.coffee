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
      ready: =>
        @_joinCalled and not @_isJoining and hasPlayer @params.roomId
    ]

  onBeforeAction: ->
    unless @_isJoining or hasPlayer @params.roomId
      Meteor.call 'joinRoom', @params.roomId, @isMaster, (error, result) =>
        @_isJoining = false
      @_isJoining = true
      @_joinCalled = true


hasPlayer = (roomId) ->
  Players.find(roomId: roomId).count() == 1

