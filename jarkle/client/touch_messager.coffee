@TouchMessager = class TouchMessager
  @MESSAGE_SENT = 'message-sent'

  constructor: (@messageStream, @pubSub) ->
    @pubSub.on TouchController.TOUCH_START, @sendTouchNoteOnMessage
    @pubSub.on TouchController.TOUCH_MOVE, @sendTouchNoteOnMessage
    @pubSub.on TouchController.TOUCH_END, @sendTouchNoteOffMessage

  sendMessage: (message) ->
    @pubSub.trigger TouchMessager.MESSAGE_SENT, message
    @messageStream.emit 'message', message

  sendTouchMessage: (touch, noteOn) ->
    x = touch.pageX / window.innerWidth
    y = touch.pageY / window.innerHeight
    @sendMessage x: x, y: y, noteOn: noteOn, identifier: touch.identifier

  sendTouchNoteOnMessage: (touch) =>
    @sendTouchMessage touch, true

  sendTouchNoteOffMessage: (touch) =>
    @sendTouchMessage touch, false

