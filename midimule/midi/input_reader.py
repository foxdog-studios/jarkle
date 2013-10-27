from __future__ import absolute_import
from __future__ import division
from __future__ import print_function

class InputReader(object):
    def __init__(self, device):
        self._buffer = []
        self._device = device

    def try_read(self):
        for attempt in xrange(2):
            if self._buffer:
                return self._buffer.pop(0)
            self._buffer.extend(self._device.read(128))

