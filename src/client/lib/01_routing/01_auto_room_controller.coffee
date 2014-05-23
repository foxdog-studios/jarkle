class @AutoRoomController extends RouteController
  action: ->
    Router.go 'playerKeyboard',
      roomId: Settings.defaultRoom

