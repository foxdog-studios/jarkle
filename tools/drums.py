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
        event = message[0]
        if len(event) != 3:
            return
        status, data1, data2 = message[0]
        if status != 153 or data2 == 0:
            return

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
        }.get(data1)

        if name is None:
            return

        self._client.call('drumHit', self._roomId, name)

    def on_after_close(self):
        self._client.disable()

