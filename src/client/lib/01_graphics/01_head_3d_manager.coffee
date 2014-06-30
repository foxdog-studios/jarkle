class @Head3DManager
  constructor: ->
    @_initSettings()
    @_initLoader()
    @_initAppearances()

  _initSettings: ->
    settings = Settings.viewer.threeD.heads
    @_appearances = for name, appearance of settings.appearances
      appearance = _.clone appearance
      appearance.name = name
      appearance

  _initLoader: ->
    @_loader = new THREE.OBJMTLLoader

  _initAppearances: ->
    @_masterAppearances = @_buildAppearances true
    @_playerAppearances = @_buildAppearances false

  _buildAppearances: (isMaster) ->
    appearances = for appearance in @_appearances
      if appearance.master != isMaster
        continue
      appearance
    new Head3DAppearances @_loader, appearances

  addToScene: (scene) ->
    @_masterAppearances.addToScene scene
    @_playerAppearances.addToScene scene

  animate: ->
    @_masterAppearances.animate()
    @_playerAppearances.animate()

  onInputStart: (input) ->
    @_getAppearances(input).onInputStart input

  onInputMove: (input) ->
    @_getAppearances(input).onInputMove input

  onInputStop: (input) ->
    @_getAppearances(input).onInputStop input

  _getAppearances: (input) ->
    if input.isMaster
      @_masterAppearances
    else
      @_playerAppearances

