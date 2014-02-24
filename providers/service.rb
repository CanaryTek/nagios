#
# Cookbook Name:: nagios
# Provider:: service
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

def whyrun_supported?
  true
end

#use_inline_resources

action :add do
  args=Hash.new()

  [:id,:host_name].each do |n|
    args[n]=new_resource.send(n)
  end

  # Set defaults
  args[:host_name] ||= node['nagios_name']
  args[:description] ||= args[:id]
  args[:service_template] ||= "default-service"

  # Handle optional arguments
  Chef::Resource::NagiosService::ARGS.each do |arg|
     args[arg] = new_resource.send(arg) if new_resource.send(arg)
  end
  converge_by("Defining nagios service #{new_resource.id}") do

    # Make sure one off command_line or use_existing_command is defined
    if new_resource.send(:command_line) or new_resource.send(:use_existing_command) 
      node.set['nagios']['services'][new_resource.id] = args
    else
      Chef::Log.error("You need to define either one of :command_line or :use_existing_command")
    end
  end
end

action :remove do
  converge_by("Removing nagios service #{new_resource.id}") do
    node.set['nagios']['services'].delete(new_resource.id)
  end
end

