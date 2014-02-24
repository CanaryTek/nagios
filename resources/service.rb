#
# Author:: Kuko Armas
# Cookbook Name:: nagios
# Resource:: service
#
# Copyright 2014, CanaryTek
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

actions :add, :remove

# Service id
attribute :id, :kind_of => String, :name_attribute => true

# host_name deafult is set in provider, because here we don't have access to host attributes
attribute :host_name, :kind_of => String

# For some reason, this default definition is not working. Default is also set in provider
attribute :service_template, :kind_of => String, :default => "default-service"

# Optional args
ARGS= %w{command_line use_existing_command hostgroup_name active_checks_enabled passive_checks_enabled parallelize_check obsess_over_service check_freshness freshness_threshold notifications_enabled event_handler_enabled flap_detection_enabled failure_prediction_enabled process_perf_data retain_status_information retain_nonstatus_information is_volatile check_period max_check_attempts check_interval retry_interval contacts contact_groups notification_options notification_period notes_url action_url servicegroups}

ARGS.each do |arg|
  attribute arg.to_sym, :kind_of => String
end

def initialize(*args)
  super
  @action = :add
end

