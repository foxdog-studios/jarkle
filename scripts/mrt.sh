#!/usr/bin/env bash

set -o errexit
set -o nounset

repo=$(realpath "$(dirname "$(realpath -- "${BASH_SOURCE[0]}")")/..")

"$repo/scripts/bower-install.sh" > /dev/null

if [[ -v METEOR_SETTINGS ]]; then
    METEOR_SETTINGS=$(realpath "$METEOR_SETTINGS")
else
    METEOR_SETTINGS=$repo/conf/site/development-settings.json
fi

if [[ $# -eq 0 ]]; then
    args=( --settings "$METEOR_SETTINGS" )
else
    args=( "$@" )
fi

cd "$repo/jarkle"
exec mrt "${args[@]}"

