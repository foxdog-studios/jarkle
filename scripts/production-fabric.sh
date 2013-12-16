#!/usr/bin/bashir

source _production-common.sh

read -p "This is production. Are you sure? [y/N] " -r
if [[ $REPLY =~ ^[Yy]$ ]]; then
    # Into the danger zone.
    ./scripts/tools-fabric.sh "${@}"
else
    echo 'aborting.'
fi
