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

class @WebGLVisualisation
  constructor: (@el, @width, @height) ->

    @scene = new THREE.Scene()

    @_initCubes()
    @_initSprites(['face.png', 'advocaat.png', 'grapes.png'], NUM_SPRITES)
    @_initParticles()
    @_initObj()

    ambientLight = new THREE.AmbientLight(0xFFFFFF)
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

    @render()


  _initCubes: ->
    @cubes = []
    @cubeIndex = 0

    for i in [0...NUM_CUBES]
      cubeGeometry = new THREE.CubeGeometry(1, 1, 1)
      cubeMaterial = new THREE.MeshBasicMaterial(color: 0x00FF00)
      cube = new THREE.Mesh(cubeGeometry, cubeMaterial)
      @cubes.push cube


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
    manager = new THREE.LoadingManager()
    manager.onProgress = (item, loaded, total) ->
      console.log item, loaded, total
    loader = new THREE.OBJMTLLoader(manager)
    loader.load DINO_HEAD_OBJ, DINO_HEAD_MTL, (object) =>
      object.position.z = -10
      object.scale.multiplyScalar(0.2)
      @dinoHead = object
      @scene.add object


  updateCube: (message) =>
    cartesianX = message.x - 0.5
    cartesianY = (-message.y) + 0.5
    cube = @cubes[@cubeIndex]
    @cubeIndex = (@cubeIndex + 1) % @cubes.length
    addCubeToScene = not cube.active
    cube.active = true
    cube.position.x = cartesianX * 10
    cube.position.y = cartesianY * 10
    cube.position.z = 0
    if addCubeToScene
      @scene.add cube


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
        @scene.remove cube
        cube.active = false
    if maxCubeZ > -Infinity and @dinoHead?
      @dinoHead.position.copy(maxCubePosition)
    for sprite, spriteIndex in @sprites
      if not sprite.active
        continue
      sprite.position.z -= CUBE_DECREMENTS
      if sprite.position.z < -CUBE_DISTANCE_LIMIT
        @scene.remove sprite
        sprite.active = false

