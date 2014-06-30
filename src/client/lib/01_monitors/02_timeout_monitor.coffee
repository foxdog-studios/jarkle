class @TimeoutMonitor extends Monitor
  constructor: (trigger, @_timeout = 1000) ->
    super trigger

  _setTimeout: (data) ->
    @_timeoutId = Meteor.setTimeout @_onTimeout, @_timeout

  _onTimeout: =>
    @forceStop()

  _clearTimeout: ->
    Meteor.clearTimeout @_timeoutId if @_timeoutId?
    delete @_timeoutId

  _resetTimeout: (input) ->
    @_clearTimeout()
    @_setTimeout input

  triggerStart: (data) ->
    @_setTimeout()
    super data

  triggerMove: (data) ->
    @_resetTimeout()
    super data

  triggerStop: (data) ->
    @_clearTimeout()
    super data

