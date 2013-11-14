NUTTIN_BUT_A_G_THANG = '//www.youtube-nocookie.com/embed/0AeAbSpr0bU?wmode=transparent'
JUST_BE_GOOD_TO_ME  = '//www.youtube-nocookie.com/embed/UHDPMIFwIKA?wmode=transparent'

HIP_HOP  = '//www.youtube-nocookie.com/embed/4jNyr6BJZuI?wmode=transparent'

SUMMERTIME  = '//www.youtube-nocookie.com/embed/Kr0tTbTbmVA?wmode=transparent'

VIDEO_SRCS = [
  src: NUTTIN_BUT_A_G_THANG
  name: "Nuthin' but a G Thang"
,
  src: JUST_BE_GOOD_TO_ME
  name: 'Just the way you like it'
,
  src: HIP_HOP
  name: 'Hip Hop'
,
  src: SUMMERTIME
  name: 'Summertime'
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

Template.video.events
  'change .video-select': (e) ->
    videoSrc = $(e.target).val()
    console.log videoSrc
    Session.set 'videoSrc', videoSrc

