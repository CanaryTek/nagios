#
# Author:: Miguel Armas <kuko@canarytek.com>
# Based on server.rb
# Cookbook Name:: nagios
# Recipe:: nsca_ng_server
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

# Icinga repo
yum_repository "icinga" do
  description "Icinga (Nagios) repo for RHEL/CentOS"
  url "http://packages.icinga.org/epel/$releasever/release/"
  gpgkey "http://packages.icinga.org/icinga.key"
  enabled true
  priority "5"
  action :add
end

# install nsca-ng service from package
package "nsca-ng-server" do
  action :install
end

directory "/var/run/nsca-ng" do
  owner node['nagios']['user']
  group node['nagios']['group']
end

directory "/etc/nsca-ng.d" do
  owner node['nagios']['user']
  group node['nagios']['group']
  mode 0770
end

template "/etc/nsca-ng.cfg" do
  source "nsca-ng.cfg.erb"
  owner node['nagios']['user']
  group node['nagios']['group']
  mode 0660
  notifies :restart, 'service[nsca-ng]'
end

service "nsca-ng" do
  service_name node['nagios']['nsca_server']['service_name']
  supports :status => true, :restart => true, :reload => true
  action [ :enable, :start ]
end

