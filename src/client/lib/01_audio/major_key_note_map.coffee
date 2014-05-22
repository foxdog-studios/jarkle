TONE = 2
SEMI_TONE = 1

@MAJOR_KEY_INTERVALS = [
  TONE
  TONE
  SEMI_TONE
  TONE
  TONE
  TONE
  SEMI_TONE
]

@PENTATONIC_INTERVALS = [
  TONE + SEMI_TONE
  TONE
  TONE
  TONE + SEMI_TONE
  TONE
]

KEY_MAP =
  'C': 0
  'D#': 1
  'D': 2
  'D#': 3
  'E': 4
  'F': 5
  'F#': 6
  'G': 7
  'G#': 8
  'A': 9
  'A#': 10
  'B': 11

MAX_NOTES = 127

class @MajorKeyNoteMap
  constructor: (@numNotes, @startNote, @key, @intervals) ->
    @noteMap = []
    currentNoteNumber = KEY_MAP[@key]
    while currentNoteNumber < @startNote
      currentNoteNumber += 12
    intervals_index = 0
    while currentNoteNumber < @numNotes
      @noteMap.push currentNoteNumber
      interval = @intervals[intervals_index]
      currentNoteNumber += interval
      intervals_index = (intervals_index + 1) % @intervals.length

  getNote: (ratioY, ratioX) ->
    @noteMap[Math.round(ratioY * @noteMap.length)] + (ratioX - 0.5) * 24

  getNumberOfNotes: ->
    @noteMap.length


