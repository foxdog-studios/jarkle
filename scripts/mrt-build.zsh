#!/usr/bin/env zsh

setopt ERR_EXIT
setopt NO_UNSET


# =============================================================================
# = Command line interface                                                    =
# =============================================================================

function usage()
{
    cat <<-'EOF'
		Build the Meteorite application.

		Usage:

			mrt-bundle.zsh
	EOF
    exit 1
}

if [[ $# -ne 0 ]]; then
    usage
fi


# =============================================================================
# = Configuration                                                             =
# =============================================================================

repo=$(realpath -- ${0:h}/..)
bundle_name=bundle
build_dir=$repo/local/build
bundle_archive=$build_dir/$bundle_name.tgz
bundle_dir=$build_dir/$bundle_name


# =============================================================================
# = Build                                                                     =
# =============================================================================

# Remove old build
rm --force --recursive $build_dir
mkdir --parents $build_dir

cd $build_dir

# Create bundle
$repo/scripts/mrt.zsh bundle $bundle_archive

# Unbundle
tar --extract --file $bundle_archive

