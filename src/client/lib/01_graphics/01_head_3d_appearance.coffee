class @Head3DAppearance
  constructor: (loader, objUrl, mtlUrl, options) ->
    loader.load objUrl, mtlUrl, (head) =>
      @_heads = new Heads3D head, options

  addToScene: (scene) ->
    @_heads.addToScene scene

  animate: ->
    @_heads?.animate()

  onInputStart: (input) ->
    @_heads?.onInputStart input

  onInputMove: (input) ->
    @_heads?.onInputMove input

  onInputStop: (input) ->
    @_heads?.onInputStop input

  onDrumHit: (drumName) ->
    @_heads?.onDrumHit drumName

