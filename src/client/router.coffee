Router.configure
  layoutTemplate: 'layout'
  loadingTemplate: 'loading'


Router.onBeforeAction 'loading'


mapLobby = (router) ->
  controller = if Settings.autoRoom
    'AutoRoomController'
  else
    'LobbyController'

  router.route 'lobby',
    path: '/'
    controller: controller


mapMasterKeyboard = (router) ->
  if Settings.keyboard.master.enable
    router.route 'masterKeyboard',
      path: '/:roomId/master'
      controller: 'MasterKeyboardController'


mapPlayerKeyboard = (router) ->
  if Settings.keyboard.player.enable
    router.route 'playerKeyboard',
      path: '/:roomId'
      controller: 'PlayerKeyboardController'


mapViewer = (router) ->
  router.route 'viewer',
    path: '/:roomId/viewer'
    controller: 'ViewerController'


Router.map ->
  mappers = [
    mapLobby
    mapMasterKeyboard
    mapPlayerKeyboard
    mapViewer
  ]

  for mapper in mappers
    mapper this

