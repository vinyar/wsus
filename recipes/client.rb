# Install group policy management command line tools
include_recipe "gpo_tools"

## MOdify GPO value of the new node to point at the new WSUS server

# do some magical search to identify the WSUS server for the Chef Org
# Populate the appropriate powershell string below

powershell_script "point at the WSUS server" do
	code <<-EOH
    Get-GPPrefRegistryValue -Guid <Guid> -Context {<User> | <Computer>} -Key <string> [-Domain <string>] [-Order <int>] [-Server <string>] [-ValueName <string>] [<CommonParameters>]
    Get-GPRegistryValue -Guid <Guid> -Key <string> [-Domain <string>] [-Server <string>] [-ValueName <string>] [<CommonParameters>]
  EOH


# Get the registry location for WSUS server from GPO cookbook in DOD STIG