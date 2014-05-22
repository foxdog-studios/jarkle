Template.keyboardCover.rendered = ->
  cover = $(@find '.keyboard-cover')
  @_coverComp = Deps.autorun =>
    if Session.get 'coverKeyboard'
      cover.show()
    else
      cover.hide()

Template.keyboardCover.destroyed = ->
  @_coverComp?.stop()

