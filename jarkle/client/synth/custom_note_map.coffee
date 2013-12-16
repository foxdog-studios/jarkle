class @CustomNoteMap
  constructor: (@notes, @noteOffset) ->

  getNote: (ratio) ->
    @notes[Math.floor(ratio * @notes.length)] + @noteOffset

  getNumberOfNotes: ->
    @notes.length
