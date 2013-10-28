#!/bin/bash

set -o errexit
set -o nounset

repo=$(realpath "$(dirname "$(realpath -- "${BASH_SOURCE[0]}")")/..")
cd -- "${repo}"

set +o nounset
source env/bin/activate
set -o nounset

export PYTHONPATH=${PYTHONPATH:+${PYTHONPATH}:}${repo}/src
python -m midimule "$@"
