class @ChromaticNoteMap
  constructor: (@numNotes, @startNote) ->

  getNote: (index) ->
    Math.round(index * @numNotes) + @startNote

  getNumberOfNotes: ->
    @numNotes

