@jarkleUrl = ->
  "#{Meteor.absoluteUrl()}#{Router.current()?.path[1..]}"

@jarkleDomainAndPath = ->
  jarkleUrl()[7..]

Handlebars.registerHelper 'jarkleUrl', ->
  jarkleUrl()

Handlebars.registerHelper 'jarkleDomainAndPath', ->
  jarkleDomainAndPath()

