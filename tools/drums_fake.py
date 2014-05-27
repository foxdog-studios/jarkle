#!/usr/bin/env python

from __future__ import absolute_import
from __future__ import division
from __future__ import print_function

from argparse import ArgumentParser
from collections import OrderedDict
import logging
import os
import sys
import termios
import tty

import ddp


LOG_LEVELS = (
    logging.CRITICAL,
    logging.ERROR,
    logging.WARNING,
    logging.INFO,
    logging.DEBUG
)

LOG_LEVEL_TO_NAMES = OrderedDict(
    (level, logging.getLevelName(level).lower()) for level in LOG_LEVELS
)

LOG_NAME_TO_LEVEL = OrderedDict(
    (name, level) for level, name in LOG_LEVEL_TO_NAMES.items()
)


def main(argv=None):
    args = parse_argv(argv)
    config_logging(args)

    print('\n'.join(map(str.strip, r'''
       +-----+---------------+
       | Key | Drum          |
       +-----+---------------+
       | a   | Hi-hat stamp  |
       | c   | Crash cymbal  |
       | h   | Hi-hat closed |
       | k   | Kick          |
       | o   | Hi-hat open   |
       | p   | Hi-hat pedal  |
       | r   | Ride cymbal   |
       | s   | Snare         |
       | t   | High tom      |
       | u   | Low tom       |
       | y   | Mid tom       |
       +-----+---------------+

       Press 'q' to quit
    '''.split('\n'))))

    client = ddp.DdpClient(args.server_url)

    fd = sys.stdin.fileno()
    old_settings = termios.tcgetattr(fd)

    try:
        client.enable()
        tty.setraw(fd)
        fake_drums(client, args.room_id)
    finally:
        try:
            termios.tcsetattr(fd, termios.TCSADRAIN, old_settings)
        except:
            pass
        try:
            client.disable()
        except:
            pass

    return 0


def parse_argv(argv=None):
    if argv is None:
        argv = sys.argv
    parser = ArgumentParser()
    parser.add_argument('-l', '--log-level', choices=LOG_NAME_TO_LEVEL.keys(),
                        default=LOG_LEVEL_TO_NAMES[logging.INFO])
    parser.add_argument('-s', '--server-url', default='127.0.0.1:3000')
    parser.add_argument('room_id')
    return parser.parse_args(args=argv[1:])


def config_logging(args):
    global logger
    logging.basicConfig(
        datefmt='%H:%M:%S',
        format='[%(levelname).1s %(asctime)s] %(message)s',
        level=LOG_NAME_TO_LEVEL[args.log_level]
    )
    logger = logging.getLogger(__name__)


def fake_drums(client, room_id):
    next_id = 0

    while True:
        c = sys.stdin.read(1)
        if c == 'q':
            break

        name = {
            'a': 'hi-hat stamp',
            'c': 'crash',
            'h': 'hi-hat closed',
            'k': 'kick',
            'o': 'hi-hat open',
            'p': 'hi-hat pedal',
            'r': 'ride',
            's': 'snare',
            't': 'high tom',
            'u': 'low tom',
            'y': 'mid tom',
        }.get(c)

        if not name:
            continue

        client.call('drumHit', room_id, name)


if __name__ == '__main__':
    try:
        return_code = main()
    except KeyboardInterrupt:
        return_code = 1
    exit(return_code)

