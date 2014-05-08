@hasWebGL = ->
  canvas = document.createElement('canvas')
  window.WebGLRenderingContext \
    and (canvas.getContext('webgl') or canvas.getContext('experimental-webgl'))

