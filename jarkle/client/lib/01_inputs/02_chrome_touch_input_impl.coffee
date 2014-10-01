# Peter Sutton 1 Oct 2014
#
# First observed during The Oblong Show, 28 Oct 2014. There appears to
# be a bug in Chrome (desktop and phone) that stops touch events being
# fired by the player's (not the master's) keyboard after the first
# touch ends.
#
# Renabling the touch event listener after the first touch seems to
# solve the problem.
#
# Once this bug has been fixed in Chrome;
#
#   1. Remove this file;
#   2. Change TouchInput.create() to always return an instance of
#      TouchInputImpl; and
#   3. Remove the package awatson1978:bowser (unless it being used
#      elsewhere, check).
#
# Last checked: 1 Oct 2014

class @ChromeTouchInputImpl extends TouchInputImpl
  constrcuctor: ->
    super
    @_renabled = false

  _onTouchStop: ->
    super
    unless @_renabled
      @_listener.disable()
      @_listener.enable()
      @_renabled = true

