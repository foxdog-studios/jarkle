#!/usr/bin/env zsh

setopt ERR_EXIT
setopt NO_UNSET

repo=$(realpath "$(dirname "$(realpath -- $0)")/..")

cd $repo/src
exec mrt $@

