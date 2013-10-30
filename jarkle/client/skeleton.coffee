BODY_PARTS = [
  'head'
  'neck'
  'leftShoulder'
  'rightShoulder'
  'leftElbow'
  'rightElbow'
  'leftHand'
  'rightHand'
  'torso'
  'leftHip'
  'rightHip'
  'leftKnee'
  'rightKnee'
  'leftFoot'
  'rightFoot'
]

LIMBS = [
  ['head', 'neck']
  ['leftHand', 'leftElbow']
  ['leftElbow', 'leftShoulder']
  ['rightHand', 'rightElbow']
  ['rightElbow', 'rightShoulder']
  ['rightShoulder', 'leftShoulder']
  ['leftShoulder', 'torso']
  ['rightShoulder', 'torso']
  ['torso', 'leftHip']
  ['torso', 'rightHip']
  ['leftHip', 'leftKnee']
  ['leftKnee', 'leftFoot']
  ['rightHip', 'rightKnee']
  ['rightKnee', 'rightFoot']
]

SKELETON_SCALE = 0.1

class @Skeleton
  constructor: (@scene, manager) ->
    @bodyMap = {}
    @lines = []
    manager = new THREE.LoadingManager()
    loader = new THREE.OBJMTLLoader(manager)
    for bodyPartName in BODY_PARTS
      switch bodyPartName
        when 'head'
          loader.load FOX_HEAD_OBJ, FOX_HEAD_MTL, (object) =>
            object.traverse (obj) ->
              obj.visible = false

            @bodyMap['foxHead'] = object
            @scene.add object
      # Add a cube for everything for now as we need it for lines.
      cubeGeometry = new THREE.CubeGeometry(1, 1, 1)
      cubeMaterial = new THREE.MeshBasicMaterial(color: 0xFF0000)
      cube = new THREE.Mesh(cubeGeometry, cubeMaterial)
      cube.visible = false
      @bodyMap[bodyPartName] = cube
      @scene.add cube

    for joints in LIMBS
      [jointA, jointB] = joints
      jointAVertex = @bodyMap[jointA].position
      jointBVertex = @bodyMap[jointB].position
      geometry = new THREE.Geometry()
      geometry.vertices.push jointAVertex
      geometry.vertices.push jointBVertex
      material = new THREE.LineBasicMaterial
        color: 0x00ff00
        linewidth: 1000
      line = new THREE.Line geometry, material
      line.visisble = false
      @scene.add line
      @lines.push line

  hide: ->
    for bodyPartName, bodyPart of @bodyMap
      bodyPart.traverse (object) ->
        object.visible = false
    for line in @lines
      line.visible = false

  updateBodyPart: (bodyPart, points) ->
    unless bodyPart?
      # obj may not have loaded
      return
    bodyPart.position.x = points.x * SKELETON_SCALE
    bodyPart.position.y = points.y * SKELETON_SCALE
    bodyPart.position.z = points.z * -SKELETON_SCALE
    bodyPart.traverse (obj) ->
      obj.visible = true

  update: (skeleton) ->
    for bodyPartName, points of skeleton
      if bodyPartName == 'head'
        bodyPart = @bodyMap['foxHead']
        @updateBodyPart(bodyPart, points)
      bodyPart = @bodyMap[bodyPartName]
      @updateBodyPart(bodyPart, points)
    for line in @lines
      line.visible = true
      line.geometry.verticesNeedUpdate = true

