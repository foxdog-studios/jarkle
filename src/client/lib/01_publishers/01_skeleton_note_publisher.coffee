class @SkeletonNotePublisher
  constructor: (stream, roomId, pubsub) ->
    # Configuration
    @_config = {}
    for jointNameA, jointBs of Settings.viewer.threeD.skeleton.notes
      @_config[jointNameA] = jointA = {}
      for jointNameB, pitch of jointBs
        jointA[jointNameB] = Pitches.parse(pitch)[0].getFrequency()

    # Monitors
    @_monitors = {}
    trigger = new PubsubNoteTrigger pubsub
    for jointAName, jointBs of @_config
      @_monitors[jointAName] = new TimeoutMonitor trigger

    # Listener
    @_skeletonsListener = new StreamSkeletonsListener stream, roomId, this

  onSkeletons: (skeletons) =>
    if (skeleton = skeletons[0])?
      @_onSkeleton skeleton.skeleton
    else
      @_stopAllNote()

  _onSkeleton: (skeleton) ->
    triggered = {}
    for jointAName, jointBs of @_config
      inRange = []

      for jointBName, frequency of jointBs
        posA = skeleton[jointAName]
        posB = skeleton[jointBName]
        distance = @_distance posA, posB
        if distance <= 300
          inRange.push [jointBName, frequency, distance]

      monitor = @_monitors[jointAName]

      if inRange[0]?
        inRange = _.sortBy inRange, (element) -> element[2]
        [jointBName, frequency, distance] = inRange[0]
        monitor.move
          frequency: frequency
          inputId: "skeleton:#{ jointAName }"
          isMaster: true
          jointA: jointAName
          jointB: jointBName
          userId: 'skeleton'
      else
        monitor.forceStop()

  _distance: (a, b) ->
    xd = b.x - a.x
    yd = b.y - a.y
    zd = b.z - a.z
    Math.pow (xd * xd) + (yd * yd) + (zd * zd), 0.5

  _stopAllNote: ->

  enable: ->
    @_skeletonsListener.enable()

  disable: ->
    @_skeletonsListener.disable()

