# Install group policy management command line tools
include_recipe "gpo_tools"



Documentation:
    Configure Automatic Updates in a Non–Active Directory Environment
    http://technet.microsoft.com/en-us/library/cc708449(WS.10).aspx

## MOdify GPO value of the new node to point at the new WSUS server

# do some magical search to identify the WSUS server for the Chef Org
knife search "role:wsus_srv" -a node.cloud.public_hostname


http://technet.microsoft.com/en-us/library/ee461027.aspx
http://technet.microsoft.com/en-us/magazine/gg277500.aspx
http://technet.microsoft.com/en-us/library/ee461040.aspx


# Populate the appropriate powershell string below
powershell_script "point at the WSUS server" do
	code <<-EOH
    Get-GPPrefRegistryValue -Guid <Guid> -Context {<User> | <Computer>} -Key <string> [-Domain <string>] [-Order <int>] [-Server <string>] [-ValueName <string>] [<CommonParameters>]
    Get-GPRegistryValue -Guid <Guid> -Key <string> [-Domain <string>] [-Server <string>] [-ValueName <string>] [<CommonParameters>]
  EOH
end


Documentation:
    V-14250 STIG
  ============
  #ec2-23-20-242-20.compute-1.amazonaws.com



  If the following registry value does not exist or is not configured as specified, this is a finding:

  Registry Hive: HKEY_LOCAL_MACHINE
  Subkey: \Software\Policies\Microsoft\Windows\WindowsUpdate\AU\

  Value Name: NoAutoUpdate

  Type: REG_DWORD
  Value: 1

  If the site is using a DoD WSUS server to distribute software updates, and the computer is configured to point at that server, this can be set to "Enabled". In this instance, the setting will not be considered a finding.
  To determine whether WSUS is being used, verify the following registry key value exists and is pointing to an organizational or DoD WSUS URL.

  Registry Hive: HKEY_LOCAL_MACHINE
  Subkey: \Software\Policies\Microsoft\Windows\WindowsUpdate\

  Value Name: WUServer

  Type: REG_SZ
  Value: "URL of DoD WSUS"
  ==============

Documentation:
    http://blogs.technet.com/b/heyscriptingguy/archive/2012/01/16/introduction-to-wsus-and-powershell.aspx

Configure the GPO to (HKLM:Software\Policies\Microsoft\Windows\WindowsUpdate)
* point my client to the WSUS server (Specify intranet Microsoft update service location)
* set the update client to only download (Configure Automatic Updates) the approved updates
* change the detection to every four hours (Automatic Updates detection frequency)

#Can translate the two convoluted ps1 scrits into chef reg resources:
#  Set-ClientWSUSSetting  & Get-ClientWSUSSetting
