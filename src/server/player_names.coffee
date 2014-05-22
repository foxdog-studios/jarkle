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

@generateName = ->
  name = for words in [FIRST_WORDS, SECOND_WORDS, THIRD_WORDS]
    Random.choice words
  name.join ' '

