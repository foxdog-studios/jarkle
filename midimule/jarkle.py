from __future__ import absolute_import
from __future__ import division
from __future__ import print_function

import time

def jarkle(device, client):
    while True:
        e = device.try_read()
        if e:
            func, note, vel = e[0][:3]
            # Ignore Yamaha DTXPLORER click and 0 velocity second notes
            # and high hat pedal
            if func != 248 and func != 185 and vel != 0:
                print(e)
                client.method_async('midiNoteOn', [note])
        else:
            time.sleep(0.1)



