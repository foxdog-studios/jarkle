class @WebGlVisualization
  constructor: (@_parent, settings) ->
    @_animating = false

    @_initSettings settings
    @_initExternalDimensions()
    @_initResizeListener()

    @_initRenderer()
    @_initCamera()
    @_initControls()
    @_initScene()
    @_initLights()
    @_initHeads()
    @_initCubes()
    @_initParticles()

    @_resize()
    @_render()


  # ==========================================================================
  # = Initialisation                                                         =
  # ==========================================================================

  _initSettings: (settings) ->
    settings = settings ? {}
    cubes = settings.cubes ? {}
    heads = settings.heads ? {}

    # Global settings
    @_cameraZ = settings.cameraZ ? 5
    @_drawDistance = settings.drawDistance ? 1000

    # Heads
    @_headAppearances = heads.appearances ? {}
    @_headClones = heads.clones ? 10
    @_headScale = heads.scale ? 0.5
    @_headZ = heads.z ? -10


  _initExternalDimensions: ->
    @_width = window.innerWidth
    @_height = window.innerHeight

  _initResizeListener: ->
    @_resizeListener = new DomEventListener window,
      resize: @_onResize


  # ==========================================================================

  _initRenderer: ->
    @_renderer = new THREE.WebGLRenderer alpha: true
    @_parent.appendChild @_renderer.domElement

  _initCamera: ->
    fov = 75
    aspect = @_width / @_height
    near = 1
    far = @_drawDistance
    @_camera = new THREE.PerspectiveCamera fov, aspect, near, far
    @_camera.position.z = @_drawDistance / 2


  _initControls: ->
    @_controls = new THREE.TrackballControls @_camera, @_renderer.domElement
    @_controls.enabled = false


  # ==========================================================================

  _initScene: ->
    @_scene = new THREE.Scene

  _initLights: ->
    @_scene.add new THREE.AmbientLight 0x888888
    @_scene.add new THREE.HemisphereLight 0xffeedd, 0xffeedd

  _initCubes: ->
    @_cubes = new Cubes
    @_cubes.addToScene @_scene

  _initHeads: ->
    THREE.DefaultLoadingManager.onLoad = =>
      @_heads.addToScene @_scene
    @_heads = new Head3DManager

  _initParticles: ->
    @_particleSystem = new StarField
      fieldSize: @_drawDistance
    @_particleSystem.addToScene @_scene


  # ==========================================================================
  # = Rendering                                                              =
  # ==========================================================================

  _onAnimate: =>
    return unless @_animating
    requestAnimationFrame @_onAnimate
    @_animate()

  _animate: ->
    @_animateControls()
    @_animateParticles()
    @_animateCubes()
    @_animateHeads()
    @_render()

  _animateControls: ->
    @_controls.update()

  _animateParticles: ->
    @_particleSystem.animate()

  _animateCubes: ->
    @_cubes.animate()

  _animateHeads: ->
    @_heads.animate()

  _render: ->
    @_renderer.render @_scene, @_camera

  onInputStart: (input) =>
    @_cubes.onInputStart input
    @_heads.onInputStart input

  onInputMove: (input) =>
    @_cubes.onInputMove input
    @_heads.onInputMove input

  onInputStop: (input) =>
    @_cubes.onInputStop input
    @_heads.onInputStop input


  # ==========================================================================
  # = Resize                                                                 =
  # ==========================================================================

  _onResize: (event) =>
    @_initExternalDimensions()
    @_resize()

  _resize: ->
    @_resizeRenderer()
    @_resizeCamera()

  _resizeRenderer: ->
    @_renderer.setSize @_width, @_height

  _resizeCamera: ->
    @_camera.aspect = @_width / @_height
    @_camera.updateProjectionMatrix()


  # ==========================================================================
  # = Controls                                                               =
  # ==========================================================================

  enable: ->
    @_enableResizeListener()
    @_animating = true
    @_onAnimate()

  enableControls: ->
    @_controls.enabled = true

  _enableResizeListener: ->
    @_resizeListener.enable()

  disable: ->
    @disableControls()
    @_disableResizeListener()
    @_animating = false

  disableControls: ->
    @_controls.enabled = false

  _disableResizeListener: ->
    @_resizeListener.disable()

