Template.viewerVisualization3d.rendered = ->
  target = @find '.viewer-visualization'

  @_visualization = new Visualizer3D target, Settings.viewer
  @_visualization.enable()

  pubsub = Singletons.getPubsub()
  @_inputListener = new PubsubInputListener pubsub, @_visualization
  @_inputListener.enable()

  if Settings.viewer.threeD.drums.enabled
    @_drumHitListener = new StreamDrumHitListener(
      Singletons.getStream(),
      @data.roomId,
      @_visualization
    )
    @_drumHitListener.enable()

  # Toggle between mouse and trackball controls.
  @_controlsListener = new DomEventListener window,
    keydown:(event) =>
      if event.which == KeyCodes.CTRL
        event.preventDefault()
        @_visualization.enableControls()
        Session.set 'enableInputs', false
    keyup: (event) =>
      if event.which == KeyCodes.CTRL
        event.preventDefault()
        @_visualization.disableControls()
        Session.set 'enableInputs', true
  @_controlsListener.enable()


Template.viewerVisualization3d.destroyed = ->
  @_controlsListener?.disable()
  @_drumHitListener?.disable()
  @_inputListener?.disable()
  @_visualization?.disable()

