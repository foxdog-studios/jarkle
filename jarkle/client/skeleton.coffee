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

SKELETON_SCALE = 0.1

class @Skeleton
  constructor: (@scene) ->
    @bodyMap = {}
    for bodyPartName in BODY_PARTS
      cubeGeometry = new THREE.CubeGeometry(1, 1, 1)
      cubeMaterial = new THREE.MeshBasicMaterial(color: 0xFF0000)
      cube = new THREE.Mesh(cubeGeometry, cubeMaterial)
      cube.visible = false
      @bodyMap[bodyPartName] = cube
      @scene.add cube

  update: (skeleton) ->
    console.log 'updating'
    for bodyPartName, points of skeleton
      bodyPart = @bodyMap[bodyPartName]
      bodyPart.position.x = points.x * SKELETON_SCALE
      bodyPart.position.y = points.y * SKELETON_SCALE
      bodyPart.position.z = points.z * -SKELETON_SCALE
      bodyPart.visible = true

