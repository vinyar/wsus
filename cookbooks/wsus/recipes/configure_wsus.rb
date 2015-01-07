### Powershell commands to configure server
# new-alias wsus "C:\Program Files\Update Services\Tools\wsusutil.exe"

# High level link: http://technet.microsoft.com/en-us/library/dd939906(v=ws.10).aspx
#                  http://technet.microsoft.com/en-us/library/dd939838(v=ws.10).aspx
    # Nice blog - http://smsagent.wordpress.com/tag/wsus-powershell/

user node['wsus']['config']['admin_user'] do
  # username 'TestAdmin123'
  password node['wsus']['config']['admin_pass']
  action :create
end

user node['wsus']['config']['basic_user'] do
  # username 'TestUser123'
  password node['wsus']['config']['basic_pass']
  action :create
end

group node['wsus']['config']['admin_group'] do
  members node['wsus']['config']['admin_group_members']
end

group node['wsus']['config']['reporter_group'] do
  members node['wsus']['config']['reporter_group_members']
end

powershell_script "test testing of WSUS installation" do
  code 'Import-Module ServerManager;if ((Get-WindowsFeature -Name OOB-WSUS).installed){"hi"}'
  # notifies :run, "powershell_script[configure_wsus_server]", :immediately
end

powershell_script "configure_wsus_server" do
  code <<-EOH
    # per http://msdn.microsoft.com/en-us/library/aa349325(v=vs.85).aspx
    $w  = [reflection.assembly]::LoadWithPartialName("Microsoft.UpdateServices.Administration")
    $ww = [Microsoft.UpdateServices.Administration.AdminProxy]::getUpdateServer()
    
    # $ww = [Microsoft.UpdateServices.Administration.AdminProxy]::getUpdateServer("localhost",$false,8530) # for remote administration

# for future updates
# $updatescope = New-Object Microsoft.UpdateServices.Administration.UpdateScope

    $Configuration   = $ww.GetConfiguration()
    $Synchronization = $ww.GetSubscription()
    $Rules           = $ww.GetInstallApprovalRules()

    # Tells it to Sync from MS
    ## Change to attribute (true for master/ false for slave)
    $Configuration.SyncFromMicrosoftUpdate = $true 

    # This tells it not to use every available language
    ## Change to attribute
    $Configuration.AllUpdateLanguagesEnabled = $false

    # This sets it just to do English (for multiple languages use collection)
    # $language = New-Object -Type System.Collections.Specialized.StringCollection
    # $language.Add("en")

# below line is untested
# #{node['wsus']['config']['primary']['languages']} | foreach {$language.Add("$_")}
# $Configuration.SetEnabledUpdateLanguages($language)

    $Configuration.SetEnabledUpdateLanguages("en")

    # This commits your changes
    $Configuration.Save()


    # This sets synchronization to be automatic
    ## Change to attribute
    $Synchronization.SynchronizeAutomatically = $true  

    # This sets the time, GMT, in 24 hour format (00:00:00) format
    $Synchronization.SynchronizeAutomaticallyTimeOfDay = '12:00:00'

    # Set the WSUS Server Synchronization Number of Syncs per day 
    $Synchronization.NumberOfSynchronizationsPerDay='4'

    # Saving to avoid losing changes after Category Sync starts
    $Synchronization.save()

    # Set WSUS to download available categories
    # This can take up to 10 minutes
    $Synchronization.StartSynchronizationForCategoryOnly()

    # Loop to make sure new products synch up. And a anti-lock to prevent getting stuck.
    $lock_prevention = [DateTime]::now.AddMinutes(10)
    do{ 
      Start-Sleep -Seconds 20
      # write-host $([datetime]::now) --- $lock_prevention
      $Status = $Synchronization.GetSynchronizationProgress().phase
    } until ($Status -like "*NotProcessing*" -or $lock_prevention -lt [datetime]::now) 


    # Change products (windows 2008r2 only by default)
## TODO Configure idempotence
        ## broken - this shows only products already selected. (left here for reference)
        # $main_category = $Synchronization.GetUpdateCategories() | where {$_.title -like 'windows'}
    
    ## This shows all of the available products
    $main_category = $ww.GetUpdateCategories() | where {$_.title -like 'windows'}
        # example of multiple products
        # $products = $main_category.GetSubcategories() | ? {$_.title -in ('Windows Server 2008 R2','Windows Server 2008 Server Manager Dynamic Installer')}
    $products = $main_category.GetSubcategories() | ? {$_.title -in ('Windows Server 2008 R2')}
    $products_col = New-Object Microsoft.UpdateServices.Administration.UpdateCategoryCollection
    $products_col.AddRange($products)
    $Synchronization.SetUpdateCategories($products_col)


    ## TODO Configure idempotence
    # Change Classifications (available classifications)
      # 'Critical Updates',
      # 'Definition Updates',
      # 'Feature Packs',
      # 'Security Updates',
      # 'Service Packs',
      # 'Update Rollups',
      # 'Updates'
        # example of multiple products
        # $classifications = $ww.GetUpdateClassifications() | ? {$_.title -in ('Critical Updates','Security Updates')}
        ## - again broken - this shows only selected classifications
        ## $classifications = $Synchronization.GetUpdateClassifications() | ? {$_.title -in ('Critical Updates')}
    
    # Select desired classifications from a full list of available classifications
    $classifications = $ww.GetUpdateClassifications() | ? {$_.title -in ('Critical Updates')}
    $classifications_col = New-Object Microsoft.UpdateServices.Administration.UpdateClassificationCollection
    $classifications_col.AddRange($classifications)
    $Synchronization.SetUpdateClassifications($classifications_col)


    # Configure Default Approval Rule - enabled for Critical updates only
    $ww.GetInstallApprovalRules()
    $rule = $rules | Where {$_.Name -eq "Default Automatic Approval Rule"}
    $rule.SetUpdateClassifications($classifications_col)
    $rule.Enabled = $True
    $rule.Save()

    # this saves Synchronization Info
    $Synchronization.Save()

    # this does the first synchronization from the upstream server instantly.  Comment this out if you want to wait for the first synchronization
# This can take well over an hour. Should probably be a handler or something that wouldnt hang chef run for an hour
# Might also be a good idea to set [datetime]::now during FirstSync() and time it to start a few min after chef run finishes.
    $Synchronization.StartSynchronization()


  EOH
  action :nothing

  # guard_interpreter :powershell_script
  # not_if 'the thing from the test block above'
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



# ruby_block "set node attributes for WSUS access URL" do
#   code <<-EOH
#     #node.set['wsus']['wsus_server_url'] = node['cloud']['public_hostname']
#     #node.set['wsus']['wsus_server_url'] = node.fqdn unless(node.fqdn.eql?(node.hostname)) || node['cloud']['public_hostname'] || node.ec2.public_hostname
#   EOH
# end
