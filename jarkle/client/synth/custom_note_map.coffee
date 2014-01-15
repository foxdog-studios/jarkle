class @CustomNoteMap
  constructor: (@notes, @noteOffset) ->

  getNote: (ratioY, ratioX) ->
    @notes[Math.floor(ratioY * @notes.length)] + @noteOffset + (ratioX  - 0.5)

  getNumberOfNotes: ->
    @notes.length
