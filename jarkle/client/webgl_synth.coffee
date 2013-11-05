class @WebGlSynth
  constructor: (@schema, el, noteMap, pubSub) ->
    window.AudioContext = window.AudioContext or window.webkitAudioContext
    @synth = new Synth(new AudioContext(), noteMap, pubSub, @schema)
    @webGLVis = new WebGLVisualisation(el, window.innerWidth,
                                      window.innerHeight, @schema)
    @playerManager = new PlayerManager(@schema)

  handleNoteMessage: (noteMessage) =>
    userId = noteMessage.userId
    playerId = @playerManager.getPlayerIdFromUserId(userId)
    @synth.handleMessage noteMessage, playerId
    @webGLVis.updateCube noteMessage, playerId

