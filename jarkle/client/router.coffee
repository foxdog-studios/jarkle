Router.configure
  layoutTemplate: 'layout'

Router.map ->
  @route 'master',
    path: '/master'
    template: 'master'
  @route 'reroute',
    path: '/'
    template: 'main'
    before: ->
      if Meteor.settings.public.automaticRoomIds
        @redirect("/#{generateName(2)}")
      else
        Session.set 'roomId', 'main'
  @route 'main',
    path: '/:roomId'
    before: ->
      Session.set 'roomId', @params.roomId
    action: ->
      if isViewer()
        @render('viewer')
      else
        @render('main')

