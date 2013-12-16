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

if [[ "${#}" -ne 0 ]]; then
    echo '
    Start a SSH session on the staging virtual machine

    Usage:

        $ staging-ssh.sh
'
    exit 1
fi

./scripts/staging-start.sh
ssh "admin@${VM_HOST_NAME}"

