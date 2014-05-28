@Settings = settings = Meteor.settings ? {}


# 1) Top-level settings

_.defaults settings,
  players: {}
  viewer: {}


# 1.1) Player settings

_.defaults settings.players,
  enableOnJoin: true



# 1.2) Viewer settings

_.defaults settings.viewer,
  message: 'The Jarkle'

