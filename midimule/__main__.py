from __future__ import absolute_import
from __future__ import division
from __future__ import print_function

from argparse import ArgumentParser
from collections import OrderedDict
import logging
import os
import sys


LOG_LEVELS = (
    logging.CRITICAL,
    logging.ERROR,
    logging.WARNING,
    logging.INFO,
    logging.DEBUG
)

LOG_LEVEL_TO_NAMES = OrderedDict((level, logging.getLevelName(level).lower())
                                 for level in LOG_LEVELS)
LOG_NAME_TO_LEVEL = OrderedDict((name, level)
                                for level, name in LOG_LEVEL_TO_NAMES.items())


def build_argument_parser():
    parser = ArgumentParser()
    parser.add_argument('-l', '--log-level', choices=LOG_NAME_TO_LEVEL.keys(),
                        default=LOG_LEVEL_TO_NAMES[logging.INFO])
    parser.add_argument('-d', '--device-id', type=int)
    return parser


def main(argv=None):
    global logger

    if argv is None:
        argv = sys.argv
    args = build_argument_parser().parse_args(args=argv[1:])

    logging.basicConfig(
            datefmt='%H:%M:%S',
            format='[%(levelname).1s %(asctime)s] %(message)s',
            level=LOG_NAME_TO_LEVEL[args.log_level])
    logger = logging.getLogger(__name__)

    from midimule.midi import get_midi_manager
    from midimule.midi import util

    with get_midi_manager() as manager:

        if args.device_id:
            device_id = args.device_id
        else:
            device_id = util.request_input_device_id()

        with manager.get_input_device(device_id) as input_device:
            print(input_device)

    return 0


if __name__ == '__main__':
    try:
        return_code = main()
    except KeyboardInterrupt:
        return_code = 1
    exit(return_code)

