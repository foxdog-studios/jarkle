@setBackground = ->
  bgImage = new Image()
  $(bgImage).addClass('bg-image')
  $('body').append(bgImage)
  bgImage.src = Meteor.settings.public.background

