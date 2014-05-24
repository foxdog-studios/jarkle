class @Head3DAppearance
  constructor: (@_loader, @_appearance) ->
    @_initHeads()

  _initHeads: ->
    @_loader.load @_appearance.obj, @_appearance.mtl, (head) =>
      @_heads = new Heads3D head

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

