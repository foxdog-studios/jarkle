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
  ['rightHand', 'rightElbow']
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

            @bodyMap['head'] = object
            @scene.add object
        else
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
      lineGeometry = new THREE.Geometry()
      lineGeometry.vertices.push jointAVertex
      lineGeometry.vertices.push jointBVertex
      material = new THREE.LineBasicMaterial
        color: 0xffffff
        opacity: 1
        linewidth: 20
      line = new THREE.Line lineGeometry, material
      @scene.add line
      line.traverse (obj) ->
        obj.visible = false
      @lines.push line


  update: (skeleton) ->
    for bodyPartName, points of skeleton
      bodyPart = @bodyMap[bodyPartName]
      unless bodyPart?
        # obj may not have loaded
        continue
      bodyPart.position.x = points.x * SKELETON_SCALE
      bodyPart.position.y = points.y * SKELETON_SCALE
      bodyPart.position.z = points.z * -SKELETON_SCALE
      bodyPart.traverse (obj) ->
        obj.visible = true
    for line in @lines
      line.traverse (obj) ->
        obj.visible = true

