#!/usr/bin/env zsh

setopt ERR_EXIT
setopt NO_UNSET


# ==============================================================================
# = Command line interface                                                     =
# ==============================================================================

function usage()
{
    cat <<-'EOF'
		Build the Meteor application.

		Usage:

		    build.zsh
	EOF
    exit 1
}

if [[ $# -ne 0 ]]; then
    usage
fi


# ==============================================================================
# = Configuration                                                              =
# ==============================================================================

repo=$(realpath "$(dirname "$(realpath -- $0)")/..")
bundle_dir=$repo/local/bundle


# ==============================================================================
# = Build                                                                      =
# ==============================================================================

# Remove old build
rm --force --recursive $bundle_dir
mkdir --parents $bundle_dir:h

# Create bundle
cd $repo/src
meteor bundle --directory $bundle_dir

