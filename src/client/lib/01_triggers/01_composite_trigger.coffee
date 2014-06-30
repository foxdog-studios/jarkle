class @CompositeInputTrigger
  constructor: (@_triggers) ->

  _each: (name, data) ->
    for trigger in @_triggers
      trigger[name] data

  start: (data) ->
    @_each 'start', data

  move: (data) ->
    @_each 'move', data

  stop: (data) ->
    @_each 'stop', data

