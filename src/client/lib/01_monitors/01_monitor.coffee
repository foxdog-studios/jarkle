class @Monitor
  constructor: (@_trigger) ->
    @_isStarted = false

  _setDataPrevious: (data) ->
    delete @_previous.previous
    data.previous = @_previous

  start: (data) ->
    if @_isStarted
      @triggerStop data
    @triggerStart data

  move: (data) ->
    if @_isStarted
      @triggerMove data
    else
      @triggerStart data

  stop: (data) ->
    if @_isStarted
      @triggerStop data

  forceStop: ->
    if @_isStarted and @_previous?
      @_triggerStop @_previous

  triggerStart: (data) ->
    @_isStarted = true
    @_previous = data
    @_trigger.start data

  triggerMove: (data) ->
    @_setDataPrevious data
    @_previous = data
    @_trigger.move data

  triggerStop: (data) ->
    @_setDataPrevious data
    @_triggerStop data

  _triggerStop: (data) ->
    @_isStarted = false
    delete @_previous
    @_trigger.stop data

