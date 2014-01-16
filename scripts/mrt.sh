#!/usr/bin/env bash

set -o errexit
set -o nounset

repo=$(realpath "$(dirname "$(realpath -- "${BASH_SOURCE[0]}")")/..")

"$repo/scripts/bower-install.sh" > /dev/null

cd "$repo/jarkle"

if [[ ! -v METEOR_SETINGS ]]; then
    METEOR_SETINGS=$repo/conf/site/development-settings.json
fi

if [[ $# -eq 0 ]]; then
    args=( --settings "$METEOR_SETINGS" )
else
    args=( "$@" )
fi

exec mrt "${args[@]}"

