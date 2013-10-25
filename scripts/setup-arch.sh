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

# Install system packages
sudo pacman --needed --noconfirm --sync --refresh \
    expect \
    nodejs

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

