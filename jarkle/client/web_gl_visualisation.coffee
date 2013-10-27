NUM_PARTICLES = 20000
PARTICLES_DIAMETER = 2000
PARTICLES_RADIUS = PARTICLES_DIAMETER / 2
DRAW_DISTANCE = 1000
X_DRAW_INCREMENTS = DRAW_DISTANCE / 1000

class @WebGLVisualisation
  constructor: (@el, @width, @height) ->
    @scene = new THREE.Scene()
    @camera = new THREE.PerspectiveCamera(75, @width / @height, 0.1,
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

    @particlesA = new THREE.ParticleSystem(geometry, material)
    @particlesB = new THREE.ParticleSystem(geometry, material)
    @particlesB.position.z = DRAW_DISTANCE
    @scene.add @particlesA
    @scene.add @particlesB

    @camera.position.z = 5

    @render()

  render: =>
    requestAnimationFrame @render
    @particlesA.position.z -= X_DRAW_INCREMENTS
    @particlesB.position.z -= X_DRAW_INCREMENTS
    if @particlesA.position.z < -PARTICLES_DIAMETER
      console.log 'swap A'
      @particlesA.position.z = DRAW_DISTANCE
    if @particlesB.position.z < -PARTICLES_DIAMETER
      console.log 'swapB'
      @particlesB.position.z = DRAW_DISTANCE
    @renderer.render @scene, @camera

