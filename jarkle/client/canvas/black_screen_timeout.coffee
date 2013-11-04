class @BlackScreenTimeout
  constructor: (@el, @timeoutMillis) ->
    @context = @el.getContext '2d'
    @width = @el.width
    @height = @el.height
    @startTimeout()

  restartTimeout: =>
    if @timeoutId?
      Meteor.clearTimeout @timeoutId
    @context.clearRect 0, 0, @width, @height
    @startTimeout()

  startTimeout: =>
    @timeoutId = Meteor.setTimeout @blackenScreen, @timeoutMillis

  blackenScreen: =>
    @context.fillStyle = '#000000'
    @context.fillRect 0, 0, @width, @height
    @startTimeout()

