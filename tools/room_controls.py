# -*- coding: utf-8 -*-
'''
Layout:

    41 | F     | Disable
    42 | F#/Gb | Disable
    43 | G     | Disable
    44 | G#/Ab | Disable
    45 | A     | Disable
    46 | A#/Bb | Disable
    47 | B     | Disable
    48 | C     | Disable
    49 | C#/Db | Disable
    50 | D     | Disable
    51 | D#/Eb | Disable
    52 | E     | Disable
    53 | F     |
    54 | F#/Gb |
    55 | G     |
    56 | G#/Ab |
    57 | A     | Show message
    58 | A#/Bb |
    59 | B     | Hide message
    60 | C     |
    61 | C#/Db |
    62 | D     |
    63 | D#/Eb |
    64 | E     | Single player
    65 | F     |
    66 | F#/Gb |
    67 | G     |
    68 | G#/Ab |
    69 | A     |
    70 | A#/Bb |
    71 | B     |
    72 | C     |
    73 | C#/Db |
    74 | D     | Everyone
    75 | D#/Eb |
    76 | E     |
    77 | F     |

'''

from __future__ import absolute_import
from __future__ import division
from __future__ import print_function

from argparse import ArgumentParser
import logging

import ddp

import midimule


logger = logging.getLogger(__name__)


def get_listener(args):
    parser = ArgumentParser()
    parser.add_argument('server_url')
    parser.add_argument('room_id')
    args = parser.parse_args(args=args)
    return RoomControls(args.server_url, args.room_id)


class RoomControls(midimule.MidiPortListener):
    def __init__(self, server_url, roomId):
        self._client = ddp.ConcurrentDDPClient(server_url)
        self._roomId = roomId

        handlers = {
            tuple(xrange(41, 52 + 1)): self._disable_all_players,
            (57,): self._show_message,
            (59,): self._hide_message,
            (64,): self._enable_single_player,
            (74,): self._enable_all_players,
        }

        self._handlers = {}
        for notes, handler in handlers.iteritems():
            for note in notes:
                self._handlers[note] = handler

    def on_before_open(self):
        self._client.start()

    def on_message(self, message, data=None):
        event, delta = message

        # Stop if this is not a 3-byte event.
        if len(event) != 3:
            return

        status, data1, data2 = event

        # Stop if this is not a channel 1 note on event.
        if status != 144 or data2 != 100:
            return

        # Stop if an operation is not assign to the note.
        handler = self._handlers.get(data1)
        if handler is None:
            return

        handler()

    def on_after_close(self):
        self._client.stop()
        self._client.join()

    def _hide_message(self):
        self._call_methods('hideMessage')

    def _show_message(self):
        self._call_methods('showMessage')

    def _enable_single_player(self):
        self._call_methods('enableSinglePlayer')

    def _enable_all_players(self):
        self._call_methods('enableAllPlayers')

    def _disable_all_players(self):
        self._call_methods('disableAllPlayers')

    def _call_methods(self, name):
        future = self._client.call(name, self._roomId)

