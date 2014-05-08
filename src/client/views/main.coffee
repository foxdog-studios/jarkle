TIME_OUT = 1000
IMAGE_SIZE = 64
IMAGE_SRC = 'finaldino.gif'

$ ->
  FastClick.attach(document.body)

RESTART_BLACKEN = 'restart-blacken'
@PAIRS_TOUCHING = 'pairs-touching'
@CURRENT_PLAYER = 'current-player'

@isLocalSynth = ->
  Router.current()?.params.localSynth

isSupportedSynthDevice = ->
  isLocalSynth() or Meteor.Device.isDesktop() or Meteor.Device.isTV()

hasWebAudio = ->
  unless window.AudioContext or window.webkitAudioContext
    return false
  window.AudioContext = window.AudioContext or window.webkitAudioContext
  a = new window.AudioContext
  return a.createOscillator?

@isViewer = ->
  isSupportedSynthDevice() and hasWebAudio()

@createRoomEventName = (eventName) ->
  if Meteor.settings.public.rooms
    "#{Session.get('roomId')}-#{eventName}"
  else
    eventName

PASSWORD = 'thisDoesNotMatter'

Meteor.startup ->
  Deps.autorun ->
    if Meteor.user() and not isViewer()
      if Meteor.settings.public.isInGFunkMode
        Session.set('infoMessage',
          "Open #{jarkleDomainAndPath()} on a laptop/desktop then touch me")
      else
        Session.set 'infoMessage', "#{Meteor.user().profile.name}"
    if Meteor.loggingIn() or Meteor.user()?
      return
    Accounts.createUser
      username: Random.hexString(32)
      password: PASSWORD
      profile:
        userAgent: navigator.userAgent
        name: generateName()
    , (error) ->
      if error?
        # XXX: Just log the error
        console.log "Error creating user #{error}"

