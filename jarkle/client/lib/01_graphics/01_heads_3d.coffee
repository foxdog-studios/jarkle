class @Heads3D
  constructor: (@_head, options) ->
    @_initOptions options
    @_initHeads()

  _initOptions: (options) ->
    options = _.defaults (options ? {}),
      count: 1
    @_count = options.count

  _initHeads: ->
    @_nextIndex = 0
    @_assigned = {}
    @_heads = for i in [0...@_count]
      new Head3D @_head.clone()

  addToScene: (scene) ->
    for head in @_heads
      head.addToScene scene

  animate: ->
    for head in @_heads
      head.animate()

  onInputStart: (input) ->
    if (head = @_getNextHead())?
      @_assigned[input.inputId] = head
      head.onInputStart input

  onInputMove: (input) ->
    @_assigned[input.inputId]?.onInputMove input

  onInputStop: (input) ->
    if (head = @_assigned[input.inputId])?
      head.onInputStop input
      delete @_assigned[input.inputId]

  onDrumHit: (drumName) ->
    if (head = @_getNextHead())?
      head.onDrumHit drumName

  _getNextHead: ->
    if (head = @_heads[@_nextIndex])?
      @_nextIndex = (@_nextIndex + 1) % @_count
      head

