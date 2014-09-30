Template.viewerVisualization2d.rendered = ->
  @_visualiser = new Visualizer2d @find '.viewer-visualization'
  @_visualiser.enable()
  @_inputListener = new PubsubInputListener Singletons.getPubsub(), @_visualiser
  @_inputListener.enable()


Template.viewerVisualization2d.destroyed = ->
  @_inputListener?.disable()
  @_visualiser?.disable()

