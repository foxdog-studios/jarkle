class @AbstractTrigger
  constructor: (@_type) ->

  _subtype: (subtype) ->
    "#{ @_type }:#{ subtype }"

  start: (data) ->
    @trigger @_subtype('start'), data

  move: (data) ->
    @trigger @_subtype('move'), data

  stop: (data) ->
    @trigger @_subtype('stop'), data

  trigger: (type, data) ->
    throw new 'Subclass must implement trigger, but does not.'

