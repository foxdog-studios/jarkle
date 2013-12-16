set -o errexit
set -o nounset

cd ..

set +o nounset
source env/bin/activate
set -o nounset

readonly REPO="$(realpath .)"

function conf {
    command conf "${FDS_CONF}" ${@}
}

function set_default_conf
{
    if [[ ! -v FDS_CONF ]]; then
        export FDS_CONF=conf/site/development-settings.json
    fi
}

