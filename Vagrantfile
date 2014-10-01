# optional?
# Vagrant.require_plugin "vagrant-berkshelf"
# Vagrant.require_plugin "vagrant-chef-zero"
# Vagrant.require_plugin "vagrant-omnibus"

# -*- mode: ruby -*-
# vi: set ft=ruby :
box_url = "~/Documents/ISO_BOX_etc/virtualbox-win2008r2-enterprise-provisionerless.box"
box_name = 'win2k8r2-test'

network_wifi = 'en0: Wi-Fi (AirPort)'
network_wired = 'en1: Thunderbolt Ethernet'
network = network_wifi

# Vagrantfile API/syntax version. Don't touch unless you know what you're doing!
# VAGRANTFILE_API_VERSION = "2"

Vagrant.configure("2") do |config|

 config.vm.define 'wsus_server',primary: true do |config|

    # config.berkshelf.enabled = true
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
    config.vm.box = box_name

    # The url from where the 'config.vm.box' box will be fetched 
    config.vm.box_url = box_url

    # Port forward WinRM and RDP
    config.vm.network :forwarded_port, { :guest=>3389, :host=>3389, :id=>"rdp"}#, :auto_correct=>true }
    config.vm.network :forwarded_port, { :guest=>5985, :host=>5985, :id=>"winrm"}#, :auto_correct=>true }
    config.vm.network :private_network, ip: "192.168.33.10" # needed for Consultants/Contractors to spin up vagrant on VPN.

    config.vm.provider :virtualbox do |p|
        p.gui = true
        # adding nat flag to make it work over VPN (may only be needed for consultants). Works in conjunction with private_network above.
        p.customize ["modifyvm", :id, "--memory", "1500", "--clipboard", "bidirectional", "--natdnshostresolver1", "on"]
    end


    # Share an additional folder to the guest VM. The first argument is
    config.vm.synced_folder "../", "c:/cookbooks_path"

    # Provider-specific configuration so you can fine-tune various
    # backing providers for Vagrant. These expose provider-specific options.
    config.vm.guest = :windows
    config.windows.halt_timeout = 25
    config.winrm.username = "vagrant"
    config.winrm.password = "vagrant"
    config.winrm.max_tries = 10

    #Set WinRM Timeout in seconds (Default 30)
    config.winrm.timeout = 1800
    # New veature in vagrant 1.6. Makes windows much easier.
    config.vm.communicator = "winrm"


    ## Enable provisioning with chef solo
    config.vm.provision :chef_solo do |chef|
      chef.cookbooks_path = "../"
      # chef.add_recipe "chef-dev-workstation::windows_setup"
      chef.add_recipe "wsus::server"
      # chef.run_list  = ["recipe[ge_splunk]"]

    end

    # Enable provisioning with chef server, specifying the chef server URL,
    # config.omnibus.chef_version = :latest
    # config.omnibus.chef_version = '11.8.0'

  end


  # config.vm.define 'wsus_client' do |config|
  # end


  # config.vm.define 'wsus_ad' do |config|
  # end

end



