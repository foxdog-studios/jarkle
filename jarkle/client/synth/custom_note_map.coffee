class @CustomNoteMap
  constructor: (@notes) ->

  getNote: (ratio) ->
    @notes[Math.floor(ratio * @notes.length)]

  getNumberOfNotes: ->
    @notes.length
