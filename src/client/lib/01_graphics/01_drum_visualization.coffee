class @DrumVisualization
  constructor: (loader) ->
    settings = Settings.viewer.threeD.drums
    objUrl = settings.obj
    mtlUrl = settings.mtl
    count = settings.count
    @_heads = new Head3DAppearance loader, objUrl, mtlUrl, count: count

  addToScene: (scene) ->
    @_heads.addToScene scene

  animate: ->
    @_heads.animate()

  onDrumHit: (drumName) ->
    @_heads.onDrumHit drumName

