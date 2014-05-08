Template.viewer.helpers
  isInGFunkMode: ->
    Meteor.settings.public.isInGFunkMode and not isLocalSynth()

