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


from __future__ import absolute_import
from __future__ import division
from __future__ import print_function

from cStringIO import StringIO
import json
import os
import posixpath
import pipes

from fabric.api import *
from fabric.contrib.project import rsync_project
from fabric.contrib import *

MONGODB_CONF = '''
bind_ip = 127.0.0.1
quiet = true
dbpath = /var/lib/mongodb
logpath = /var/log/mongodb/mongod.log
logappend = true
'''

NGINX_PATH = '/opt/nginx'

NGINX_CONF_PATH = posixpath.join(NGINX_PATH, 'conf')

NGINX_SITES_AVAILABLE_PATH = posixpath.join(NGINX_CONF_PATH, 'sites-available')
NGINX_SITES_ENABLED_PATH = posixpath.join(NGINX_CONF_PATH, 'sites-enabled')

NGINX_METEOR_SERVER = '''
server
{
    server_name             %(server_name)s;
    root                    /var/www/%(server_name)s/bundle/public;

    charset utf-8;

    passenger_enabled       on;
    passenger_set_cgi_param MONGO_URL mongodb://localhost:27017/jarkle;
    passenger_set_cgi_param ROOT_URL http://%(server_name)s;
    passenger_set_cgi_param METEOR_SETTINGS '%(meteor_settings)s';
}
'''.strip()

# =============================================================================
# = Helpers                                                                   =
# =============================================================================

def escape(*args):
    return tuple(pipes.quote(str(arg)) for arg in args)


def test(command, use_sudo=False):
    executor = sudo if use_sudo else run
    with warn_only():
        res = executor(command)
    return res.return_code == 0


def build_conf(schema):
    conf = {}
    for section_name, field_names in schema.iteritems():
        in_section = env.conf[section_name]
        conf[section_name] = out_section = {}
        for field_name in field_names:
            out_section[field_name] = in_section[field_name]
    return conf

def put_string(string, remote_path=None, use_sudo=False,
        mirror_local_mode=False, mode=None):
    string = StringIO(string)
    put(string, remote_path=remote_path, use_sudo=use_sudo,
            mirror_local_mode=mirror_local_mode, mode=mode)


# =============================================================================
# = Tasks                                                                     =
# =============================================================================

env.user = 'admin'

with open(os.environ['FDS_CONF']) as conf_file:
    env.conf = json.load(conf_file)


@task
def deploy():
    deploy_site()
    configure_nginx()


@task
def configure_nginx():
    nginx_create_meteor_server()

@task
def deploy_site():
    bundle_build()
    bundle_put()
    bundle_deploy()

def get_conf_from_template(conf_template):
    schema = {
        'public': [
            'allowAllPlayersOnStart',
            'automaticRoomIds',
            'background',
            'inc',
            'incAxis',
            'isInGFunkMode',
            'particleTexture',
            'rooms',
            'trailHeadConf',
            'useCustomNoteMap',
        ],
    }
    return conf_template % {
        'server_name': env.conf['server']['name'],
        'meteor_settings': json.dumps(build_conf(schema),
                                      separators=(',', ':')),
    }

def create_site_available(conf_template, site_name=None):
    server_name = env.conf['server']['name']
    if site_name is not None:
        subdomain_name = '%(site_name)s.%(server_name)s' % {
            'site_name': site_name,
            'server_name': server_name,
        }
    else:
        subdomain_name = server_name
    conf_path = posixpath.join(NGINX_SITES_AVAILABLE_PATH, subdomain_name)
    conf = get_conf_from_template(conf_template)
    put_string(conf, conf_path, use_sudo=True)
    print(subdomain_name)
    sudo('ln --force --symbolic %s %s' %
        (conf_path, posixpath.join(NGINX_SITES_ENABLED_PATH, subdomain_name)))

@task
def nginx_create_meteor_server():
    create_site_available(NGINX_METEOR_SERVER)
    sudo('systemctl restart nginx.service')

@task
def bundle_build():
    local('cd jarkle && mrt bundle ../bundle.tar.gz')

@task
def bundle_deploy():
    run('rm -fr bundle')
    run('tar xf bundle.tar.gz')
    run('mkdir -p bundle/programs/server/node_modules')
    with cd('bundle'):
        # Passenger wants it called app.js
        run('mv main.js app.js')
        # Passenger wants a public folder
        run('mkdir -p public')
        run('mkdir -p tmp')
    with cd('bundle/programs/server/node_modules'):
        run('rm -rf fibers')
        run('npm install fibers@1.0.1')
    sudo('rm -fr /home/fds/bundle')
    server_dir = posixpath.join('/var/www/', env.conf['server']['name'])
    sudo('mkdir -p %s' % server_dir)
    sudo('rm -rf %s' % (posixpath.join(server_dir, 'bundle')))
    sudo('mv bundle %s' %  (server_dir))


@task
def bundle_put():
    put('bundle.tar.gz', 'bundle.tar.gz')

