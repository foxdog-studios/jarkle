#!/bin/bash

set -o errexit
set -o nounset

repo=$(realpath "$(dirname "$(realpath -- "${BASH_SOURCE[0]}")")/..")

$repo/scripts/bower-install.sh

cd "$repo/jarkle"

if [[ ! -v METEOR_SETTINGS ]]; then
    METEOR_SETTINGS=$repo/conf/site/development-settings.json
fi

mrt --settings "$METEOR_SETTINGS" $@

