#
# Cookbook Name:: wsus_wrapper
# Recipe:: default
#
# Copyright 2014, YOUR_COMPANY_NAME
#
# All rights reserved - Do Not Redistribute
#

## workaround to vagrant bug which I just filed - https://github.com/WinRb/vagrant-windows/issues/200


# batch 'make net share z' do
#   code 'net use z: \\\\vboxsrv\\c:_local_binaries'
#   guard_interpreter :powershell_script
#   not_if 'Get-WmiObject win32_networkconnection |?{$_.localname -eq "z:" -and $_.remotename -eq "\\\\vboxsrv\\c:_local_binaries"}'
# end


# note shared across ps sessions anyway
# powershell_script 'New-PSDrive -Name z -PSProvider FileSystem -Root \\\\vboxsrv\\c:_local_binaries' do
#   convert_boolean_return
#   guard_interpreter :powershell_script
#   not_if '(Get-PSDrive z).root -eq \\\\vboxsrv\\vagrant'
# end

# mount "Z:" do
#   device "\\\\vboxsrv\\c\:_local_binaries"
#   action :mount
# end

include_recipe 'wsus::server'

