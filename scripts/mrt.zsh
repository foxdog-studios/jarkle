#!/usr/bin/env zsh

setopt err_exit
setopt no_unset

repo=$(realpath -- ${0:h}/..)

if (( $+METEOR_SETTINGS )); then
    METEOR_SETTINGS=$(realpath -- $METEOR_SETTINGS)
else
    METEOR_SETTINGS=$repo/conf/site/development-settings.json
fi

if [[ $# -eq 0 ]]; then
    args=( --settings $METEOR_SETTINGS )
else
    args=( $@ )
fi

cd $repo/jarkle
exec mrt $args

