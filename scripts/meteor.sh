#!/usr/bin/bashir

set -o errexit
set -o nounset

cd ../jarkle

if [[ "${#}" == 0 ]]; then
    args=run
else
    args="${@}"
fi

if [[ ! -v METEOR_SETINGS ]]; then
    METEOR_SETINGS=../conf/site/development-settings.json
fi

mrt --settings "${METEOR_SETINGS}" ${args[@]}

