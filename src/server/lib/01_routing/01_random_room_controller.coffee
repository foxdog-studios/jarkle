class @RandomRoomController extends RouteController
  action: ->
    @response.writeHead 307,
      Location: Router.path 'viewer', roomId: getRandomRoomName()
    @response.end()

