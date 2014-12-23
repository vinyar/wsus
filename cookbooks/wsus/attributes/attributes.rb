# switch node[:architechture]
# when 'x86'
#   default['wsus']['remote_file'] =  "http://download.microsoft.com/download/B/0/6/B06A69C3-CF97-42CF-86BF-3C59D762E0B2/WSUS30-KB972455-x86.exe"
# when 'x64'
#   default['wsus']['remote_file'] =  "http://download.microsoft.com/download/B/0/6/B06A69C3-CF97-42CF-86BF-3C59D762E0B2/WSUS30-KB972455-x64.exe"
# end

## WSUS setup and Service Pack downloads
case node['kernel']['machine']
when 'x86_64'
  default['wsus']['wsus_package_source']   = 'http://download.microsoft.com/download/B/0/6/B06A69C3-CF97-42CF-86BF-3C59D762E0B2/WSUS30-KB972455-x86.exe'
  default['wsus']['wsus_package_checksum'] = '50d027431d64c35ad62291825eed35d7ffd3c3ecc96421588465445e195571d0'
  default['wsus']['sp_package_source']   = 'http://download.microsoft.com/download/6/E/E/6EE90E69-1A7E-480B-9C1E-24B0EC13BDE3/WSUS-KB2828185-x86.exe'
  default['wsus']['sp_package_checksum'] = ''
when 'x64'
  default['wsus']['wsus_package_source']   = 'http://download.microsoft.com/download/B/0/6/B06A69C3-CF97-42CF-86BF-3C59D762E0B2/WSUS30-KB972455-x64.exe'
  default['wsus']['wsus_package_checksum'] = 'bec8bdd6cdad1edd50cc43e6121b73188b31ba4ad08e55b49f4287923a7f3290'
  default['wsus']['sp_package_source']   = 'http://download.microsoft.com/download/E/B/A/EBA42B12-8E2C-41E6-8F76-9AA40BF2A4A6/WSUS-KB2828185-amd64.exe'
  default['wsus']['sp_package_checksum'] = ''
end

# Common download files
# file location: http://www.microsoft.com/en-us/download/details.aspx?id=577
default['wsus']['report_package_source']   = 'http://download.microsoft.com/download/0/9/d/09d3df2d-abec-4ebe-bc64-260b05a30feb/ReportViewer.exe'
# 11.0.1443.3 	http://www.microsoft.com/en-us/download/details.aspx?id=27230
# 11.0.3010		
# 11.0.3010.3 	
# 11.0.3452.0 	http://www.microsoft.com/en-us/download/details.aspx?id=35747
default['wsus']['report_package_checksum'] = ''


## using gsub from here because I can't use win_friendly_path in an attribute file - to keep recipe clean.
default['wsus']['package_local_root']            = Chef::Config[:solo] ? 'c:\\var\\chef\\cache\\' : Chef::Config[:file_cache_path]
default['wsus']['wsus_package_local_location']   = File.join(node['wsus']['package_local_root'],File.basename(node['wsus']['wsus_package_source'])).gsub(::File::SEPARATOR, ::File::ALT_SEPARATOR || '\\')
default['wsus']['sp_package_local_location']     = File.join(node['wsus']['package_local_root'],File.basename(node['wsus']['sp_package_source'])).gsub(::File::SEPARATOR, ::File::ALT_SEPARATOR || '\\')
default['wsus']['report_package_local_location'] = File.join(node['wsus']['package_local_root'],File.basename(node['wsus']['report_package_source'])).gsub(::File::SEPARATOR, ::File::ALT_SEPARATOR || '\\')


# Fine tuning knobs
# default['wsus']['installation_drive']  = 'C:\\'
# default['wsus']['installation_folder'] = 'WSUS'

####### TODO fix to use fine tuning knobs when running
####### TODO : Seems like wsus installer switch is missing the actual logging. It only had precheck log.
# old switch- default['wsus']['wsus_installer_switches']      = '/q CONTENT_LOCAL=1 CONTENT_DIR=E:\WSUS DEFAULT_WEBSITE=0 CREATE_DATABASE=1 SQLINSTANCE_NAME=%COMPUTERNAME%'
default['wsus']['wsus_installer_switches']      = "/q CONTENT_LOCAL=1 CONTENT_DIR=C:\\WSUS DEFAULT_WEBSITE=0 CREATE_DATABASE=1 PREREQ_CHECK_LOG=#{node['wsus']['package_local_root']}\\bob.txt MU_ROLLUP=0"
default['wsus']['sp_installer_switches']        = "/q /l #{node['wsus']['package_local_root']}\\WSUS-KB2720211-x64.log"
default['wsus']['report_installer_switches']    = "/q /l #{node['wsus']['package_local_root']}\\ReportViewer_install.log"


# Allowed settings - server or client
######## TODO: Default should probably be client.
default['wsus']['server'] = true
default['wsus']['wsus_server_url'] = nil
default['wsus']['install_service_pack'] = true




default['wsus']['administrators'] = 'opscode'
default['wsus']['reporters'] = ''


default['wsus']['client_registry']['update_server'] = {
	# :enabled => 1,
	:regpath => 'hklm\Software\Policies\Microsoft\Windows\WindowsUpdate',
	:name => 'WUServer',
	:regtype => :string,
	:valenabled => "http://ec2-23-20-242-20.compute-1.amazonaws.com:8530" #,
	# :valdisabled => ''
  }

default['wsus']['client_registry']['auto_update'] = {
	# :enabled => 1,
	:regpath => 'hklm\Software\Policies\Microsoft\Windows\WindowsUpdate\AU',
	:name => 'NoAutoUpdate',
	:regtype => :string,
	:valenabled => 1#,
	# :valdisabled => ''
  }

default['wsus']['client_registry']['update_frequency'] = {
	# :enabled => 1,
	:regpath => 'hklm\Software\Policies\Microsoft\Windows\WindowsUpdate\AU',
	:name => 'NoAutoUpdate',
	:regtype => :dword,
	:valenabled => 1#,
	# :valdisabled => ''
  }

