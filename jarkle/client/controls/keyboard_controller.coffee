KEY_KEYCODE_P = 80

KEY_KEYCODE_1 = 49
KEY_KEYCODE_2 = 50
KEY_KEYCODE_3 = 51
KEY_KEYCODE_4 = 52
KEY_KEYCODE_5 = 53

class @KeyboardController
  @KEY_UP = 'keyup'
  constructor: (@el, @pubSub) ->
    @el.addEventListener 'keyup', @handleKeyUp, false

  handleKeyUp: (keyboardEvent) =>
    key = switch keyboardEvent.keyCode
      when KEY_KEYCODE_P then 'P'
      when KEY_KEYCODE_1 then 1
      when KEY_KEYCODE_2 then 2
      when KEY_KEYCODE_3 then 3
      when KEY_KEYCODE_4 then 4
      when KEY_KEYCODE_5 then 5
    return unless key?
    @pubSub.trigger KeyboardController.KEY_UP, key

