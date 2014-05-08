Template.viewer.helpers
  isInGFunkMode: ->
    console.log Meteor.settings.public.isInGFunkMode and not isLocalSynth()
    Meteor.settings.public.isInGFunkMode and not isLocalSynth()

