# Install group policy management command line tools

#Temporary addition
# http://github.com/vinyar/systemprep.git
# include_recipe "systemprep::workstation_setup"

# Nice troubleshooting guides
# http://prajwaldesai.com/troubleshooting-wsus-3-0-sp2-on-windows-server/
# http://technet.microsoft.com/en-us/library/dd939801%28v=ws.10%29.aspx

include_recipe "wsus::gpo_tools"


# Take a look at this. Might provide a set of tools to configure client to point at the custom WSUS server
# Install-WindowsFeature -Name UpdateServices-RSAT

# Other Documentation:
#     http://blogs.technet.com/b/heyscriptingguy/archive/2012/01/16/introduction-to-wsus-and-powershell.aspx

# For attribute driven cookbook
# node['wsus']['client_registry'].each |key, value| do
#   registry_key value.regpath do
#       values [{
#         :name => value.name,
#         :type => value.regtype,
#         :data => value.valenabled
#         }]
#   end
# end

wsus_srv = "http://10.0.0.116"
# wsus_srv = "http://54.85.119.200"

# Manual registry setting for version 0.0.1
registry_key 'HKLM\Software\Policies\Microsoft\Windows\WindowsUpdate' do
  values [
    {:name => 'DisableWindowsUpdateAccess', :type => :dword, :data => 0},
    {:name => 'ElevateNonAdmins', :type => :dword, :data => 0},
    {:name => 'WUServer', :type => :string, :data => "#{wsus_srv}"},
    {:name => 'WUStatusServer', :type => :string, :data => "#{wsus_srv}"} # port does not seem necessary :8530
   ]
  # action :create_if_missing
end


registry_key 'HKLM\Software\Policies\Microsoft\Windows\WindowsUpdate\AU' do
  values [
    {:name => 'AUOptions', :type => :dword, :data => 2},
    # {:name => 'DetectionFrequency', :type => :dword, :data => 12},
    # {:name => 'DetectionFrequencyEnabled', :type => :dword, :data => 0},
    {:name => 'NoAutoRebootWithLoggedOnUsers', :type => :dword, :data => 1},
    {:name => 'RebootRelaunchTimeout', :type => :dword, :data => 1440},
    {:name => 'RebootRelaunchTimeoutEnabled', :type => :dword, :data => 1},
    {:name => 'NoAutoUpdate', :type => :dword, :data => 0},
    {:name => 'UseWUServer', :type => :dword, :data => 1}
   ]
    # action :create_if_missing
end




# ## Modify GPO value of the new node to point at the new WSUS server
# # commands for AD joined boxes
# powershell_script "point at the WSUS server" do
#   code <<-EOH
  # Set-GPRegistryValue -Name "Computer Policy" -Key "HKLM\Software\Policies\Microsoft\Windows\WindowsUpdate\AU" -ValueName "UseWUServer" -Type DWORD -Value 1
  # Set-GPRegistryValue -Name "Computer Policy" -Key "HKLM\Software\Policies\Microsoft\Windows\WindowsUpdate" -ValueName "WUServer" -Type STRING -Value "http://ec2-54-226-104-212.compute-1.amazonaws.com:8530"
  # Set-GPRegistryValue -Name "Computer Policy" -Key "HKLM\Software\Policies\Microsoft\Windows\WindowsUpdate" -ValueName "WUStatusServer" -Type STRING -Value "http://ec2-54-226-104-212.compute-1.amazonaws.com:8530"

#   EOH
# end


# Documentation:
#     Configure Automatic Updates in a Non–Active Directory Environment
#     http://technet.microsoft.com/en-us/library/cc708449(WS.10).aspx


# # do some magical search to identify the WSUS server for the Chef Org
# knife search "role:wsus_srv" -a node.cloud.public_hostname
# wsus_nodes = search(:node, 'role:wsus_srv')

# STIG Documentation:       V-14250 STIG
# Microsoft Documentation:  registry configuration per http://technet.microsoft.com/en-us/library/dd939844(v=ws.10).aspx

# http://technet.microsoft.com/en-us/library/ee461027.aspx
# http://technet.microsoft.com/en-us/magazine/gg277500.aspx
# http://technet.microsoft.com/en-us/library/ee461040.aspx


