Template.viewerVideoOption.helpers
  selected: ->
    Deps.nonreactive ->
      Session.equals 'videoId', @id

