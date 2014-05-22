REFERENCE_PITCH = new AbsolutePitch 'a', 4, 440

class @Pitches
  @parse: (pitches) ->
    for pitch in pitches.split /\s+/
      match = pitch.match /([a-g][b#]?)([0-8])/i
      continue unless match?
      new RelativePitch match[1], parseInt(match[2]), REFERENCE_PITCH

