#!/usr/bin/env zsh

setopt ERR_EXIT
setopt NO_UNSET


# ==============================================================================
# = Configuration                                                              =
# ==============================================================================

# Paths

repo=$(realpath -- ${0:h}/..)

venv=$repo/local/venv


# Packages

global_node_packages=(
    meteorite
)

pacman_packages=(
    git
    nodejs
    python2-virtualenv
    zsh
)


# ==============================================================================
# = Tasks                                                                      =
# ==============================================================================

function install_pacman_packages()
{
    sudo pacman --noconfirm --sync --needed --refresh $pacman_packages
}

function install_meteor()
{
   curl https://install.meteor.com/ | sh
}

function install_global_node_packages()
{
    sudo --set-home npm install --global $global_node_packages
}

function install_meteorite_packages()
{(
    cd $repo/src
    mrt install
)}

function create_virtualenv()
{
    mkdir --parents $venv:h
    virtualenv --python=python2.7 $venv
}

function install_python_packages()
{
    unsetopt NO_UNSET
    source $venv/bin/activate
    setopt NO_UNSET

    pip install --requirement $repo/requirements.txt
}

function init_local()
{
    local config_dir=$repo/local/config
    local dev_dir=$config_dir/development

    mkdir --parents $dev_dir

    local config_name
    for config_name in fabric.yaml meteor_settings.json; do
        if [[ ! -e $dev_dir/$config_name ]]; then
            cp $repo/templates/$config_name $dev_dir
        fi
    done

    $repo/scripts/config.zsh development
}


# ==============================================================================
# = Command line interface                                                     =
# ==============================================================================

tasks=(
    install_pacman_packages
    install_meteor
    install_global_node_packages
    install_meteorite_packages
    create_virtualenv
    install_python_packages
    init_local
)

function usage()
{
    cat <<-'EOF'
		Set up a development environment

		Usage:

		    setup.zsh [TASK...]

		Tasks:

		    install_pacman_packages
		    install_meteor
		    install_global_node_packages
		    install_meteorite_packages
		    install_node_packages
		    create_virtualenv
		    install_python_packages
		    init_local
	EOF
    exit 1
}

for task in $@; do
    if [[ ${tasks[(i)$task]} -gt ${#tasks} ]]; then
        usage
    fi
done

for task in ${@:-$tasks}; do
    print -P -- "%F{green}Task: $task%f"
    $task
done

