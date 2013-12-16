class @CustomNoteMap
  constructor: (@notes) ->

  getNote: (ratio) ->
    @notes[Math.round(ratio * @notes.length)]

  getNumberOfNotes: ->
    @notes.length
