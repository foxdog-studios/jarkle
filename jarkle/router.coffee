Router.configure
  layoutTemplate: 'layout'

Router.map ->
  @route 'main',
    path: '/'
    template: 'main'
  @route 'master',
    path: '/master'
    template: 'master'

