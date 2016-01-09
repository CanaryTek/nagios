#
# Author:: Miguel Armas <kuko@canarytek.com>
# Based on client_software by Seth Chisamore <schisamo@opscode.com>
# Cookbook Name:: nagios
# Recipe:: nsca_server_source
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

include_recipe "build-essential"

pkgs = value_for_platform_family(
    ["rhel","fedora"] => %w{ libmcrypt-devel },
    "debian" => %w{ libmcrypt-dev },
    "default" => %w{ libmcrypt-dev }
  )

pkgs.each do |pkg|
  package pkg do
    action :install
  end
end

user node['nagios']['user'] do
  system true
end

group node['nagios']['group'] do
  members [ node['nagios']['user'] ]
end

nsca_version = node['nagios']['nsca']['version']

remote_file "#{Chef::Config[:file_cache_path]}/nsca-#{nsca_version}.tar.gz" do
  source "#{node['nagios']['nsca']['url']}/nsca-#{nsca_version}.tar.gz"
  #checksum node['nagios']['nsca']['checksum']
  action :create_if_missing
end

bash "compile-nagios-nsca" do
  cwd Chef::Config[:file_cache_path]
  code <<-EOH
    tar zxvf nsca-#{nsca_version}.tar.gz
    cd nsca-#{nsca_version}
    ./configure --prefix=/usr \
                --sysconfdir=/etc \
                --localstatedir=/var 
    make -s
    install --mode 755 --owner #{node['nagios']['user']} --group #{node['nagios']['group']} src/nsca /usr/sbin
  EOH
  creates "/usr/sbin/nsca"
end

template "/etc/init.d/nagios-nsca-server" do
  source "nagios-nsca-server.erb"
  owner "root"
  group "root"
  mode  00755
end

directory node['nagios']['nsca_server']['conf_dir'] do
  owner "root"
  group "root"
  mode  00755
end

template "#{node['nagios']['nsca_server']['conf_dir']}/nsca.cfg" do
  source "nsca.cfg.erb"
  owner "root"
  group "root"
  mode  00755
end

