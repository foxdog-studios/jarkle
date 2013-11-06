FIRST_WORDS = [
  'cheese'
  'ham'
  'slippery'
  'fingered'
  'tart'
  'ice'
  'mustard'
  'pastry'
  'distressed'
]
SECOND_WORDS = [
  'bisto'
  'advocaat'
  'lemon'
  'carp'
  'siesta'
  'plum'
  'burger'
  'hotdog'
  'wheelbarrow'
  'wart'
  'toenail'
  'fluffy'
  'vinegar'
]
THIRD_WORDS = [
  'toad'
  'stoat'
  'pringle'
  'ginger'
  'flannel'
  'triceratops'
  'amoeba'
  'lychen'
  'thistle'
  'butt'
  'koala'
]

@UID = Random.hexString(8)

_randomElFromArray = (array) ->
  index = Math.floor(Math.random() * array.length)
  if index >= array.length
    index = array.length -1
  array[index]

@generateName = ->
  first = _randomElFromArray(FIRST_WORDS)
  second = _randomElFromArray(SECOND_WORDS)
  third = _randomElFromArray(THIRD_WORDS)
  "#{first}-#{second}-#{third}"

