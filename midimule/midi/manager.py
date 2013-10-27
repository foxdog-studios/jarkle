from __future__ import absolute_import
from __future__ import division
from __future__ import print_function

import logging

import pygame.midi

from midimule.midi.device_manager import DeviceManager


logger = logging.getLogger(__name__)

class MidiManager(object):
    def __init__(self):
        self._ctx_count = 0
        self._device_manger = None

    def __enter__(self):
        self._ctx_count += 1
        if self._ctx_count == 1:
            logger.debug('Initializing pygame MIDI module')
            pygame.midi.init()
            self._device_manger = DeviceManager()
        return self._device_manger

    def __exit__(self, type_, value, traceback):
        self._ctx_count -= 1
        if self._ctx_count == 0:
            logger.debug("Cleaning up pygame's MIDI module")
            try:
                self._device_manger = None
                pygame.midi.quit()
            except:
                logger.exception("Failed to clean up pygame's MIDI module")

