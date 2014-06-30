Template.playerKeyboard.created = ->
  Session.set 'showMessage', Settings.keyboard.player.showMessage
  @_playerComputation = Deps.autorun (computation) ->
    player = Players.findOne {},
      fields:
        isEnabled: 1
        name: 1
    enabled = player?.isEnabled ? false
    Session.set 'enableInputs', enabled
    Session.set 'coverKeyboard', not enabled
    Session.set 'message', player?.name


Template.playerKeyboard.helpers
  keyboardData: ->
    settings = Settings.keyboard.player

    enableSynth: settings.enableSynth
    isMaster: false
    maxTouches: settings.maxTouches
    pitchAxis: @pitchAxis
    pitches: @pitches
    roomId: @roomId


Template.playerKeyboard.destroyed = ->
  @_playerComputation.stop()
  Session.set 'message'
  Session.set 'coverKeyboard'
  Session.set 'enableInputs'
  Session.set 'showMessage'

