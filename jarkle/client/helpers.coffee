jarkleUrl = ->
  "#{Meteor.absoluteUrl()}#{Router.current().path[1..]}"

Handlebars.registerHelper 'jarkleUrl', ->
  jarkleUrl()

Handlebars.registerHelper 'jarkleDomainAndPath', ->
  jarkleUrl()[7..]

