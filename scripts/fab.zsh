#!/usr/bin/env zsh

repo=$(realpath -- $0:h:h)
source $repo/local/venv/bin/activate
exec fab --fabfile=$repo/fabfile.py $@

