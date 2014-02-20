### Powershell commands to configure server
# new-alias wsus "C:\Program Files\Update Services\Tools\wsusutil.exe"

# High level link: http://technet.microsoft.com/en-us/library/dd939906(v=ws.10).aspx
#                  http://technet.microsoft.com/en-us/library/dd939838(v=ws.10).aspx

user 'adding administrators' do
  username 'TestAdmin123'
  password 'TestAdmin123456789!!'
  action :create
end

user 'adding administrators' do
  username 'TestUser123'
  password 'TestUser123456789!!'
  action :create
end

group 'WSUS Administrators' do
  members 'TestAdmin123'
end

group 'WSUS Reporters' do
  members 'TestUser123'
end

powershell_script "test testing of WSUS installation" do
  code 'if ((Get-WindowsFeature -Name OOB-WSUS).installed){"hi"}'
  notifies "powershell_script[configure_wsus_server]"
end

powershell_script "configure_wsus_server" do
  code <<-EOH
    # per http://msdn.microsoft.com/en-us/library/aa349325(v=vs.85).aspx
    $w  = [reflection.assembly]::LoadWithPartialName("Microsoft.UpdateServices.Administration")
    $ww = [Microsoft.UpdateServices.Administration.AdminProxy]::getUpdateServer("localhost",$false,8530)
    # $ww = [Microsoft.UpdateServices.Administration.AdminProxy]::getUpdateServer()
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
    $Configuration.SetEnabledUpdateLanguages("en")

    # This commits your changes
    $Configuration.Save()


    # This sets synchronization to be automatic
    $Synchronization.SynchronizeAutomatically = $true ## Change to attribute 

    # This sets the time, GMT, in 24 hour format (00:00:00) format
    $Synchronization.SynchronizeAutomaticallyTimeOfDay = '12:00:00'

    # Set the WSUS Server Syncronisation Number of Syncs per day 
    $Synchronization.NumberOfSynchronizationsPerDay="4"

    # Set WSUS to download available categories
    $Synchronization.StartSynchronizationForCategoryOnly()


    # Nice blog - http://smsagent.wordpress.com/tag/wsus-powershell/

    # Change products
    ## TODO Configure idempotence
    # $Synchronization.GetUpdateCategories() | select title 
    $products = $Synchronization.GetUpdateCategories() | ? {$_.title -like 'Windows Server 2008 R2'}
    $products_col = New-Object Microsoft.UpdateServices.Administration.UpdateCategoryCollection
    $products_col.AddRange($products)
    $Synchronization.SetUpdateCategories($products_col)


  # Change Classifications
    # (available classifications)
      # 'Critical Updates',
      # 'Definition Updates',
      # 'Feature Packs',
      # 'Security Updates',
      # 'Service Packs',
      # 'Update Rollups',
      # 'Updates'
    ## TODO Configure idempotence
    # $Synchronization.GetUpdateClassifications().title
    $classifications = $Synchronization.GetUpdateClassifications() | ? {$_.title -in ('Critical Updates','Security Updates')}
    $classifications_col = New-Object Microsoft.UpdateServices.Administration.UpdateClassificationCollection
    $classifications_col.AddRange($classifications)
    $Synchronization.SetUpdateClassifications($classifications_col)


    # Configure Default Approval Rule
    # $ww.GetInstallApprovalRules()
    $rule = $rules | Where {$_.Name -eq "Default Automatic Approval Rule"}
    $rule.SetUpdateClassifications($classifications_col)
    $rule.Enabled = $True
    $rule.Save()

    # this saves Synchronization Info
    $Synchronization.Save()

    # this does the first synchronization from the upstream server instantly.  Comment this out if you want to wait for the first synchronization
    $Synchronization.StartSynchronization()
  EOH
  action :nothing
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
