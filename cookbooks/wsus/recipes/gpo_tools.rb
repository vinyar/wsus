powershell_script 'install-gpmc' do
  code <<-EOH
    import-module ServerManager
    if ((Get-WindowsFeature gpmc).installed -ne $true){Add-WindowsFeature -Name 'gpmc'}
  EOH
end


