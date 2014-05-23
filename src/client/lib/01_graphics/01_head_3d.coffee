class @Head3D
  constructor: (@_object) ->
    @_isInputStarted = false
    @_isVisible = false
    @_limit = 1500
    @_scale = 5
    @_speed = -10
    @_startZ =  Settings.viewer.drawDistance / 2 - 30

    @_hide()

  _hide: ->
    @_setVisible false

  _resetZ: ->
    @_object.position.z = @_startZ

  _setPositionAxisFromInput: (input, axis) ->
    @_object.position[axis] = @_scale * (input[axis] - 0.5)

  _setVisible: (visible) ->
    @_isVisible = visible
    @_object.traverse (object) ->
      object.visible = visible

  _show: ->
    @_setVisible true

  _updatePositionFromInput: (input) ->
    @_setPositionAxisFromInput input, 'x'
    @_setPositionAxisFromInput input, 'y'
    @_resetZ()

  addToScene: (scene) ->
    scene.add @_object

  animate: ->
    if @_isVisible and not @_isInputStarted
      if Math.abs(@_object.position.x += @_speed) > @_limit
        @_hide()

  onInputStart: (input) ->
    @_isInputStarted = true
    @_updatePositionFromInput input
    @_setVisible true

  onInputMove: (input) ->
    @_updatePositionFromInput input

  onInputStop: (input) ->
    @_isInputStarted = false
    @_updatePositionFromInput input

