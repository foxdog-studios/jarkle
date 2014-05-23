Router.configure
  layoutTemplate: 'layout'
  loadingTemplate: 'loading'


Router.onBeforeAction 'loading'


Router.map ->
  @route 'lobby',
    path: '/'
    controller: 'LobbyController'

  @route 'viewer',
    path: '/:roomId/viewer'
    controller: 'ViewerController'

  if Settings.keyboard.master.enable
    @route 'masterKeyboard',
      path: '/:roomId/master'
      controller: 'MasterKeyboardController'

  if Settings.keyboard.player.enable
    @route 'playerKeyboard',
      path: '/:roomId'
      controller: 'PlayerKeyboardController'

