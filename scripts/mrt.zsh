#!/usr/bin/env zsh

setopt err_exit
setopt no_unset

repo=$(realpath -- ${0:h}/..)

if [[ $# -eq 0 ]]; then
    args=( --settings $repo/local/config/default/meteor_settings.json )
else
    args=( $@ )
fi

cd $repo/src
exec mrt $args

