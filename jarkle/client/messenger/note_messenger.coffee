@NoteMessenger = class NoteMessenger
  @MESSAGE_SENT = 'message-sent'
  @NOTE_START = 'start'
  @NOTE_CONTINUE = 'continue'
  @NOTE_END = 'end'

  constructor: (@messageStream, @pubSub, @eventName) ->

  _addUidToMessage: (message) ->
    message.identifier = "#{Meteor.userId()}-#{message.identifier}"

  _sendMessage: (message) ->
    @_addUidToMessage(message)
    @pubSub.trigger @eventName, message

  sendNoteMessage: (evt, noteOn, type) ->
    x = evt.pageX / window.innerWidth
    y = evt.pageY / window.innerHeight
    userId = Meteor.userId()
    unless userId?
      return
    @_sendMessage
      x: x
      y: y
      noteOn: noteOn
      identifier: evt.identifier
      type: type
      userId: userId

  sendNoteStartMessage: (evt) =>
    @sendNoteMessage evt, true, NoteMessenger.NOTE_START

  sendNoteContinueMessage: (evt) =>
    @sendNoteMessage evt, true, NoteMessenger.NOTE_CONTINUE

  sendNoteEndMessage: (evt) =>
    @sendNoteMessage evt, false, NoteMessenger.NOTE_END
