#
# Author:: Miguel Armas <kuko@canarytek.com>
# Based on server.rb
# Cookbook Name:: nagios
# Recipe:: nrpe_proxy
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

# install nsca service either from source of package
include_recipe "nagios::client"

package "nagios-plugins-nrpe" do
  action :install
end

template "#{node['nagios']['nrpe']['conf_dir']}/nrpe.d/check_remote.cfg" do
  source "nrpe_check_remote.cfg.erb"
end

