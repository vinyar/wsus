# Cookbook Name:: ad
# Recipe:: default
# Author:: Bryan McLellan <btm@loftninjas.org>
#
# Copyright 2010, Opscode, Inc
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

# begin
#   ad = Chef::DataBagItem.load(:ad, :main)
# rescue
#   Chef::Log.fatal("Could not find the 'main' item in the 'ad' data bag")
#   raise
# end

# Install the 'role' for Active Directory
#   This is a pre-flight step that installs the software but doesn't configure AD
#   This is an idempotent step, but returns 1003 (235?) if already installed.


# include_recipe "windows"



ad_domain_controller "install AD role" do
  action :install
end


ad_domain_controller node['ad']['domain_name'] do
  action :configure
  type node['ad']['type']

  notifies :request, 'windows_reboot[60]'
  # require "pry";binding.pry
  # not_if {reboot_pending?}
end


windows_reboot 60 do
  reason 'cause chef said so'
  # action :request
  action :nothing
  # only_if {reboot_pending?}

end

# fix syntax
# notify "reboot" do
# 	only_if {reboot_pending?}
# 	notify windows_reboot
# 	action :nothing
# end
