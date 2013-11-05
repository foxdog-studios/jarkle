Template.info.helpers
  message: ->
    message = Session.get 'infoMessage'
    unless message?
      message = ''
    message
