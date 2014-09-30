#!/usr/bin/env zsh

setopt ERR_EXIT
setopt NO_UNSET


# ==============================================================================
# = Command line interface                                                     =
# ==============================================================================

function usage()
{
    cat <<-'EOF'
		Build Jarkle.

		Usage:

		    # build.zsh
	EOF
    exit 1
}

if [[ $# -ne 0 ]]; then
    usage
fi

repo=$(realpath "$(dirname "$(realpath -- $0)")/..")
build=$repo/local/build

rm --force --recursive $build
cd $repo/jarkle
meteor build $build --directory
cd $build/bundle/programs/server
npm install

