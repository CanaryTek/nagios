#
# Author:: Miguel Armas <kuko@canarytek.com>
# Cookbook Name:: nagios
# Attributes:: nsca_server
#
# Copyright 2013, CanaryTek
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
#

case node['platform_family']
when 'debian'
  default['nagios']['nsca_server']['install_method'] = 'package'
  default['nagios']['nsca_server']['pidfile'] = '/var/run/nagios/nsca.pid'
when 'rhel','fedora'
  default['nagios']['nsca_server']['install_method'] = 'source'
  default['nagios']['nsca_server']['pidfile'] = '/var/run/nsca.pid'
else
  default['nagios']['nsca_server']['install_method'] = 'source'
  default['nagios']['nsca_server']['pidfile'] = '/var/run/nrpe.pid'
end

default['nagios']['nsca_server']['conf_dir']           = '/etc/nagios'
default['nagios']['nsca_server']['port']               = '5667'
default['nagios']['nsca_server']['service_name']       = 'nagios-nsca-server'

## Decription options (see nsca.cfg.erb template)
default['nagios']['nsca_server']['password']           = ''
default['nagios']['nsca_server']['decryption_method']  = '1'

# for plugin from source installation
#default['nagios']['plugins']['url']      = 'http://prdownloads.sourceforge.net/sourceforge/nagiosplug'
#default['nagios']['plugins']['version']  = '1.4.16'
#default['nagios']['plugins']['checksum'] = 'b0caf07e0084e9b7f10fdd71cbd3ebabcd85ad78df64da360b51233b0e73b2bd'

# for nrpe from source installation
default['nagios']['nsca']['url']      = 'http://prdownloads.sourceforge.net/sourceforge/nagios'
default['nagios']['nsca']['version']  = '2.9.1'
default['nagios']['nsca']['checksum'] = '7b3f569fa77a364bd016d87b865c5572d954e41a'

default['nagios']['server_role'] = 'monitoring'
