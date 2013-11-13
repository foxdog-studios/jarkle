NUM_PARTICLES = 20000
PARTICLES_DIAMETER = 2000
PARTICLES_RADIUS = PARTICLES_DIAMETER / 2
DRAW_DISTANCE = 1000
X_DRAW_INCREMENTS = DRAW_DISTANCE / 100
CUBE_DECREMENTS = DRAW_DISTANCE / 1000
CUBE_DISTANCE_LIMIT = 100
NUM_CUBES = 50
TRAIL_HEAD_OBJ = 'pug.obj'
TRAIL_HEAD_MTL = 'pug.mtl'
NUM_TRAIL_HEADS = 5
@FOX_HEAD_OBJ = 'fox.obj'
@FOX_HEAD_MTL = 'fox.mtl'
NUM_FOX_HEADS = 20
@OBJ_SCALE_MULTIPLER = 0.15
FOX_HEAD_START_X = 15
FOX_HEAD_START_Y = 10
FOX_START_Z = -2

BASS_DRUM_1 = 33
BASS_DRUM_2 = 36
SNARE_DRUM_1 = 31
HI_HAT_CLOSED = 42
LOW_TOM_1 = 43
HI_HAT_PEDAL = 44
HI_HAT_OPEN = 46
MID_TOM_1 = 47
CRASH_CYMBAL_1 = 49
HIGH_TOM_1 = 48
@RIDE_CYMBAL_1 = 51

POSTION_SCALE = 5
POSITIONS = {}
POSITIONS[BASS_DRUM_1] =
  x: 0
  y: -1
POSITIONS[BASS_DRUM_2] =
  x: 1
  y: 1
POSITIONS[SNARE_DRUM_1] =
  x: -1
  y: 0
POSITIONS[HI_HAT_CLOSED] =
  x: -1
  y: 1
POSITIONS[LOW_TOM_1] =
  x: 1
  y: -1
POSITIONS[HI_HAT_PEDAL] =
  x: 0.25
  y: 0.25
POSITIONS[HI_HAT_OPEN] =
  x: -1
  y: -1
POSITIONS[MID_TOM_1] =
  x: 1
  y: 0.5
POSITIONS[CRASH_CYMBAL_1] =
  x: -1
  y: 1
POSITIONS[HIGH_TOM_1] =
  x: 0
  y: 0.25
POSITIONS[RIDE_CYMBAL_1] =
  x: 0.5
  y: 1


