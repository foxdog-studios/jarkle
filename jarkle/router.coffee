Router.configure
  layoutTemplate: 'layout'

Router.map ->
  @route 'master',
    path: '/master'
    template: 'master'
  @route 'reroute',
    path: '/'
    action: ->
      @redirect("/#{generateName(2)}")
  @route 'main',
    path: '/:roomId'
    template: 'main'
    before: ->
      Session.set 'roomId', @params.roomId

