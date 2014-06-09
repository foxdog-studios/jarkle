@Settings = settings = Meteor.settings?.public ? {}


# 1) Public settings

_.defaults settings,
  enableRooms: false
  randomRoomsOnRootPath: true
  pitchAxis: 'y' # Valid options are 'x', 'y', '-x', '-y'
  pitches: 'a0 f1 g1 a1 f2 g2 a2 f3 g3 a3 f4 g4 a4 f5 g5 a5 f6 g6 a6 f7 g7 a7'

  keyboard: {}
  viewer: {}
  voices: {}


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
  showPlayers: false
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
  drums: {}
  heads: {}
  skeleton: {}
  starField: {}


# 1.2.3.1) 3D viewer cube settings

_.defaults settings.viewer.threeD.cubes,
  color: '0x00ff00'
  count: 50
  scale: 10
  speed: -2


# 1.2.3.2) 3D viewer drum visualization settings

_.defaults settings.viewer.threeD.drums,
  enabled: false
  obj: '/viewer/heads3d/fox/fox.obj'
  mtl: '/viewer/heads3d/fox/fox.mtl'
  count: 50


# 1.2.3.3) 3D viewer head settings

_.defaults settings.viewer.threeD.heads,
  count: 10
  headScale: 0.2
  movementScale: 10
  speed: -2

  appearances: {}


# 1.2.3.3.1) 3D viewer head appearance settings

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


# 1.2.3.4) 3D viewer skeleton

_.defaults settings.viewer.threeD.skeleton,
  enabled: true
  obj: '/viewer/heads3d/fox/fox.obj'
  mtl: '/viewer/heads3d/fox/fox.mtl'
  notes:
    leftHand:
      rightHand: 'c4'
      leftShoulder: 'd4'
      leftHip: 'e4'
      rightShoulder: 'f4'
    rightHand:
      rightShoulder: 'g4'
      leftHip: 'a4'
      rightHip: 'b4'
      leftShoulder: 'c5'

# 1.2.3.5) 3D viewer star field

_.defaults settings.viewer.threeD.starField,
  count: 1000
  map: '/viewer/stars/particle.png'
  speed: -8
  starColor: '0xfefefe'
  starSize: 10
  travelAxis: 'z'


# 1.3) Voices

_.defaults settings.voices,
  masters: []
  players: []
  vibrato:
    enabled: true
    multiplier: 1000

# 1.3.1) Master voices

if _.isEmpty settings.voices.masters
  masterVoices = [
    oscillator: 'sawtooth'
    gain: 0.8
  ]
  settings.voices.masters.splice 0, 0, masterVoices...

for voice in settings.voices.masters
  _.defaults voice,
    oscillator: 'sawtooth'
    gain: 0.5

# 1.3.2) Player voices

if _.isEmpty settings.voices.players
  playerVoices = [
    oscillator: 'square'
  ,
    oscillator: 'triangle'
  ]
  settings.voices.players.splice 0, 0, playerVoices...

for voice in settings.voices.players
  _.defaults voice,
    oscillator: 'square'
    gain: 0.5

