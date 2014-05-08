NUTTIN_BUT_A_G_THANG = '//www.youtube-nocookie.com/embed/0AeAbSpr0bU?wmode=transparent&fs=0'
JUST_BE_GOOD_TO_ME  = '//www.youtube-nocookie.com/embed/UHDPMIFwIKA?wmode=transparent&fs=0'

HIP_HOP  = '//www.youtube-nocookie.com/embed/4jNyr6BJZuI?wmode=transparent&fs=0'

SUMMERTIME  = '//www.youtube-nocookie.com/embed/Kr0tTbTbmVA?wmode=transparent&fs=0'

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
    if Session.equals 'videoSrc'
      return 'selected'

getYoutubeId = (url) ->
  regExp = /^.*(youtu.be\/|v\/|u\/\w\/|embed\/|watch\?v=|\&v=)([^#\&\?]*).*/
  match = url.match regExp
  if match? and match[2].length == 11
    return match[2]

Template.video.events
  'change .video-select': (e) ->
    videoSrc = $(e.target).val()
    console.log videoSrc
    Session.set 'videoSrc', videoSrc
  'submit .youtube-id': (e) ->
    e.preventDefault()
    url = $('#youtube-id-field').val()
    id = getYoutubeId url
    if id?
      Session.set 'videoSrc', "//www.youtube-nocookie.com/embed/#{id}?wmode=transparent&fs=0"

