Template.keyboardBackground.rendered = ->
  target = @find '.keyboard-background'

  keyPositions = new KeyPositions target, @data.pitches, @data.pitchAxis
  keyboardDrawer = new KeyboardDrawer target, keyPositions

  draw = ->
    CanvasUtils.resize target
    keyPositions.calcPositions()
    keyboardDrawer.draw()

  @_resizeListener = new DomEventListener window,
    resize: draw
  @_resizeListener.enable()

  draw()


Template.keyboardBackground.destroyed = ->
  @_resizeListener?.disable()

