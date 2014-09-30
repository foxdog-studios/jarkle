# TODO: Separate input and drum hit animation.

DRUM_POSITIOINS =
  'crash'        : { x: -1   , y:  1    }
  'hi-hat closed': { x: -1   , y:  1    }
  'hi-hat open'  : { x: -1   , y: -1    }
  'hi-hat pedal' : { x:  0.25, y:  0.25 }
  'high tom'     : { x:  0   , y:  0.25 }
  'kick'         : { x:  0   , y: -1    }
  'low tom'      : { x:  1   , y: -1    }
  'mid tom'      : { x:  1   , y:  0.5  }
  'ride'         : { x:  0.5 , y:  1    }
  'snare'        : { x: -1   , y:  0    }


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
    @_updatePosition input, -0.5
    @_show()

  onInputMove: (input) ->
    @_updatePosition input, -0.5

  onInputStop: (input) ->
    @_isInputStarted = false
    @_updatePosition input, -0.5

  onDrumHit: (drumName) ->
    if (position = DRUM_POSITIOINS[drumName])?
      @_isInputStarted = false
      @_updatePosition position, 0
      @_show()

  _updatePosition: (position, offset) ->
    @_updatePositionAxis position, 'x', offset
    @_updatePositionAxis position, 'y', offset
    @_head.position.z = @_near

  _updatePositionAxis: (position, axis, offset) ->
    @_head.position[axis] = @_movementScale * (position[axis] + offset)

