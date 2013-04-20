# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure("2") do |config|

  config.vm.box = "precise64_rbenv_bootstrapped"
  config.vm.box_url = "https://dl.dropboxusercontent.com/u/11721015/vagrant/boxes/precise64_rbenv_bootstrapped.box"

  config.vm.network :forwarded_port, guest: 80, host: 8080, :auto => true
  config.vm.network :private_network, ip: "192.168.33.10"

  config.vm.provider :virtualbox do |vb|
    vb.customize ["modifyvm", :id,
                  "--memory", "1024"]
  end

  config.vm.provision :puppet do |puppet|
    puppet.module_path = "puppet/modules"
    puppet.manifests_path = "puppet/manifests"
    puppet.manifest_file  = "site.pp"
  end

end
