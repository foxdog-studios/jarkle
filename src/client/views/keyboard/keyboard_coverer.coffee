class @KeyboardCoverer
  constructor: (pubsub, timeout = 5) ->
    @_listener = new PubsubKeyListener pubsub, this
    @_numKeysDown = 0
    @_timeout = timeout * 1000

  onKeyStart: (frequency) =>
    if @_numKeysDown == 0
      @_uncover()
      @_clearTimeout()
    @_numKeysDown++

  onKeyStop: (frequency) =>
    @_numKeysDown--
    if @_numKeysDown == 0
      @_resetTimeout()

  _setTimeout: ->
    @_timeoutId = Meteor.setTimeout @_cover, @_timeout

  _clearTimeout: ->
    Meteor.clearTimeout @_timeoutId
    delete @_timeoutId

  _resetTimeout: ->
    @_clearTimeout()
    @_setTimeout()

  _cover: =>
    @_setCovered true

  _uncover: ->
    @_setCovered false

  _setCovered: (isCovered) ->
    Session.set 'coverKeyboard', isCovered

  enable: ->
    @_listener.enable()

  disable: ->
    @_listener.disable()
    @_clearTimeout()

