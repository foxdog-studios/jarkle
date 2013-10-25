#!/bin/bash

set -o errexit
set -o nounset

function usage
{
    echo '
        Install dependencies and set up the repository

        Usage:

            $ setup-arch.sh

    '
    exit 1
}

while getopts : opt; do
    case "${opt}" in
        \?|*) usage ;;
    esac
done
unset opt

shift $(( $OPTIND - 1 ))

if [[ "${#}" !=  0 ]]; then
    usage
fi

# Change directory to the root of the repository
readonly REPO="$(
    realpath -- "$(
        dirname -- "$(
            realpath -- "${BASH_SOURCE[0]}"
        )"
    )/.."
)"

cd -- "${REPO}"

# Ensure a virtual enviroment is not activated
if which deactivate &> /dev/null; then
    deactivate
fi

# Install system packages
sudo pacman --needed --noconfirm --sync --refresh \
    expect \
    nodejs \
    python2 \
    python2-virtualenv

# Install bashir
if ! which bashir &> /dev/null; then
    cd /tmp
    git clone gitolite@foxdogstudios.com:bashir
    ./bashir/scripts/install.sh
    rm -fr bashir
    cd -- "${REPO}"
fi

# Install global nodejs packages
sudo npm install -g \
    meteorite

# Set up the virtual environment
if [[ ! -d env ]]; then
    virtualenv2 env
fi

set +o nounset
source env/bin/activate
set -o nounset

pip install -r requirements.txt

set +o nounset
deactivate
set -o nounset

