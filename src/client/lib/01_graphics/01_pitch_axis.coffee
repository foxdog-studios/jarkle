class @PitchAxis
  constructor: (@axis, @inverted) ->

  @parse: (axis) ->
    match = axis.match /^(-)?([xy])$/i
    unless match?
      throw new Error "#{ axis } is not a valid axis"
    new PitchAxis match[2].toLowerCase(), match[1]?

