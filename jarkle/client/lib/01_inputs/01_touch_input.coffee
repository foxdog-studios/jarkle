class @TouchInput
  @create: ->
    browser = BrowserObserver.init()
    klass = if browser.chrome
      ChromeTouchInputImpl
    else
      TouchInputImpl
    new klass arguments...

