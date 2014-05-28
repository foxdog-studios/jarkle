Template.keyboardForeground.rendered = ->
  target = @find '.keyboard-foreground'

  keyPositions = new KeyPositions target, @data.pitches, @data.pitchAxis
  keyDownDrawer = new KeyDownDrawer target, keyPositions

  @_keyListener = new PubsubKeyListener Singletons.getPubsub(), keyDownDrawer
  @_keyListener.enable()

  resize = ->
    CanvasUtils.resize target
    keyPositions.calcPositions()
  @_resizeListener = new DomEventListener window, resize: resize
  @_resizeListener.enable()
  resize()


Template.keyboardForeground.destroyed = ->
  @_resizeListener?.disable()
  @_keyListener?.disable()

