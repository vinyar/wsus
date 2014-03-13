# optional?
# Vagrant.require_plugin "vagrant-berkshelf"
# Vagrant.require_plugin "vagrant-chef-zero"
# Vagrant.require_plugin "vagrant-omnibus"

# -*- mode: ruby -*-
# vi: set ft=ruby :
alex_box_url = "~/Documents/ISO_BOX_etc/virtualbox-win2008r2-enterprise-provisionerless.box"
ge_box_url = "~/Documents/ISO_BOX_etc/ge_windows2008r2.box"
box_url = $alex_box_url

# See what the community supported way for managing ports is
# host_win_rm_port    =  15985
# host_rdp_port       =  13390
# host_chef_zero_port =  4000

# Vagrantfile API/syntax version. Don't touch unless you know what you're doing!
VAGRANTFILE_API_VERSION = "2"

Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|

 config.vm.define 'wsus_server',primary: true do |config|

    config.berkshelf.enabled = true
    # config.berkshelf.berksfile_path = "./Berksfile"

    # Chef-Zero plugin configuration
    # config.chef_zero.enabled = true
    
    # Granular config
    # config.chef_zero.nodes = "../foobar/nodes"
    # config.chef_zero.environments = "../foobar/environments/baz.json"
    # config.chef_zero.data_bags = "../foobar/data_bags"
    # config.chef_zero.roles = "../foobar/roles/*.json"
    # config.chef_zero.cookbooks = "spec/fixtures/cookbooks"

    # Alternatively, you can use chef_repo_path and it will attempt to intelligently find the appropriate sub directories:
    # config.chef_zero.chef_repo_path = "../cookbooks/"


    # Every Vagrant virtual environment requires a box to build off of.
    config.vm.box = "wsus"

    # The url from where the 'config.vm.box' box will be fetched 
    config.vm.box_url = $box_url

    # Create a private network, which allows host-only access to the machine
    config.vm.network :public_network, ip: "111.222.33.4", :bridge => 'en0: Wi-Fi (AirPort)'
    # config.vm.network :private_network, ip: "192.168.33.11"

    # Create a forwarded port mapping which allows access to a specific port
    config.vm.network "forwarded_port", guest: 5985, host: 15985, auto_correct: true # winrm
    config.vm.network "forwarded_port", guest: 3389, host: 13390, auto_correct: true  # remote desktop
    config.vm.network "forwarded_port", guest: 4000, host: 4000, auto_correct: true   # chef-zero


    # Share an additional folder to the guest VM. The first argument is
    config.vm.synced_folder "../", "c:/cookbooks_path"

    # Provider-specific configuration so you can fine-tune various
    # backing providers for Vagrant. These expose provider-specific options.
    config.vm.guest = :windows
    config.windows.halt_timeout = 25
    config.winrm.username = "vagrant"
    config.winrm.password = "vagrant"
    config.winrm.max_tries = 30


    # Example for VirtualBox:
    config.vm.provider :virtualbox do |vb|
      # Don't boot with headless mode
      vb.gui = true
      vb.name = "wsus_server"
    
      # Use VBoxManage to customize the VM. For example to change memory:
      vb.customize [
        "modifyvm", :id,
         "--memory", "1536"
       ]
    end

    # Enable provisioning with chef zero
    # config.vm.provision :chef_client do |chef|
    #   chef.chef_server_url = "https://api.opscode.com/organizations/alexv-ge"
    #   chef.validation_key_path = "../.chef/alexv-ge-validator.pem"
    #   # chef.validation_client_name = "testname001"
    #   chef.node_name = "testname002"
    #   chef.verbose_logging = false
    #   chef.log_level = :info

    #  end


    ## Enable provisioning with chef solo
    config.vm.provision :chef_solo do |chef|
      chef.cookbooks_path = "../"
      # chef.add_recipe "chef-dev-workstation::windows_setup"
      chef.add_recipe "wsus::server"
      # chef.run_list  = ["recipe[ge_splunk]"]

    end

    # Enable provisioning with chef server, specifying the chef server URL,
    config.omnibus.chef_version = :latest
    # config.omnibus.chef_version = '11.8.0'

    # config.vm.provision :chef_client do |chef|
    #   chef.chef_server_url = "https://api.opscode.com/organizations/alexv-ge"
    #   chef.validation_key_path = "../.chef/alexv-ge-validator.pem"
    #   # chef.validation_client_name = "testname001"
    #   chef.node_name = "testname002"
    #   chef.verbose_logging = false
    #   chef.log_level = :info
    #  end
  end


  config.vm.define 'wsus_client' do |config|

    config.berkshelf.enabled = true

    # Every Vagrant virtual environment requires a box to build off of.
    config.vm.box = "wsus"

    # The url from where the 'config.vm.box' box will be fetched 
    config.vm.box_url = $box_url

    # Create a private network, which allows host-only access to the machine
    config.vm.network :public_network, ip: "111.222.33.5", :bridge => 'en0: Wi-Fi (AirPort)'

    # Create a forwarded port mapping which allows access to a specific port
    config.vm.network "forwarded_port", guest: 5985, host: 15985, auto_correct: true  # winrm
    config.vm.network "forwarded_port", guest: 3389, host: 13390, auto_correct: true  # remote desktop
    config.vm.network "forwarded_port", guest: 4000, host: 4000, auto_correct: true   # chef-zero


    # Share an additional folder to the guest VM. The first argument is
    config.vm.synced_folder "../", "c:/cookbooks_path"

    # Provider-specific configuration so you can fine-tune various
    # backing providers for Vagrant. These expose provider-specific options.
    config.vm.guest = :windows
    config.windows.halt_timeout = 25
    config.winrm.username = "vagrant"
    config.winrm.password = "vagrant"
    config.winrm.max_tries = 30


    # Example for VirtualBox:
    config.vm.provider :virtualbox do |vb|
      # Don't boot with headless mode
      vb.gui = true
      vb.name = "wsus_client"
    
      # Use VBoxManage to customize the VM. For example to change memory:
      vb.customize [
        "modifyvm", :id,
         "--memory", "1536"
       ]
    end

    # Enable provisioning with chef zero
    # config.vm.provision :chef_client do |chef|
    #   chef.chef_server_url = "https://api.opscode.com/organizations/alexv-ge"
    #   chef.validation_key_path = "../.chef/alexv-ge-validator.pem"
    #   # chef.validation_client_name = "testname001"
    #   chef.node_name = "testname002"
    #   chef.verbose_logging = false
    #   chef.log_level = :info

    #  end


    ## Enable provisioning with chef solo
    config.vm.provision :chef_solo do |chef|
      chef.cookbooks_path = "../"
      # chef.add_recipe "chef-dev-workstation::windows_setup"
      chef.add_recipe "wsus::client"
      # chef.run_list  = ["recipe[ge_splunk]"]

    end

    # Enable provisioning with chef server, specifying the chef server URL,
    config.omnibus.chef_version = :latest
    # config.omnibus.chef_version = '11.8.0'

    # config.vm.provision :chef_client do |chef|
    #   chef.chef_server_url = "https://api.opscode.com/organizations/alexv-ge"
    #   chef.validation_key_path = "../.chef/alexv-ge-validator.pem"
    #   # chef.validation_client_name = "testname001"
    #   chef.node_name = "testname002"
    #   chef.verbose_logging = false
    #   chef.log_level = :info
    #  end
  end


end



