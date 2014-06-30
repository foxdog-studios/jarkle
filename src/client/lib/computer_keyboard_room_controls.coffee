class @ComputerKeyboardRoomControls
  constructor: (@_roomId) ->
    @_isWaiting = false
    @_listener = new DomEventListener window,
      keydown: @_onKeyDown

  _onKeyDown: (event) =>
    preventDefault = true
    switch event.which
      when KeyCodes.ONE   then @_showMessage()
      when KeyCodes.TWO   then @_hideMessage()
      when KeyCodes.THREE then @_enableSinglePlayer()
      when KeyCodes.FOUR  then @_enableAllPlayers()
      when KeyCodes.FIVE  then @_disableAllPlayers()
      else preventDefault = false
    if preventDefault
      event.preventDefault()

  _showMessage: ->
    @_call 'showMessage'

  _hideMessage: ->
    @_call 'hideMessage'

  _enableSinglePlayer: ->
    @_call 'enableSinglePlayer'

  _enableAllPlayers: ->
    @_call 'enableAllPlayers'

  _disableAllPlayers: ->
    @_call 'disableAllPlayers'

  _call: (name) ->
    return if @_isWaiting
    Meteor.call name, @_roomId, (error, result) =>
      console.error "Call to #{ name } failed.", error if error?
      @_isWaiting = false
    @_isWaiting = true

  enable: ->
    @_listener.enable()

  disable: ->
    @_listener.disable()

