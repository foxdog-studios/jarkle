#!/usr/bin/bashir

# Copyright 2013 Foxdog Studios Ltd
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

source _staging-common.sh

function usage
{
    echo '
    Start the staging virtual machine

    Usage:

        $ staging-start.sh [-i] [-- VirtualBox_args...]

    -i  start with a headed (as opposed to headless) interface
'
    exit 1
}

headed_interface=false

while getopts :i opt; do
    case "${opt}" in
        i) headed_interface=true ;;
        \?|*) usage ;;
    esac
done
unset opt

shift $(( $OPTIND - 1 ))

unset usage

if $headed_interface; then
    cmd='VBoxSDL'
    wait_for=false
else
    cmd='VBoxHeadless'
    wait_for=true
fi
unset headed_interface

${cmd} --startvm "${VM_NAME}" "${@}" &> /dev/null & disown

if $wait_for; then
    echo "Pinging ${VM_HOST_NAME}..."
    while ! ping -c 1 "${VM_HOST_NAME}" &> /dev/null; do
        sleep 1
    done
fi
unset wait_for

