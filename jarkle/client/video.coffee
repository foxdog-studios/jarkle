NUTTIN_BUT_A_G_THANG = '//www.youtube-nocookie.com/embed/0AeAbSpr0bU?wmode=transparent'
JUST_BE_GOOD_TO_ME  = '//www.youtube-nocookie.com/embed/UHDPMIFwIKA?wmode=transparent'

VIDEO_SRCS = [
  src: NUTTIN_BUT_A_G_THANG
  name: "Nuthin' but a G Thang"
,
  src: JUST_BE_GOOD_TO_ME
  name: 'Just the way you like it'
]

Template.video.helpers
  videoSrc: ->
    videoSrc = Session.get 'videoSrc'
    unless videoSrc?
      return NUTTIN_BUT_A_G_THANG
    videoSrc
  videoSrcs: ->
    VIDEO_SRCS
  selected: ->
    if @src == Session.get 'videoSrc'
      return 'selected'
  jarkleUrl: ->
    "#{Meteor.absoluteUrl()}#{Router.current().path[1..]}"


Template.video.events
  'change .video-select': (e) ->
    videoSrc = $(e.target).val()
    console.log videoSrc
    Session.set 'videoSrc', videoSrc

