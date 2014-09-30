class @Cube
  constructor: (@_geometry, @_material) ->
    @_initSetting()
    @_initMesh()

  _initSetting: ->
    limit = Settings.viewer.threeD.drawDistance / 2
    @_far = -limit
    @_near = 0.99 * limit

    settings = Settings.viewer.threeD.cubes
    @_scale = settings.scale
    @_speed = settings.speed

  _initMesh: ->
    @_mesh = new THREE.Mesh @_geometry, @_material
    @_mesh.visible = false

  addToScene: (scene) ->
    scene.add @_mesh

  animate: ->
    if @_mesh.visible
      if (@_mesh.position.z += @_speed) < @_far
        @_mesh.visible = false

  onInputStart: (input) ->
    @_mesh.position.set(
      @_scale * (input.x - 0.5),
      @_scale * (input.y - 0.5),
      @_near
    )
    @_mesh.visible = true

