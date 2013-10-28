from __future__ import absolute_import
from __future__ import division
from __future__ import print_function

import time

def jarkle(device, client):
    while True:
        e = device.try_read()
        if e:
            func, note, vel = e[0][:3]
            if func != 248:
                print(e)
                client.method_async('midiNoteOn', [note])
        else:
            time.sleep(0.1)



