Template.viewerSidePlane.created = ->
  Session.set 'sidePaneVisible', true
  Session.set 'videoId', Settings.viewer.videos[0].id

Template.viewerSidePlane.helpers
  keyboardUrl: ->
    Meteor.absoluteUrl @roomId

  videoSrc: ->
    if (id = Session.get 'videoId')?
      buildYoutubeUrl id

  videos: ->
    Settings.viewer.videos

  sidePaneVisible: ->
    Session.get('sidePaneVisible')

Template.viewerSidePlane.events
  'change .video-select': (event, template) ->
    Session.set 'videoId', $(event.target).val()

  'submit .youtube-id': (event, template) ->
    event.preventDefault()
    if (id = extractYoutubeId $('#youtube-id-field').val())?
      Session.set 'videoId', id


Template.viewerSidePlane.destroyed = ->
  Session.set 'videoId'


Template.viewerSidePlane.events
  'click [name=hide]': (event) ->
    event.preventDefault()
    sidePane = Session.get('sidePaneVisible')
    Session.set('sidePaneVisible', not sidePane)


# ==============================================================================
# = Helpers                                                                    =
# ==============================================================================

URL_REGEX = /^.*(?:youtu.be\/|v\/|u\/\w\/|embed\/|watch\?v=|\&v=)([^#\&\?]*).*/

buildYoutubeUrl = (id) ->
  "//www.youtube-nocookie.com/embed/#{ id }?wmode=transparent&fs=0"

extractYoutubeId = (url) ->
  match = url.match URL_REGEX
  if match?[1].length == 11
    match[1]

