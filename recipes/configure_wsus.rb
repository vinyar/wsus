### Powershell commands to configure server
# new-alias wsus "C:\Program Files\Update Services\Tools\wsusutil.exe"

# High level link: http://technet.microsoft.com/en-us/library/dd939906(v=ws.10).aspx
batch "Add necessary people to *WSUS Administrators" do
  # TODO: change code to use attribute
  # TODO: change to user/group resource
  code "net localgroup 'wsus administrators' /add opscode"
end

batch "Add necessary people to WSUS Reporters - read only group" do
  # TODO: change code to use attribute
  # TODO: change to user/group resource
  #code "net localgroup 'WSUS Reporters' /add opscode"
end


# TODO: Change Updates to Win2k8 only
powershell_script "configure_wsus_server" do
  code <<-EOH
    # per http://msdn.microsoft.com/en-us/library/aa349325(v=vs.85).aspx
    $w  = [reflection.assembly]::LoadWithPartialName("Microsoft.UpdateServices.Administration")
    $ww = [Microsoft.UpdateServices.Administration.AdminProxy]::getUpdateServer("localhost",$false,8530)
# for future updates
# $updatescope = New-Object Microsoft.UpdateServices.Administration.UpdateScope

    $Configuration   = $ww.GetConfiguration()
    $Synchronization = $ww.GetSubscription()

    # Tells it to Sync from MS
    $Configuration.SyncFromMicrosoftUpdate = $true ## Change to attribute (true for master/ false for slave)

    # This tells it not to use every available language
    $Configuration.AllUpdateLanguagesEnabled = $false ## Change to attribute

    # This sets it just to do English (for multiple languages use collection)
    # $language = New-Object -Type System.Collections.Specialized.StringCollection
    # $language.Add("en")
    $Configuration.SetEnabledUpdateLanguages("en")

    # This commits your changes
    $Configuration.Save()


    # This sets synchronization to be automatic
    $Synchronization.SynchronizeAutomatically = $true ## Change to attribute 

    # This sets the time, GMT, in 24 hour format (00:00:00) format
    $Synchronization.SynchronizeAutomaticallyTimeOfDay = '00:01:00'

    # Set the WSUS Server Syncronisation Number of Syncs per day 
    $Synchronization.NumberOfSynchronizationsPerDay="24"

    # Set WSUS to download available categories
    $Synchronization.StartSynchronizationForCategoryOnly()

# Change products
  # $Synchronization.GetUpdateCategories() | select title
  $bla = $Synchronization.GetUpdateCategories() | ? {$_.title -like 'Windows Server 2008 R2'}
  $test = New-Object Microsoft.UpdateServices.Administration.UpdateCategoryCollection
  $test.AddRange($bla)
  $Synchronization.SetUpdateCategories($test)

# Change Classifications
$Synchronization.SetUpdateClassifications()
    # 'Critical Updates',
    # 'Definition Updates',
    # 'Feature Packs',
    # 'Security Updates',
    # 'Service Packs',
    # 'Update Rollups',
    # 'Updates'
$coll = New-Object -TypeName Microsoft.UpdateServices.Administration.UpdateClassificationCollection


    # Change Product Classification
    # TODO
    $Synchronization.GetUpdateClassifications()
    $Synchronization.UpdateClassificationCollection() # ??
    ============
    http://smsagent.wordpress.com/tag/wsus-powershell/
    ============
    # Configure Default Approval Rule
 
$wsus = [Microsoft.UpdateServices.Administration.AdminProxy]::GetUpdateServer();
if ($DefaultApproval -eq $True)
{
write-host 'Configuring default automatic approval rule'
[void][reflection.assembly]::LoadWithPartialName("Microsoft.UpdateServices.Administration")
$rule = $wsus.GetInstallApprovalRules() | Where {
    $_.Name -eq "Default Automatic Approval Rule"}
$class = $wsus.GetUpdateClassifications() | ? {$_.Title -In (
    'Critical Updates',
    'Definition Updates',
    'Feature Packs',
    'Security Updates',
    'Service Packs',
    'Update Rollups',
    'Updates')}
$class_coll = New-Object Microsoft.UpdateServices.Administration.UpdateClassificationCollection
$class_coll.AddRange($class)
$rule.SetUpdateClassifications($class_coll)
$rule.Enabled = $True
$rule.Save()
}
============



    # this saves Synchronization Info
    $Synchronization.Save()

    # this does the first synchronization from the upstream server instantly.  Comment this out if you want to wait for the first synchronization
    $Synchronization.StartSynchronization();
  EOH
end

# Codeplex plugin:
#     http://poshwsus.codeplex.com/

# Docs:
# http://technet.microsoft.com/en-us/library/cc772524.aspx#BKMK_winui


# General security
# http://technet.microsoft.com/en-us/library/dd939800(v=ws.10).aspx

# Secure connectivity with SSL
# http://technet.microsoft.com/en-us/library/dd939849(v=ws.10).aspx#ssl

#     or

# Secure connectivity with IPsec
# http://technet.microsoft.com/en-us/library/5d81ea85-ebf7-40e9-8acd-8bab1182dff8



ruby_block "set node attributes for WSUS access URL" do
  code <<-EOH
    #node.set['wsus']['wsus_server_url'] = node['cloud']['public_hostname']
    #node.set['wsus']['wsus_server_url'] = node.fqdn unless(node.fqdn.eql?(node.hostname)) || node['cloud']['public_hostname'] || node.ec2.public_hostname
  EOH
end
