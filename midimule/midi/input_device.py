from __future__ import absolute_import
from __future__ import division
from __future__ import print_function

import logging
import os
import sys

import pygame.midi

from midimule.midi.input_reader import InputReader

logger = logging.getLogger(__name__)

class InputMidiDevice(object):
    def __init__(self, device_id):
        self._device = None
        self._device_id = device_id

    def __enter__(self):
        if self._device is not None:
            raise ValueError('device is already open')
        logger.debug('Opening input MIDI device %d', self._device_id)
        self._device = pygame.midi.Input(self._device_id)
        return InputReader(self._device)

    def __exit__(self, type_, value, traceback):
        logger.debug('Closing input MIDI device %d', self._device_id)
        try:
            stderr = sys.stderr
            with open(os.devnull, 'w') as devnull:
                try:
                    sys.stderr = devnull
                    self._device.close()
                finally:
                    sys.stderr = stderr
        except:
            logging.exception('Failed to close input MIDI device %d',
                              self._device_id)
        finally:
            self._device = None

