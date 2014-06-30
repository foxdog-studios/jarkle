class @Head2d
  constructor: (src) ->
    @_loader = false
    @_canvas = document.createElement 'canvas'
    @_loadImage src

  _loadImage: (src) ->
    image = new Image
    image.onload = =>
      width = image.naturalWidth
      height = image.naturalHeight
      @_canvas.width = width
      @_canvas.height = height
      ctx = @_canvas.getContext '2d'
      ctx.drawImage image, 0, 0, width, height
      @_isLoaded = true
    image.src = src

  draw: (ctx, centerX, centerY, maxSize) ->
    if @_isLoaded
      sw = @_canvas.width
      sh = @_canvas.height
      r = sw / sh
      dw = dh = maxSize
      if r >= 1
        dw *= r
      else
        dh *= r
      dx = centerX - Math.floor dw / 2
      dy = centerY - Math.floor dh / 2
      ctx.drawImage @_canvas, 0, 0, sw, sh, dx, dy, dw, dh

