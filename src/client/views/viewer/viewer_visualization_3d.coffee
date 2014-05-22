Template.viewerVisualization3d.rendered = ->
  target = @find '.viewer-visualization'

  @_visualization = new WebGlVisualization target, Settings.viewer
  @_visualization.enable()

  pubsub = Singletons.getPubsub()
  @_inputListener = new PubsubInputListener pubsub, @_visualization
  @_inputListener.enable()

  # Toggle between mouse and trackball controls
  onCtrl = (event, enable) =>
    if event.which == KeyCodes.CTRL
      if enable
        @_visualization.enableControls()
      else
        @_visualization.disableControls()

  $(window)
    .keydown (event) -> onCtrl event, true
    .keyup   (event) -> onCtrl event, false


Template.viewerVisualization3d.destroyed = ->
  @_inputListener.disable()
  @_visualization?.disable()
  $(window).off 'keydown keyup'

