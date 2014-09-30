FIRST = 'abcdefghijklmnopqrstuvwxyz'
SECOND = 'aeiou'
THIRD = FIRST

@getRandomRoomName = ->
  parts = []
  for wordArray in [FIRST, SECOND, THIRD]
    parts.push Random.choice(wordArray)
  parts.join('')

