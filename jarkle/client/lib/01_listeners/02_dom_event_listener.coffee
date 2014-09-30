class @DomEventListener extends AbstractListener
  constructor: (@_target, listeners) ->
    super listeners

  on: (type, listener) ->
    @_target.addEventListener type, listener, false

  off: (type, listener) ->
    @_target.removeEventListener type, listener, false

