@cycle = (iterable) ->
  unless _.isArray iterable
    iterable = _.keys iterable
  index = 0
  ->
    element = iterable[index]
    index = (index + 1) % iterable.length
    element

