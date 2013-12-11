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

@generateName = (limit) ->
  unless limit?
    limit = -1
  first = _randomElFromArray(FIRST_WORDS)[0..limit]
  second = _randomElFromArray(SECOND_WORDS)[0..limit]
  third = _randomElFromArray(THIRD_WORDS)[0..limit]
  "#{first}-#{second}-#{third}"

