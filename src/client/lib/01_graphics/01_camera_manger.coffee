class @CameraManager
  constructor: (width, height) ->
    @_initSettings()
    @_initCamera width, height

  _initSettings: ->
    @_far = Settings.viewer.threeD.drawDistance
    @_fov = 75
    @_near = 1
    @_z = @_far / 2

  _initCamera: (width, hieght) ->
    aspect = width / hieght
    @_camera = new THREE.PerspectiveCamera @_fov, aspect, @_near, @_far
    @_camera.position.z = @_z

  getCamera: ->
    @_camera

  resize: (width, height) ->
    @_camera.aspect = width / height
    @_camera.updateProjectionMatrix()

