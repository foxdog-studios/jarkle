# -*- coding: utf-8 -*-

from __future__ import absolute_import
from __future__ import division
from __future__ import print_function

import ddp

import midimule


def get_listener(args):
    return DrumsListener(args[0], args[1])


class DrumsListener(midimule.MidiPortListener):
    def __init__(self, server_url, roomId):
        self._client = ddp.DdpClient(server_url)
        self._roomId = roomId

    def on_before_open(self):
        self._client.enable()

    def on_message(self, message, data=None):
        # Check the event is the correct length.
        event = message[0]
        if len(event) != 3:
            return

        # Check the event is a channel 10 note-on event.
        status, data1, data2 = message[0]
        if status != 153:
            return

        note = data1
        velocity = data2

        # Check that the note is audible.
        if velocity == 0:
            return

        # Check if there is a name for this note.
        name = {
            31: 'snare',
            33: 'kick',
            42: 'hi-hat closed',
            43: 'low tom',
            44: 'hi-hat pedal',
            46: 'hi-hat open',
            47: 'mid tom',
            48: 'high tom',
            49: 'crash',
            51: 'ride',
            85: 'hi-hat stamp',
        }.get(note)

        if name is None:
            return

        self._client.call('drumHit', self._roomId, name)

        # If this is a loud ride, also enable the next player.
        if name == 'ride' and velocity == 127:
            self._client.call('enableSinglePlayer', self._roomId)

    def on_after_close(self):
        self._client.disable()

