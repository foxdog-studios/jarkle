#!/bin/bash

set -o errexit
set -o nounset


# =============================================================================
# = Helpers                                                                   =
# =============================================================================

abort() {
    echo "$@"
    exit 1
}


# =============================================================================
# = Command line interface                                                    =
# =============================================================================

usage() {
    abort '
    Usage:

        mrt-production.sh [SETTINGS] [ACTION]
'
}

if [[ $# != 2 ]]; then
    usage
fi

meteor_setings=$(realpath -- "$1")
export METEOR_SETINGS="${meteor_setings}"
action=$2


# =============================================================================
# = Working directory                                                         =
# =============================================================================

repo=$(realpath "$(dirname "$(realpath -- "${BASH_SOURCE[0]}")")/..")
cd "$repo"


# =============================================================================
# = Git checks                                                                =
# =============================================================================

git_present() {
    git "$1" 2>&1 | grep "${@:2}"
}

if ! git_present branch '* master'; then
    abort 'Not on master branch, aborting!'
fi

if ! git_present pull 'Already up-to-date.'; then
    abort 'Pulled changes, aborting!'
fi

if ! git_present status 'working directory clean'; then
    abort 'Uncommited changes, aborting!'
fi

if git_present describe --regexp '-[0-9]\+-'; then
    abort 'Not on a tagged commit, aborting!'
fi

read -p 'You must push your code and tags, ok? [y/N] ' -r

if [[ $REPLY =~ ^[Yy]$ ]]; then
    git push
    git push --tags
else
    abort 'Aborting!'
fi


# =============================================================================
# = Perform action                                                            =
# =============================================================================

read -p 'This is production, are you sure? [y/N] ' -r

set +o nounset
source env/bin/activate
set -o nounset

domain=$(conf "$meteor_setings" site domain)
password=$(conf "$meteor_setings" site password)

if [[ $REPLY =~ ^[Yy]$ ]]; then
    expect -c "
        set timeout -1
        spawn ./scripts/mrt.sh $action $domain
        expect \"Password:\"
        send \"$password\r\"
        expect eof
    "
fi

