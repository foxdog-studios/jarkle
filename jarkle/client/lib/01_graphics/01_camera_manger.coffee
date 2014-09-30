class @CameraManager
  constructor: (width, height, position) ->
    @_initSettings()
    @_initCamera width, height, position

  _initSettings: ->
    @_far = Settings.viewer.threeD.drawDistance
    @_fov = 75
    @_near = 1

  _initCamera: (width, height, position) ->
    aspect = width / height
    @_camera = new THREE.PerspectiveCamera @_fov, aspect, @_near, @_far
    @_camera.position = position

  getCamera: ->
    @_camera

  resize: (width, height) ->
    @_camera.aspect = width / height
    @_camera.updateProjectionMatrix()

