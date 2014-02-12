# optional?
# Vagrant.require_plugin "vagrant-berkshelf"
# Vagrant.require_plugin "vagrant-chef-zero"
# Vagrant.require_plugin "vagrant-omnibus"

# -*- mode: ruby -*-
# vi: set ft=ruby :

# Vagrantfile API/syntax version. Don't touch unless you know what you're doing!
VAGRANTFILE_API_VERSION = "2"

Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|

  ## Configuring berkshelf
  config.berkshelf.enabled = true
  # config.berkshelf.berksfile_path = "C:/Users/vinyara/Documents/Work_in_progress/ge/vagrant_from_packer/cookbooks/iis_test/Berksfile"
  config.berkshelf.berksfile_path = "C:/Users/vinyara/Documents/Work_in_progress/ge/vagrant_from_packer/../cookbooks/treasury_winsecureos/Berksfile"

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
  config.vm.box = "i_dont_know_what_this_is"

  # The url from where the 'config.vm.box' box will be fetched 
  config.vm.box_url = "./virtualbox-win2008r2-enterprise-provisionerless.box"

  # Create a private network, which allows host-only access to the machine
  config.vm.network :public_network, ip: "111.222.33.4"#, :bridge => 'adapter 1'
  # config.vm.network :private_network, ip: "192.168.33.11"

  # Create a forwarded port mapping which allows access to a specific port
  config.vm.network "forwarded_port", guest: 5985, host: 15985  # winrm
  config.vm.network "forwarded_port", guest: 3389, host: 13390  # remote desktop
  config.vm.network "forwarded_port", guest: 4000, host: 4000   # chef-zero


  # Share an additional folder to the guest VM. The first argument is
  config.vm.synced_folder "../", "c:/ge"

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
    vb.name = "alex_packer2k8r2"
  
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


  # Enable provisioning with chef solo
  # config.vm.provision :chef_solo do |chef|
  #   chef.cookbooks_path = "."
  #   # chef.add_recipe "iis_test"
  #   chef.add_recipe "treasury_winsecureos"
  # end

  # Enable provisioning with chef server, specifying the chef server URL,
  # config.omnibus.chef_version = :latest
  # config.omnibus.chef_version = '11.8.0'

  config.vm.provision :chef_client do |chef|
    chef.chef_server_url = "https://api.opscode.com/organizations/alexv-ge"
    chef.validation_key_path = "../.chef/alexv-ge-validator.pem"
    # chef.validation_client_name = "testname001"
    chef.node_name = "testname002"
    chef.verbose_logging = false
    chef.log_level = :info

   end
  #

end



