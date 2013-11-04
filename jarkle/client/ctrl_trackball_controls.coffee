class @CtrlTrackBallControls
  constructor: (@camera, @el) ->
    @trackBallControls = new THREE.TrackballControls @camera, @el
    @trackBallControls.enabled = false
    unless @el?
      @el = document
    @el.addEventListener 'keydown', @handleKeyDown, false
    @el.addEventListener 'keyup', @handleKeyUp, false

  update: ->
    @trackBallControls.update()

  handleKeyDown: (evt) =>
    @trackBallControls.enabled = evt.ctrlKey

  handleKeyUp: (evt) =>
    @trackBallControls.enabled = evt.ctrlKey

