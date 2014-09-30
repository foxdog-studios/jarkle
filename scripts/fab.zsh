#!/usr/bin/env zsh

repo=$(realpath "$(dirname "$(realpath -- $0)")/..")
source $repo/local/venv/bin/activate
exec fab --fabfile=$repo/tools/fabfile.py $@

