from __future__ import absolute_import
from __future__ import division
from __future__ import print_function

from collections import namedtuple

import pygame.midi


MidiDeviceInfo = namedtuple('MidiDeviceInfo', ('device_id', 'interface', 'name',
                                               'is_input', 'is_output',
                                               'is_opened'))


def get_midi_device_info(device_id):
    interface, name, is_input, is_output, is_opened = \
            pygame.midi.get_device_info(device_id)
    is_input = bool(is_input)
    is_output = bool(is_output)
    is_opened = bool(is_opened)
    return MidiDeviceInfo(device_id, interface, name, is_input, is_output,
                          is_opened)


def get_midi_devices_info():
    for device_id in xrange(pygame.midi.get_count()):
        yield get_midi_device_info(device_id)


def get_input_midi_devices_info():
    for device_info in get_midi_devices_info():
        if device_info.is_input:
            yield device_info


def get_output_midi_devices_info():
    for device_info in get_midi_devices_info():
        if device_info.is_output:
            yield device_info


def request_input_device_id():
    return _request_device_id(list(get_input_midi_devices_info()))


def request_output_device_id():
    return _request_device_id(list(get_output_midi_devices_info()))


def _request_device_id(devices_info):
    devices_id = list(str(device_info.device_id)
                      for device_info in devices_info)
    devices_name = list(device_info.name for device_info in devices_info)
    id_header = 'ID'
    id_len = max([len(device_id) for device_id in devices_id]
                 + [len(id_header)])
    name_header = 'Name'
    name_len = max([len(device_name) for device_name in devices_name]
                   + [len(name_header)])
    fmt = '{0:{1}} {2:{3}}'
    header = fmt.format(id_header, id_len, name_header, name_len)
    devices = []
    for device_info in devices_info:
        devices.append(fmt.format(device_info.device_id, id_len,
                                  device_info.name, name_len))
    table = '\n'.join([header, '-' * len(header)] + devices)
    print(table, end='\n\n')
    ids = set(device_info.device_id for device_info in devices_info)
    while True:
        valid = True
        try:
            device_id = int(raw_input('Device ID: '))
        except ValueError:
            valid = False
        else:
            valid = device_id in ids
        if valid:
            return device_id
        print('Invalid device ID, please try again.')

