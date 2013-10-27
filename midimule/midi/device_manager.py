from __future__ import absolute_import
from __future__ import division
from __future__ import print_function

from midimule.midi.input_device import InputMidiDevice


class DeviceManager(object):
    def get_input_device(self, device_id):
        return InputMidiDevice(device_id)

