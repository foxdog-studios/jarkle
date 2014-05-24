@Settings = settings = Meteor.settings?.public ? {}


# 1) Public settings

_.defaults settings,
  autoRoom: false
  defaultRoom: 'jarkle'
  pitchAxis: 'y' # Valid options are 'x', 'y', '-x', '-y'
  pitches: 'c4 d4 e4 f4 g4 a4 b4 c5'

  keyboard: {}
  viewer: {}


# 1.1) Keyboard settings

_.defaults settings.keyboard,
  master: {}
  player: {}


# 1.1.1) Master keyboard settings

_.defaults settings.keyboard.master,
  enable: true
  enableSynth: true
  maxTouches: 5
  timeout: 5


# 1.1.2) Player keyboard settings

_.defaults settings.keyboard.player,
  enable: true
  enableSynth: true
  maxTouches: 5
  showMessage: true


# 1.2) Viewer settings

_.defaults settings.viewer,
  background: '/viewer/backgrounds/starfield.jpg'
  enableInputs: true
  enableRoomControls: true
  enableSynth: true
  maxTouches: 5
  showMessage: false
  showSidePanel: true
  videos: []

  twoD: {}
  threeD: {}


# 1.2.1) Viewer video settings

if _.isEmpty settings.viewer.videos

  # The firs video is the default.
  settings.viewer.videos.splice 0, 0,
    id: '4jNyr6BJZuI'
    name: 'Hip Hop'
  ,
    id: 'UHDPMIFwIKA'
    name: 'Just the way you like it'
  ,
    id: 'Kr0tTbTbmVA'
    name: 'Summertime'


# 1.2.2) 2D viewer settings

_.defaults settings.viewer.twoD,
  headSize: 60
  headUrls: []


# 1.2.2.1) 2D viewer head URLs

if _.isEmpty settings.viewer.twoD.headUrls
  headUrls = [
    '/viewer/heads2d/face.png'
    '/viewer/heads2d/dino.png'
  ]
  settings.viewer.twoD.headUrls.splice 0, 0, headUrls...


# 1.2.3) 3D viewer settings

_.defaults settings.viewer.threeD,
  drawDistance: 1500
  cubes: {}
  heads: {}


# 1.2.3.1) 3D viewer cube settings

_.defaults settings.viewer.threeD.cubes,
  color: '0x00ff00'
  count: 50
  scale: 10
  speed: -2


# 1.2.3.2) 3D viewer head settings

_.defaults settings.viewer.threeD.heads,
  count: 10
  headScale: 0.2
  movementScale: 10
  speed: -2

  appearances: {}


# 1.2.3.2.1) 3D viewer head appearance settings

if _.isEmpty settings.viewer.threeD.heads.appearances
  _.extend settings.viewer.threeD.heads.appearances,
    # Masters
    pug:
      obj: '/viewer/heads3d/pug/pug.obj'
      mtl: '/viewer/heads3d/pug/pug.mtl'
      master: true

    # Players
    dino:
      obj: '/viewer/heads3d/dino/dino.obj'
      mtl: '/viewer/heads3d/dino/dino.mtl'
      master: false

    fox:
      obj: '/viewer/heads3d/fox/fox.obj'
      mtl: '/viewer/heads3d/fox/fox.mtl'
      master: false

    godzilla:
      obj: '/viewer/heads3d/godzilla/godzilla.obj'
      mtl: '/viewer/heads3d/godzilla/godzilla.mtl'
      master: false

    santa:
      obj: '/viewer/heads3d/santa/santa.obj'
      mtl: '/viewer/heads3d/santa/santa.mtl'
      master: false


