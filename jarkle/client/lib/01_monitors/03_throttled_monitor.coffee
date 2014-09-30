class @ThrottledMonitor extends TimeoutMonitor
  constructor: (trigger, @_minInterval = 200) ->
    super trigger
    @_last = Date.now() - @_minInterval
    @_throttle = true

    # XXX: Hacked in! Add code to enable and disable this.
    Deps.autorun =>
      player = Players.findOne {},
        fields:
          allEnabled: 1
      @_throttle = player.allEnabled ? true

  _canTrigger: ->
    unless @_throttle
      return true
    now = Date.now()
    if now - @_last >= @_minInterval
      @_last = now
      true
    else
      false

  start: (data) ->
    super data if @_canTrigger()

  move: (data) ->
    super data if @_canTrigger()

  stop: (data) ->
    super data if @_canTrigger()

