Template.info.helpers
  message: ->
    message = Session.get 'infoMessage'
    unless message?
      return ''
    if message.match(/Android/i)
      return 'Android'
    if message.match(/Blackberry/i)
      return 'Blackberry'
    if message.match(/iPhone/i)
      return 'iPhone'
    if message.match(/iPad/i)
      return 'iPad'
    if message.match(/iPod/i)
      return 'iPod'
    if message.match(/IEMobile/i)
      return 'Windows phone'
    return message

