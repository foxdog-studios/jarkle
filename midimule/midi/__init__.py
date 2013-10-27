from __future__ import absolute_import
from __future__ import division
from __future__ import print_function

import logging

from midimule.midi.manager import MidiManager as _MidiManger


logger = logging.getLogger(__name__)

_midi_manager = None

def get_midi_manager():
    global _midi_manager
    if _midi_manager is None:
        logger.debug('Instantiating MidiManager singleton')
        _midi_manager = _MidiManger()
    return _midi_manager

