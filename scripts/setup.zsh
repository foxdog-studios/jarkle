#!/usr/bin/env zsh

setopt ERR_EXIT
setopt NO_UNSET


# ==============================================================================
# = Configuration                                                              =
# ==============================================================================

# Paths

repo=$(realpath -- ${0:h}/..)

venv=$repo/local/venv

pacman_packages=(
    git
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
    if (( ! $+commands[meteor] )); then
       curl https://install.meteor.com | /bin/sh
    fi
}

function create_virtualenv()
{
    virtualenv --python=python2.7 $venv
}

function install_python_packages()
{
    unsetopt NO_UNSET
    source $venv/bin/activate
    setopt NO_UNSET

    pip install --requirement $repo/requirements.txt
}

function init_config()
{
    local config=$repo/config
    local development=$config/development

    mkdir --parents $development

    if [[ ! -d $development ]]; then
        cp --recursive $confif/template $development
    fi

    if [[ ! -e $config/default ]]; then
        $repo/scripts/config.zsh development
    fi
}


# ==============================================================================
# = Command line interface                                                     =
# ==============================================================================

tasks=(
    install_pacman_packages
    install_meteor
    create_virtualenv
    install_python_packages
    init_config
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
		    create_virtualenv
		    install_python_packages
		    init_config
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

