Template.viewerPlayers.helpers
  playerCount: ->
    Counts.findOne(@roomId)?.count ? '-'

