#
# Cookbook Name:: wsus
# Recipe:: default
#
# Copyright 2014, YOUR_COMPANY_NAME
#
# All rights reserved - Do Not Redistribute
#

# include_recipe "chef-dev-workstation::windows-setup"

### TODO - see if the latest version of windows cookbook allows installation of Windows Features - Refactor this to use windows feature instead of powershell
# note: for 2012 version of the recipe use DSC

#   convert_boolean_return true
# powershell_script "install_wsus_prereqs" do
#   code <<-EOH
#     Import-Module ServerManager
#     $features =
#       "web-server",
#       "Web-Asp-Net",
#       "Web-Windows-Auth",
#       "Web-Metabase",
#       "File-Services"
#     $features | foreach {if (!(Get-WindowsFeature $_).installed){add-windowsfeature $_}}
#   EOH
# end

# converting to using one resource per feature - easier to maintain/debug
features = %w{web-server Web-Asp-Net Web-Windows-Auth Web-Metabase File-Services}

features.each do | feature |
  powershell_script "installing wsus prereq - #{feature}" do
    code <<-EOH
      Import-Module ServerManager
      if (!(Get-WindowsFeature #{feature}).installed){add-windowsfeature #{feature}}
    EOH
  end
end

# windows feature dump in case server is completely blank:
# File-Services
# FS-FileServer
# Web-Server
# Web-WebServer
# Web-Common-Http
# Web-Static-Content
# Web-Default-Doc
# Web-Dir-Browsing
# Web-Http-Errors
# Web-App-Dev
# Web-Asp-Net
# Web-Net-Ext
# Web-ISAPI-Ext
# Web-ISAPI-Filter
# Web-Health
# Web-Http-Logging
# Web-Request-Monitor
# Web-Security
# Web-Windows-Auth
# Web-Filtering
# Web-Performance
# Web-Stat-Compression
# Web-Mgmt-Tools
# Web-Mgmt-Console
# Web-Mgmt-Compat
# Web-Metabase
# NET-Framework
# NET-Framework-Core
# RSAT
# RSAT-Role-Tools
# RSAT-Web-Server
# Windows-Internal-DB

# Installation of the WSUS 3.0
remote_file node['wsus']['wsus_package_local_location'] do
# remote_file 'blaaaa' do
  source node['wsus']['wsus_package_source']
  # path node['wsus']['wsus_package_local_location']
  checksum node['wsus']['wsus_package_checksum']
  action :create
end

windows_package "Windows Server Update Services 3.0 SP2" do
  # default logs go to C:\Users\Opscode\AppData\Local\Temp\WSUSSetup.log - doesnt seem to be a way to change it
  # notes http://technet.microsoft.com/en-us/library/dd939814(WS.10).aspx
  # notes http://technet.microsoft.com/en-us/library/dd939811(v=ws.10).aspx#wssetup
  action :install
  installer_type :custom
  source node['wsus']['wsus_package_local_location']
  options node['wsus']['wsus_installer_switches']
  # options with SQL "/q CONTENT_LOCAL=1 CONTENT_DIR=C:\\WSUS SQLINSTANCE_NAME=%COMPUTERNAME% DEFAULT_WEBSITE=0 CREATE_DATABASE=1 PREREQ_CHECK_LOG=C:\\chef\\bob.txt MU_ROLLUP=0"
  # other stuff CONSOLE_INSTALL=0 ? ENABLE_INVENTORY ? 

  # test to see if windows_package idempotence is working - if not use below not_if
  # not_if "type C:\\Users\\Opscode\\AppData\\Local\\Temp\\WSUSSetup.log |grep -i 'Windows Server Update Services setup completed successfully'"
  # require 'pry';binding.pry

########## new not_if
########## guard_interpreter :powershell
########## not_if 'get-hotfix "bla" -eq $true'
end


## Per Julians suggestion - break out into separate recipe
include_recipe "wsus::reportviewer"


# Install WSUS SP2 rollup update
# very important to read this link when modifying recipe to support SSL/NBL/Remote SQL or other advanced features
# http://support.microsoft.com/kb/2828185/en-us  (this update rolls up /kb/2720211 and /kb/2734608)

remote_file node['wsus']['sp_package_local_location'] do
  source node['wsus']['sp_package_source']
  action :create
  # only_if node['wsus']['install_service_pack'] - figure out how to make it actually work.
  # notifies :install, 'windows_package[Windows Server Update Services 3.0 SP2-KB2828185]', :immediately
end

windows_package 'Windows Server Update Services 3.0 SP2-KB2828185' do
  source node['wsus']['sp_package_local_location']
  installer_type :custom
  options node['wsus']['sp_installer_switches']
  action :install
  notifies :restart, 'service[WSUSService]' #, :immediately
end

service 'WSUSService' do
  action :nothing
end

include_recipe "wsus::configure_wsus"
