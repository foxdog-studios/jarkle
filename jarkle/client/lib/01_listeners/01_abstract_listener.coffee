class @AbstractListener
  constructor: (@_listeners) ->
    @_isEnabled = false

  _each: (func) ->
    for type, listener of @_listeners
      func.call this, type, listener

  enable: ->
    return if @_isEnabled
    @_isEnabled = true
    @_each @on

  disable: ->
    return unless @_isEnabled
    @_each @off
    @_isEnabled = false

  on: (type, listener) ->
    throw 'Subclass must implement on, but does not'

  off: (type, listener) ->
    throw 'Subclass must implement off, but does not'

