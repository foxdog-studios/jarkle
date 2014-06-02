# -*- coding: utf-8 -*-

from __future__ import absolute_import
from __future__ import division
from __future__ import print_function

from argparse import ArgumentParser

import ddp

import midimule


def get_listener(args):
    parser = ArgumentParser()
    parser.add_argument('server_url')
    parser.add_argument('room_id')
    args = parser.parse_args(args=args)
    return RoomControls(args.server_url, args.room_id)


class RoomControls(midimule.MidiPortListener):
    def __init__(self, server_url, roomId):
        self._client = ddp.DdpClient(server_url)
        self._roomId = roomId

        handlers = {
            (41, 43): self._show_message,
            (48, 50): self._hide_message,
            (55, 57): self._enable_single_player,
            (62, 64): self._enable_all_players,
            (69, 71, 72, 74, 76, 77): self._disable_all_players,
        }

        self._handlers = {}
        for notes, handler in handlers.iteritems():
            for note in notes:
                self._handlers[note] = handler

    def on_before_open(self):
        self._client.enable()

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
        self._client.disable()

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
        self._client.call(name, self._roomId)

