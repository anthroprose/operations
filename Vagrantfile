Vagrant.configure("2") do |config|

  config.omnibus.chef_version = :latest
  config.chef_zero.enabled = true
  config.chef_zero.roles = "roles/operations.json"

  config.vm.define :centos6 do |centos6|
    centos6.vm.box      = 'opscode-centos-6.5'
    centos6.vm.box_url  = 'http://opscode-vm-bento.s3.amazonaws.com/vagrant/virtualbox/opscode_centos-6.5_chef-provisionerless.box'
    centos6.vm.hostname = "operations-centos-6"
  end

  config.vm.network :private_network, ip: '10.200.0.2'
  config.vm.network "forwarded_port", guest: 80, host: 8800

  config.vm.provider "virtualbox" do |v|
    v.customize ["modifyvm", :id, "--memory", 1024]
    v.customize ["modifyvm", :id, "--natdnshostresolver1", "on"]
  end

  config.vm.provision "shell", inline: "mkdir -p /etc/chef"
  
  config.vm.provision :chef_client do |chef|
    
    chef.log_level = :info
    
    chef.run_list = [
		"role[operations]"
    ]
    
  end
end