Template.info.helpers
  message: ->
    message = Session.get 'infoMessage'
    unless message?
      return ''
    return message

