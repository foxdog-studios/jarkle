#!/bin/bash

set -o errexit
set -o nounset

function usage
{
    echo "
    Usage:

        # $(basename "${0}") <settings> <action>
"
    exit 1
}

if [[ "${#}" < 1 ]]; then
    usage
fi

export METEOR_SETINGS="$(realpath -- "${1}")"

REPO=$(realpath "$(dirname "$(realpath -- "${BASH_SOURCE[0]}")")/..")
cd -- "${REPO}"

if [[ ! $(git branch | grep '* master') ]]; then
    echo 'Not on master branch, aborting!'
    exit 1
fi

if [[ ! $(git pull | grep 'Already up-to-date.') ]]; then
    echo 'Pulled changes, aborting!'
    exit 1
fi

if [[ ! $(git status | grep 'working directory clean') ]]; then
    echo 'Uncommited changes, aborting!'
    exit 1
fi

if [[ $(git describe | grep --regexp '-[0-9]\+-') ]]; then
    echo 'Not on a tagged commit, aborting!'
    exit 1
fi

read -p "This requires you to push your code and tags, ok?  [y/N]" -r
if [[ $REPLY =~ ^[Yy]$ ]]; then
    # Into the danger zone.
    git push
    git push --tags
else
    echo 'aborting.'
    exit 1
fi

set +o nounset
source env/bin/activate
set -o nounset

DOMAIN=$(conf "${METEOR_SETINGS}" site domain)
PASSWORD=$(conf "${METEOR_SETINGS}" site password)

read -p "This is production. Are you sure? [y/N]" -r
if [[ $REPLY =~ ^[Yy]$ ]]; then
    # Into the danger zone.
    expect -c "
        set timeout -1
        spawn ./scripts/meteor.sh ${2} ${DOMAIN}
        expect \"Password:\"
        send \"${PASSWORD}\r\"
        expect eof
    "
fi

