Template.debugKeyboard.rendered = ->
  stream = Singletons.getStream()
  roomId = @data.roomId

  @_input = new FakeInput stream, roomId, @data.pitches.length
  @_input.enable()


Template.debugKeyboard.destroyed = ->
  @_input?.disable()
  delete @_input


class FakeInput
  IS_MASTER  = false

  STOPPED    = 'stopped'
  MOVING     = 'moving'

  START_PROB = 0.99
  MOVE_PROB  = 0.99
  STOP_PROB  = 0.01

  MAX_MOVE   = 0.1

  INTERVAL   = 10

  constructor: (stream, roomId, numPitches) ->
    @_builder = new InputEventBuilder 'debug', IS_MASTER
    @_trigger = new StreamTrigger stream, roomId, 'input'
    @_maxOrdinate = 1 - 1 / numPitches
    @_state = STOPPED

  _update: =>
    switch @_state
      when STOPPED  then @_updateStateFromStopped()
      when MOVING   then @_updateStateFromMoving()

  _updateStateFromStopped: ->
    if Math.random() < START_PROB
      @_state = MOVING
      @_numMoves = 0
      @_x = Math.random()
      @_y = Math.random()
      @_start()

  _updateStateFromMoving: ->
    @_incXY()
    if Math.random() < STOP_PROB
      @_state = STOPPED
      @_stop()
    else if Math.random() < MOVE_PROB
      @_incXY()
      @_move()

  _incXY: ->
    @_x = @_randomInc @_x
    @_y = @_randomInc @_y

  _randomInc: (start) ->
    inc = (MAX_MOVE * Math.random()) - (MAX_MOVE / 2)
    Math.min @_maxOrdinate, Math.max (start + inc), 0

  _start: ->
    @_call 'start'

  _move: ->
    @_call 'move'

  _stop: ->
    @_call 'stop'

  _call: (funcName) ->
    @_trigger[funcName] @_builder.build @_x, @_y

  enable: ->
    return if @_intervalId?
    @_intervalId = Meteor.setInterval @_update, INTERVAL

  disable: ->
    return unless @_intervalId?
    Meteor.clearInterval @_intervalId
    delete @_intervalId

