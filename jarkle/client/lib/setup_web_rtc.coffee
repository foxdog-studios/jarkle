@setupWebRtc = ->
  return unless Meteor.settings.public.useWebRTCForMaster
  # This is the config used to create the RTCPeerConnection
  servers =
    iceServers: [
      url: 'stun:stun.l.google.com:19302'
    ]

  config = {}

  dataChannelConfig =
    ordered: false
    maxRetransmitTime: 0

  # Try and create an RTCPeerConnection if supported
  if RTCPeerConnection?
    return webRTCSignaller = new @WebRTCSignaller('webRTCChannel',
                                                  servers,
                                                  config,
                                                  dataChannelConfig)
  else
    console.error 'No RTCPeerConnection available :('

  return

