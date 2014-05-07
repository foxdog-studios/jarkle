# -*- coding: utf-8 -*-

# Copyright 2014 Foxdog Studios Ltd
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

from __future__ import absolute_import
from __future__ import division
from __future__ import print_function

from cStringIO import StringIO
import json
import os
import posixpath
import re

from fabric.api import (
    cd,
    env,
    execute,
    local,
    put,
    run,
    sudo,
    task,
)

import yaml


# =============================================================================
# = Configuration                                                             =
# =============================================================================

# = External configuration ====================================================

def load_config(config_name, config_format):
    config_dir = os.environ.get('JARKLE_CONFIG_DIR', 'local/config/default')
    with open(os.path.join(config_dir, config_name)) as config_file:
        return config_format.load(config_file)

config = load_config('fabric.yaml', yaml)
meteor_settings = load_config('meteor_settings.json', json)


# = Module configuration ======================================================

def site_path(site_type):
    return posixpath.join(
        '/etc/nginx',
        'sites-{}'.format(site_type),
        config['jarkle']['server_name'],
    )

site_available_path = site_path('available')
site_enabled_path = site_path('enabled')


# = Fabric environment configuration ==========================================

if not env.hosts:
    env.hosts.append(config['host']['name'])

if not env.password:
    env.password = config['host']['password']


# =============================================================================
# = Tasks                                                                     =
# =============================================================================

@task(default=True)
def deploy(start=None, stop=None):
    subtasks = [
        bundle,        # 1
        put_bundle,    # 2
        deploy_bundle, # 3
        create_site,   # 4
        reload_nginx,  # 5
    ]

    if start is None:
        start = 0
    else:
        start = int(start) - 1

    if stop is None:
        stop = len(subtasks)
    else:
        stop = int(stop)

    for subtask in subtasks[start:stop]:
        execute(subtask)


@task
def bundle():
    local('scripts/mrt-build.zsh')


@task
def put_bundle():
    put('local/build/bundle.tgz', 'bundle.tgz')


@task
def deploy_bundle():
    local('scripts/mrt-build.zsh')
    put('local/build/bundle.tgz', '')
    run('rm --force --recursive bundle')
    run('tar --extract --file bundle.tgz')
    with cd('bundle'):
        run('mv main.js app.js')
        run('mkdir public tmp')
    with cd('bundle/programs/server/node_modules'):
        run ('rm --force --recursive fibers')
        run('npm install fibers@1.0.1')
    www = posixpath.join('/var/www', config['jarkle']['server_name'])
    sudo('rm --force --recursive {}'.format(www))
    sudo('mkdir --parents {}'.format(www))
    sudo('mv bundle/* {}'.format(www))
    run('rmdir bundle')


@task
def create_site():
    server = margin(r'''
       |server
       |{{
       |    server_name             {server_name};
       |    root                    /var/www/{server_name}/public;
       |
       |    charset utf-8;
       |
       |    passenger_enabled       on;
       |    passenger_set_cgi_param MONGO_URL mongodb://localhost:27017/jarkle;
       |    passenger_set_cgi_param ROOT_URL http://{server_name};
       |    passenger_set_cgi_param METEOR_SETTINGS '{meteor_settings}';
       |}}
    ''').format(
        meteor_settings=json.dumps(meteor_settings),
        server_name=config['jarkle']['server_name'],
    )

    puts(server, site_available_path, use_sudo=True)
    sudo('ln --force --symbolic --no-target-directory {} {}'.format(
        site_available_path,
        site_enabled_path,
    ))


@task
def reload_nginx():
    sudo('systemctl reload nginx.service')


# =============================================================================
# = Helpers                                                                   =
# =============================================================================

def margin(text):
    return re.sub(r'^ *\|', '', text, flags=re.MULTILINE).strip()


def puts(string, remote_path=None, use_sudo=False):
    return put(
        local_path=StringIO(string),
        remote_path=remote_path,
        use_sudo=use_sudo,
    )

