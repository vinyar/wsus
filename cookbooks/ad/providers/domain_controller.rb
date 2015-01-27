use_inline_resources


action :install do
  powershell_script "install_ad" do
    code "if (!(get-windowsfeature adds-domain-controller)){Add-WindowsFeature ADDS-Domain-Controller}"
    # not_if "something that can get a value from cmd /c or powreshell_script"
    # "only_if { WMI::Win32_Service.find(:first, :conditions => {:name => 'chef-client'}).nil? "
  end
end


action :configure do
  dcpromo_answer="#{ENV['temp']}\\dcpromo_unattend.txt"

  ## use this page to create a temp file
  ## unlink at the end of the template
  ## http://www.ruby-doc.org/stdlib-1.9.3/libdoc/tempfile/rdoc/Tempfile.html

  ## Declare a file resource with action :nothing


  # template "#{ENV['ChefWorkingDir']}\\cdcpromo_answer.txt" do
  template dcpromo_answer do
    source "dcpromo.txt.erb"
    variables(
      :admin_password => node['ad']['admin_password'],
      :type => "#{new_resource.type}",
      :domain_name => "#{new_resource.name}",
      :netbios_name => node['ad']['netbios_name']
    )
  end


  # execute "dcpromo /unattend:#{dcpromo_answer}"
  batch "dcpromo" do
    action :run
    code "dcpromo.exe /unattend:#{dcpromo_answer}"
    #add some kind of not_if here
    ## add notify to file resource (for template file) with action :delete
    notifies :delete, "file[#{dcpromo_answer}]"
  end

  file dcpromo_answer do
    action :nothing
  end

end


action :uninstall do
  powershell_script "install_ad" do
    ## convert to using Windows cookbook to install features.
    code "if((Add-WindowsFeature ADDS-Domain-Controller) -eq $true){remove-WindowsFeature ADDS-Domain-Controller}"
  end
end
