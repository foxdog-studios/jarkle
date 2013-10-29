NUM_PARTICLES = 20000
PARTICLES_DIAMETER = 2000
PARTICLES_RADIUS = PARTICLES_DIAMETER / 2
DRAW_DISTANCE = 1000
X_DRAW_INCREMENTS = DRAW_DISTANCE / 100
CUBE_DECREMENTS = DRAW_DISTANCE / 1000
CUBE_DISTANCE_LIMIT = 100
NUM_CUBES = 50
NUM_SPRITES = 20
DINO_HEAD_OBJ = 'dino-head.obj'
DINO_HEAD_MTL = 'dino-head.mtl'
NUM_DINO_HEADS = 5

class @WebGLVisualisation
  constructor: (@el, @width, @height) ->

    @touchMap = {}

    @scene = new THREE.Scene()

    @_initCubes()
    @_initSprites(['face.png', 'advocaat.png', 'grapes.png'], NUM_SPRITES)
    @_initParticles()
    @_initObj()

    ambientLight = new THREE.AmbientLight(0x888888)
    @scene.add ambientLight

    directionalLight = new THREE.DirectionalLight( 0xffeedd )
    directionalLight.position.set( 0, 0, 1 ).normalize()
    @scene.add( directionalLight )

    @camera = new THREE.PerspectiveCamera(75, @width / @height, 0.1,
      DRAW_DISTANCE)

    @controls = new THREE.TrackballControls @camera

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


  _initSprites: (spriteUrls, numberOfSprites) ->
    @sprites = []
    @spriteIndex = 0
    for i in [0...numberOfSprites]
      spriteUrl = spriteUrls[i % spriteUrls.length]
      map = THREE.ImageUtils.loadTexture spriteUrl
      material = new THREE.SpriteMaterial
        map: map
        useScreenCoordinates: false
        color: 0xffffff
        fog: true
      sprite = new THREE.Sprite material
      @sprites.push sprite


  _initObj: ->
    @dinoHeads = []
    @dinoIndex = 0
    manager = new THREE.LoadingManager()
    manager.onProgress = (item, loaded, total) ->
      console.log item, loaded, total
    loader = new THREE.OBJMTLLoader(manager)
    loader.load DINO_HEAD_OBJ, DINO_HEAD_MTL, (object) =>
      object.position.z = -10
      object.scale.multiplyScalar(0.15)
      for i in [0...NUM_DINO_HEADS]
        dino = object.clone()
        dino.traverse (obj) ->
          obj.visible = false
        @dinoHeads.push dino
        @scene.add dino


  updateCube: (message) =>

    screenScale = 10
    cartesianX = (message.x - 0.5) * screenScale
    cartesianY = ((-message.y) + 0.5) * screenScale

    cube = @_cycleCube(cartesianX, cartesianY)

    switch message.type
      when 'touchstart', 'touchmove'
        @touchMap[message.identifier] =
          on: true
          x: cartesianX
          y: cartesianY
          cube: cube
      when 'touchend'
        @touchMap[message.identifier].on = false


  _cycleCube: (x, y) ->
    cube = @cubes[@cubeIndex]
    @cubeIndex = (@cubeIndex + 1) % @cubes.length
    cube.active = true
    cube.position.x = x
    cube.position.y = y
    cube.position.z = 0
    cube.visible = true
    cube


  updateSprite: (message) =>
    r = Math.floor(Math.random() * 255)
    g = Math.floor(Math.random() * 255)
    b = Math.floor(Math.random() * 255)
    sprite = @sprites[@spriteIndex]
    message = (message  / 127) * 10
    sprite.scale.set(message, message, message)
    sprite.material.color = new THREE.Color("rgb(#{r},#{g},#{b})")
    @spriteIndex = (@spriteIndex + 1) % @sprites.length
    addSpriteToScene = not sprite.active
    sprite.active = true
    sprite.position.x = Math.random() * 20 - 10
    sprite.position.y = Math.random() * 20 - 10
    sprite.position.z = 0
    if addSpriteToScene
      @scene.add sprite

  render: =>
    requestAnimationFrame @render
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

    dinoIndex = 0
    for id, touchData of @touchMap
      dinoHead = @dinoHeads[dinoIndex]
      if touchData.on
        cube = @_cycleCube(touchData.x, touchData.y)
        dinoHead.position.copy(cube.position)
        dinoHead.traverse (obj) ->
          obj.visible = true
      else
        dinoHead.position.z -= CUBE_DECREMENTS
        if dinoHead.position.z < -CUBE_DISTANCE_LIMIT
          dinoHead.traverse (obj) ->
            obj.visible = false
      dinoIndex += 1

    for sprite, spriteIndex in @sprites
      if not sprite.active
        continue
      sprite.position.z -= CUBE_DECREMENTS
      if sprite.position.z < -CUBE_DISTANCE_LIMIT
        @scene.remove sprite
        sprite.active = false

