use_inline_resources

action :install do
  # powershell_script "install_ad" do
  #   code "Add-WindowsFeature ADDS-Domain-Controller"
  # end
  windows_feature "ADDS-Domain-Controller"
end


action :configure do
  dcpromo_answer="#{ENV['temp']}\\dcpromo_unattend.txt"
  # dcpromo_answer="c:\\dcpromo_unattend.txt"

  # template "#{ENV['ChefWorkingDir']}\\cdcpromo_answer.txt" do
  template dcpromo_answer do
    source "dcpromo.txt.erb"
    variables(
      :admin_password => node['ad']['admin_password'],
      :type => "#{new_resource.type}",
      :domain_name => "#{new_resource.name}",
      :netbios_name => node['ad']['netbios_name']

      # :type => "#{new_resource.type}" ? ad['type'] : "forest",
      # :domain_name => "#{new_resource.name}",
      # :netbios_name => ad['netbios_name'] ? ad['netbios_name'] : false,
      # :site_name => ad['site_name'] ? ad['site_name'] : false,
      # :child_name => ad['child_name'] ? ad['child_name'] : false,
      # :user_name => ad['user_name'] ? ad['user_name'] : false,
      # :user_domain => ad['user_domain'] ? ad['user_domain'] : false,
      # :user_password => ad['user_password'] ? ad['user_password'] : false,
      # :dns_user_name => ad['dns_user_name'] ? ad['dns_user_name'] : false,
      # :dns_user_password => ad['dns_user_password'] ? ad['dns_user_password'] : false,
      # :admin_password => ad['admin_password']
    )
  end


# ruby_block "dcpromo-with-template" do
#   block do
#     `dcpromo /unattend:c:\\dcpromo_unattend.txt`
#   end
# end


  # execute "dcpromo /unattend:#{dcpromo_answer}"
  batch "dcpromo" do
    action :run
    # C:\\Windows\\System32\\
    # code "dcpromo.exe /unattend:c:\\dcpromo_unattend.txt"
    code "dcpromo.exe /unattend:#{dcpromo_answer}"
  end
end


action :uninstall do
  powershell_script "install_ad" do
    code "if((Add-WindowsFeature ADDS-Domain-Controller) -eq $true){remove-WindowsFeature ADDS-Domain-Controller}"
  end
end
