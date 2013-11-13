P_KEY_KEYCODE = 80

class @KeyboardController
  @KEY_UP = 'keyup'
  constructor: (@el, @pubSub) ->
    @el.addEventListener 'keyup', @handleKeyUp, false

  handleKeyUp:(keyboardEvent) =>
    if keyboardEvent.keyCode == P_KEY_KEYCODE
      @pubSub.trigger KeyboardController.KEY_UP, 'P'

