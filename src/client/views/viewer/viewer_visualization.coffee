Template.viewerVisualization.helpers
  visualization: ->
    if supportsWebGl()
      Template.viewerVisualization3d
    else
      Template.viewerVisualization2d

