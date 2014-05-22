@supportsWebGl = _.once ->
  if window.WebGLRenderingContext?
    canvas = document.createElement 'canvas'
    if canvas.getContext('webgl')?
      return true
  false

