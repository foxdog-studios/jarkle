class @Visualizer2d
  constructor: (@_canvas) ->
    @_initSettings()
    @_initContext()
    @_initHeads()
    @_initResizer()
    @_initUsers()

  _initSettings: ->
    settings = Settings.viewer.twoD
    @_headSize = settings.headSize
    @_headUrls = settings.headUrls

  _initContext: ->
    @_ctx = @_canvas.getContext '2d'

  _initHeads: ->
    @_heads = cycle _.shuffle(new Head2d url for url in @_headUrls)

  _initResizer: ->
    @_resizeListener = new DomEventListener window,
      'resize': => @_resize()

  _resize: ->
    CanvasUtils.resize @_canvas

  _initUsers: ->
    @_users = {}

  onInputStart: (input) =>
    @_drawUserHead input

  onInputMove: (input) =>
    @_drawUserHead input

  onInputStop: (input) =>

  _drawUserHead: (input) ->
    dx = input.x * @_canvas.width
    dy = (1 - input.y) * @_canvas.height
    @_getUserHead(input).draw @_ctx, dx, dy, @_headSize

  _getUserHead: (input) ->
    id = input.userId
    unless @_users[id]?
      @_users[id] = @_heads()
    @_users[id]

  enable: ->
    @_resizeListener.enable()
    @_resize()

  disable: ->
    @_resizeListener.disable()

