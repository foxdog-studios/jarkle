class @Cubes
  constructor: ->
    @_inputs = {}

    @_initSettings()
    @_initGeometry()
    @_initMaterial()
    @_initCubes()

  _initSettings: ->
    settings = Settings.viewer.threeD.cubes
    @_color = parseInt settings.color
    @_count = settings.count

  _initGeometry: ->
    @_geometry = new THREE.CubeGeometry 1, 1, 1

  _initMaterial: ->
    @_material = new THREE.MeshBasicMaterial
      color: @_color

  _initCubes: ->
    @_nextIndex = 0
    @_cubes = for i in [0...@_count]
      new Cube @_geometry, @_material

  addToScene: (scene) ->
    for cube in @_cubes
      cube.addToScene scene

  animate: ->
    @_moveVisible()
    @_showNewCubes()

  _moveVisible: ->
    for cube in @_cubes
      cube.animate()

  _showNewCubes: ->
    for inputId, input of @_inputs
      cube = @_cubes[@_nextIndex]
      @_nextIndex = (@_nextIndex + 1) % @_count
      cube.onInputStart input

  onInputStart: (input) ->
    @_updateInput input

  onInputMove: (input) ->
    @_updateInput input

  onInputStop: (input) ->
    delete @_inputs[input.inputId]

  _updateInput: (input) ->
    @_inputs[input.inputId] = input

