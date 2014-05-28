Router.configure
  layoutTemplate: 'layout'
  loadingTemplate: 'loading'
  notFoundTemplate: 'loading'


if Meteor.isClient
  Router.onBeforeAction 'loading'


mapLobby = (router) ->
  if Settings.enableRooms
    if Settings.randomRoomsOnRootPath
      where = 'server'
      controller = 'RandomRoomController'
    else
      where = 'client'
      controller = 'LobbyController'

    router.route 'default',
      path: '/'
      where: where
      controller: controller


mapMasterKeyboard = (router) ->
  if Settings.keyboard.master.enable
    router.route 'masterKeyboard',
      path: makeRoomPath 'master'
      controller: 'MasterKeyboardController'


mapPlayerKeyboard = (router) ->
  if Settings.keyboard.player.enable
    router.route 'playerKeyboard',
      path: makeRoomPath ''
      controller: 'PlayerKeyboardController'


mapViewer = (router) ->
  router.route 'viewer',
    path: makeRoomPath 'viewer'
    controller: 'ViewerController'


makeRoomPath = (relUrl) ->
  baseUrl = if Settings.enableRooms
    '/:roomId/'
  else
    '/'
  baseUrl + relUrl


Router.map ->
  mappers = [
    mapLobby
    mapMasterKeyboard
    mapPlayerKeyboard
    mapViewer
  ]

  for mapper in mappers
    mapper this