class @WebGLVisualisation
  constructor: (@el, @width, @height, @schema) ->

    @touchMap = {}

    @paused = false

    @currentHeadIndex = 0

    @scene = new THREE.Scene()

    @_initCubes()
    @_initParticles()
    @_initObj()

    @skeleton = new Skeleton @scene

    ambientLight = new THREE.AmbientLight(0x888888)
    @scene.add ambientLight

    directionalLight = new THREE.DirectionalLight( 0xffeedd )
    directionalLight.position.set( 0, 0, 1 ).normalize()
    @scene.add( directionalLight )

    @camera = new THREE.PerspectiveCamera(75, @width / @height, 0.1,
      DRAW_DISTANCE)

    @controls = new CtrlTrackBallControls @camera

    @renderer = new THREE.WebGLRenderer()
    @renderer.setSize @width, @height
    @el.appendChild @renderer.domElement
    @camera.position.z = 5

    window.addEventListener 'resize', @_resizeToWindow, false

    @render()

  _resizeToWindow: =>
    @width = window.innerWidth
    @height = window.innerHeight
    @renderer.setSize @width, @height
    @camera.aspect = @width / @height
    @camera.updateProjectionMatrix()

  _initCubes: ->
    @cubes = []
    @cubeIndex = 0

    for i in [0...NUM_CUBES]
      cubeGeometry = new THREE.CubeGeometry(1, 1, 1)
      cubeMaterial = new THREE.MeshBasicMaterial(color: 0x00FF00)
      cube = new THREE.Mesh(cubeGeometry, cubeMaterial)
      cube.visible = false
      @cubes.push cube
      @scene.add cube


  _initParticles: ->
    geometry = new THREE.Geometry()

    for i in [0...NUM_PARTICLES]
      vertex = new THREE.Vector3
      vertex.x = Math.random() * PARTICLES_DIAMETER - PARTICLES_RADIUS
      vertex.y = Math.random() * PARTICLES_DIAMETER - PARTICLES_RADIUS
      vertex.z = Math.random() * PARTICLES_DIAMETER - PARTICLES_RADIUS
      geometry.vertices.push vertex

    particalMap = THREE.ImageUtils.loadTexture 'particle.png'

    @particalMaterial = new THREE.ParticleSystemMaterial
      blending: THREE.AdditiveBlending
      size: 5
      color: 0xAAAAFF
      map: particalMap
      transparent: true

    @particalMaterial.color = new THREE.Color(0x7777FF)

    particlesA = new THREE.ParticleSystem(geometry, @particalMaterial)
    particlesB = new THREE.ParticleSystem(geometry, @particalMaterial)
    particlesB.position.z = DRAW_DISTANCE
    @particleGroups = [particlesA, particlesB]
    for particleGroup in @particleGroups
      @scene.add particleGroup


  _initObj: ->
    @trailHeads = {}
    @headIndex = 0
    manager = new THREE.LoadingManager()
    manager.onProgress = (item, loaded, total) ->
      console.log item, loaded, total
    loader = new THREE.OBJMTLLoader(manager)


    for playerId, playerInfo of @schema
      obj = playerInfo.vis.obj
      mtl = playerInfo.vis.mtl
      do (playerId) =>
        loader.load obj, mtl, (object) =>
          heads = []
          object.position.z = -10
          object.scale.multiplyScalar OBJ_SCALE_MULTIPLER
          for i in [0...NUM_TRAIL_HEADS]
            head = object.clone()
            head.traverse (obj) ->
              obj.visible = false
            heads.push head
            @scene.add head
          @trailHeads[playerId] = heads

    @foxHeads = []
    @foxHeadIndex = 0

    loader.load FOX_HEAD_OBJ, FOX_HEAD_MTL, (object) =>
      object.scale.multiplyScalar OBJ_SCALE_MULTIPLER
      for i in [0...NUM_FOX_HEADS]
        head = object.clone()
        head.traverse (obj) ->
          obj.visible = false
        @foxHeads.push head
        @scene.add head



  updateCube: (message, playerId) =>

    screenScale = 10
    cartesianX = (message.x - 0.5) * screenScale
    cartesianY = ((-message.y) + 0.5) * screenScale

    cube = @_cycleCube(cartesianX, cartesianY)

    userId = message.userId
    unless @touchMap[userId]?
      heads = @trailHeads[playerId]
      unless heads?
        # Heads may have not loaded yet.
        return
      @touchMap[userId] =
        heads: heads
    switch message.type
      when NoteMessenger.NOTE_START, NoteMessenger.NOTE_CONTINUE
        @touchMap[userId][message.identifier] =
          on: true
          x: cartesianX
          y: cartesianY
          cube: cube
      when NoteMessenger.NOTE_END
        unless @touchMap[userId][message.identifier]?
          break
        @touchMap[userId][message.identifier].on = false

  stopAll: ->
    for userId, touches of @touchMap
      for id, touch of touches
        touch.on = false

  _cycleCube: (x, y) ->
    cube = @cubes[@cubeIndex]
    @cubeIndex = (@cubeIndex + 1) % @cubes.length
    cube.active = true
    cube.position.x = x
    cube.position.y = y
    cube.position.z = 0
    cube.visible = true
    cube

  updateFoxHeads: (noteInfo) =>
    foxHead = @foxHeads[@foxHeadIndex]
    unless foxHead?
      return
    @foxHeadIndex = (@foxHeadIndex + 1) % @foxHeads.length
    position = POSITIONS[noteInfo.note]
    unless position?
      return
    foxHead.position.x = position.x * POSTION_SCALE
    foxHead.position.y = position.y * POSTION_SCALE
    foxHead.position.z = FOX_START_Z
    foxHead.active = true
    foxHead.traverse (object) ->
      object.visible = true


  onPairsTouching: (partA, partB, isTouching) =>
    @skeleton.pointsTouching partA, partB, isTouching

  updateSkeleton: (skeletons) =>
    if skeletons.length > 0
      @skeleton.update skeletons[0].skeleton
    else
      @skeleton.hide()

  render: =>
    requestAnimationFrame @render
    if @paused
      return
    @controls.update()
    @renderer.render @scene, @camera
    for particleGroup in @particleGroups
      particleGroup.position.z -= X_DRAW_INCREMENTS
      if particleGroup.position.z < -PARTICLES_DIAMETER
        particleGroup.position.z = DRAW_DISTANCE
    maxCubeZ = -Infinity
    maxCubePosition = null
    for cube in @cubes
      if not cube.active
        continue
      if cube.position.z > maxCubeZ
        maxCubeZ = cube.position.z
        maxCubePosition = cube.position.clone()
      cube.position.z -= CUBE_DECREMENTS
      if cube.position.z < -CUBE_DISTANCE_LIMIT
        cube.visible = false
        cube.active = false

    update = new Date().getTime()
    for userId, touches of @touchMap
      headIndex = 0
      for id, touchData of touches
        # The heads data may have yet to load.
        unless touches.heads?
          continue
        trailHead = touches.heads[headIndex]
        # Trail heads may have not loaded.
        unless trailHead?
          continue
        if touchData.on
          cube = @_cycleCube(touchData.x, touchData.y)
          trailHead.position.copy(cube.position)
          trailHead.traverse (obj) ->
            obj.visible = true
        else if trailHead.updatedOn != update
          trailHead.position.z -= CUBE_DECREMENTS
          if trailHead.position.z < -CUBE_DISTANCE_LIMIT
            trailHead.traverse (obj) ->
              obj.visible = false
        trailHead.updatedOn = update
        headIndex = (headIndex + 1) % touches.heads.length

    for foxHead, foxHeadIndex in @foxHeads
      if not foxHead.active
        continue
      foxHead.position.z -= CUBE_DECREMENTS
      if foxHead.position.z < -CUBE_DISTANCE_LIMIT
        foxHead.traverse (object) ->
          object.visible = false
        foxHead.active = false

