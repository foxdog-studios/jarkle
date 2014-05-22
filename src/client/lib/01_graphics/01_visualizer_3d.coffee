class @WebGlVisualization
  constructor: (@_parent, settings) ->
    @_animating = false

    @_initSettings settings
    @_initExternalDimensions()
    @_initResizeListener()
    @_initInputListener()

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

    # Cube settings
    @_cubeColor = parseInt (cubes.color ? '0x00ff00'), 16
    @_cubeCount = cubes.count ? 50
    @_cubeLimit = cubes.limit ? @_drawDistance / 1000
    @_cubeScale = cubes.scale ? 5
    @_cubeSpeed = cubes.speed ? -10

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
    @_cubeIndex = 0

    geometry = new THREE.CubeGeometry 1, 1, 1
    material = new THREE.MeshBasicMaterial color: @_cubeColor

    @_cubes = for i in [0...@_cubeCount]
      cube = new THREE.Mesh geometry, material
      cube.visible = false
      @_scene.add cube
      cube

  _initHeads: ->
    @_heads = {}
    @_masterHeadsCycle = @_makeHeadCycle true
    @_userHeadsCycle = @_makeHeadCycle false

    manager = new THREE.LoadingManager()
    loader = new THREE.OBJMTLLoader manager
    for name, settings of @_headAppearances
      @_initHead loader, name, settings

  _makeHeadCycle: (isMaster) ->
    names = (n for n, s of @_headAppearances when s.master == isMaster)
    cycle _.shuffle names

  _initHead: (loader, name, settings) ->
    loader.load settings.obj, settings.mtl, (head) =>
      head.scale.multiplyScalar @_headScale
      head.position.z = @_headZ
      head.traverse (object) ->
        object.visible = false
      @_heads[name] = for i in [0...@_headClones]
        clone = head.clone()
        @_scene.add clone
        clone

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
    @_animateCubes()
    @_animateHeads()
    @_animateParticles()
    @_render()

  _animateControls: ->
    @_controls.update()

  _animateCubes: ->
    # Move the currently active cubes away from the camera.
    for cube in @_cubes when cube.visible
      cube.position.z += @_cubeSpeed
      if cube.position.z < -@_drawDistance
        cube.visible = false

    # Active another cube for each input
    for inputId, input of @_inputs
      cube = @_cubes[@_cubeIndex]
      @_cubeIndex = (@_cubeIndex + 1) % @_cubes.length
      cube.position.x = @_cubeScale * (input.x - 0.5)
      cube.position.y = @_cubeScale * (input.y - 0.5)
      cube.position.z = 0
      cube.visible = true

    undefined

  _animateHeads: ->

  _animateParticles: ->
    @_particleSystem.animate()

  _render: ->
    @_renderer.render @_scene, @_camera


  # ==========================================================================
  # = Events                                                                 =
  # ==========================================================================

  _initInputListener: ->
    @_inputs = {}
    @_inputHeads = {}
    @_users = {}


  # ==========================================================================

  _startHead: (input) ->
    head = @_heads[@_users[input.userId]].pop()
    if head?
      @_inputHeads[input.inputId] = head
      head.traverse (object) ->
        object.visible = true
      @_updateHead head, input

  _moveHead: (input) ->
    if (head = @_inputHeads[input.inputId])?
      @_updateHead head, input

  _updateHead:(head, input) ->
    head.position.x = @_cubeScale * (input.x - 0.5)
    head.position.y = @_cubeScale * (input.y - 0.5)
    head.position.z = @_headZ

  _stopHead: (input) ->
    if (head = @_inputHeads[input.inputId])?
      head.traverse (object) -> object.visible = false
      delete @_inputHeads[input.inputId]
      @_heads[@_users[input.userId]].push head


  # ==========================================================================

  onInputStart: (input) =>
    @_inputs[input.inputId] = input
    @_ensureUser input
    @_startHead input

  onInputMove: (input) =>
    @_inputs[input.inputId] = input
    @_moveHead input

  onInputStop: (input) =>
    delete @_inputs[input.inputId]
    @_stopHead input

  # ==========================================================================

  _ensureUser: (input) ->
    return if @_users[input.userId]?
    cycle = if input.isMaster
      @_masterHeadsCycle
    else
      @_userHeadsCycle
    @_users[input.userId] = cycle()


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

