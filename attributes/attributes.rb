# switch node[:architechture]
# when 'x86'
#   default['wsus']['remote_file'] =  "http://download.microsoft.com/download/B/0/6/B06A69C3-CF97-42CF-86BF-3C59D762E0B2/WSUS30-KB972455-x86.exe"
# when 'x64'
#   default['wsus']['remote_file'] =  "http://download.microsoft.com/download/B/0/6/B06A69C3-CF97-42CF-86BF-3C59D762E0B2/WSUS30-KB972455-x64.exe"
# end

# default['wsus']['installer_storage']   = 'c:/chef/WSUS30-KB972455-x64.exe'
# default['wsus']['installation_drive']  = 'C:/'
# default['wsus']['installation_folder'] = 'WSUS'

# default['wsus']['installer_switches']        = '/q CONTENT_LOCAL=1 CONTENT_DIR=E:\WSUS DEFAULT_WEBSITE=0 CREATE_DATABASE=1 SQLINSTANCE_NAME=%COMPUTERNAME%'


# Allowed settings - server or client
default['wsus']['server'] = true
default['wsus']['wsus_server_url'] = nil



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

