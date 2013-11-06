#!/bin/bash

set -o errexit
set -o nounset


# =============================================================================
# = Command line interface                                                    =
# =============================================================================

usage() {
    echo '
    Build kar

    Usage:

        build.sh
'
    exit 1
}

while getopts : opt; do
    case "${opt}" in
        \?|*) usage ;;
    esac
done

shift $(( OPTIND - 1 ))

if [[ "${#}" != 0 ]]; then
    usage
fi


# =============================================================================
# = Configuration                                                             =
# =============================================================================

repo=$(realpath "$(dirname "$(realpath -- "${BASH_SOURCE[0]}")")/..")

name=bundle
bundle=${repo}/${name}.tar.gz


# =============================================================================
# = Helpers                                                                   =
# =============================================================================

rmf() {
    rm --force --recursive "${@}"
}


# =============================================================================
# = Build                                                                     =
# =============================================================================

cd -- "${repo}"

# Remove old bundle
rmf bundle

# Create bundle
./scripts/mrt.sh bundle "${bundle}"

# Unbundle
tar --extract --file "${bundle}"

# Reinstall fibers
cd "${name}/programs/server/node_modules"
rmf fibers
npm install fibers

