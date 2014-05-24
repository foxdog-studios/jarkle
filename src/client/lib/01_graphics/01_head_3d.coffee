class @Head3D
  constructor: (@_head) ->
    @_initSettings()
    @_initHead()

  _initSettings: ->
    limit = Settings.viewer.threeD.drawDistance / 2
    @_far = -limit
    @_near  = 0.99 * limit

    settings = Settings.viewer.threeD.heads
    @_speed = settings.speed
    @_headScale = settings.headScale
    @_movementScale = settings.movementScale

  _initHead: ->
    @_isInputStarted = false
    @_head.scale.multiplyScalar @_headScale
    @_hide()

  addToScene: (scene) ->
    scene.add @_head

  animate: ->
    if @_isVisible and not @_isInputStarted
      if (@_head.position.z += @_speed) < @_far
        @_hide()

  _show: ->
    @_setVisible true

  _hide: ->
    @_setVisible false

  _setVisible: (visible) ->
    @_isVisible = visible
    @_head.traverse (object) ->
      object.visible = visible

  onInputStart: (input) ->
    @_isInputStarted = true
    @_updatePositionFromInput input
    @_show()

  onInputMove: (input) ->
    @_updatePositionFromInput input

  onInputStop: (input) ->
    @_isInputStarted = false
    @_updatePositionFromInput input

  _updatePositionFromInput: (input) ->
    @_setPositionAxisFromInput input, 'x'
    @_setPositionAxisFromInput input, 'y'
    @_head.position.z = @_near

  _setPositionAxisFromInput: (input, axis) ->
    @_head.position[axis] = @_movementScale * (input[axis] - 0.5)

