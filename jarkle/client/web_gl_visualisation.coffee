NUM_PARTICLES = 20000
PARTICLES_DIAMETER = 2000
PARTICLES_RADIUS = PARTICLES_DIAMETER / 2
DRAW_DISTANCE = 1000
X_DRAW_INCREMENTS = DRAW_DISTANCE / 100
CUBE_DECREMENTS = DRAW_DISTANCE / 1000
CUBE_DISTANCE_LIMIT = 100
NUM_CUBES = 50

class @WebGLVisualisation
  constructor: (@el, @width, @height, @pubSub, @eventType) ->
    @pubSub.on @eventType, @updateCube

    @cubes = []
    @cubeIndex = 0

    for i in [0...NUM_CUBES]
      cubeGeometry = new THREE.CubeGeometry(1, 1, 1)
      cubeMaterial = new THREE.MeshBasicMaterial(color: 0x00FF00)
      cube = new THREE.Mesh(cubeGeometry, cubeMaterial)
      @cubes.push cube

    @scene = new THREE.Scene()
    @camera = new THREE.PerspectiveCamera(45, @width / @height, 0.1,
      DRAW_DISTANCE)

    @renderer = new THREE.WebGLRenderer()
    @renderer.setSize @width, @height
    @el.appendChild @renderer.domElement

    geometry = new THREE.Geometry()

    for i in [0...NUM_PARTICLES]
      vertex = new THREE.Vector3
      vertex.x = Math.random() * PARTICLES_DIAMETER - PARTICLES_RADIUS
      vertex.y = Math.random() * PARTICLES_DIAMETER - PARTICLES_RADIUS
      vertex.z = Math.random() * PARTICLES_DIAMETER - PARTICLES_RADIUS
      geometry.vertices.push vertex

    material = new THREE.ParticleSystemMaterial()

    particlesA = new THREE.ParticleSystem(geometry, material)
    particlesB = new THREE.ParticleSystem(geometry, material)
    particlesB.position.z = DRAW_DISTANCE
    @particleGroups = [particlesA, particlesB]
    for particleGroup in @particleGroups
      @scene.add particleGroup

    @camera.position.z = 5

    @render()

  updateCube: (message) =>
    cartesianX = message.x - 0.5
    cartesianY = (-message.y) + 0.5
    cube = @cubes[@cubeIndex]
    @cubeIndex = (@cubeIndex + 1) % NUM_CUBES
    addCubeToScene = not cube.active
    cube.active = true
    cube.position.x = cartesianX * 10
    cube.position.y = cartesianY * 10
    cube.position.z = 0
    if addCubeToScene
      @scene.add cube

  render: =>
    requestAnimationFrame @render
    @renderer.render @scene, @camera
    for particleGroup in @particleGroups
      particleGroup.position.z -= X_DRAW_INCREMENTS
      if particleGroup.position.z < -PARTICLES_DIAMETER
        particleGroup.position.z = DRAW_DISTANCE
    for cube, cubeIndex in @cubes
      if not cube.active
        continue
      cube.position.z -= CUBE_DECREMENTS
      if cube.position.z < -CUBE_DISTANCE_LIMIT
        @scene.remove cube
        cube.active = false

