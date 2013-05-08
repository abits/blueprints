# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure("2") do |config|
  # Every Vagrant virtual environment requires a box to build off of.
  config.vm.box = "wheezy64"

  config.vm.box_url = "http://files.codeways.org/wheezy64.box"
  config.vm.network :forwarded_port, guest: 80, host: 8080

  config.vm.network :private_network, ip: "33.33.33.10"

  # Share an additional folder to the guest VM. The first argument is
  # the path on the host to the actual folder. The second argument is
  # the path on the guest to mount the folder. And the optional third
  # argument is a set of non-required options.
  config.vm.synced_folder "./www", "/srv/www/drupal", :nfs => true, :nfs_version => 4, :create => true
  config.vm.synced_folder(".", "/vagrant", :nfs => true, :nfs_version => 4)
  #config.vm.synced_folder("./puppet/manifests", "/tmp/vagrant-puppet/manifests", :nfs => true, :nfs_version => 4)
  #config.vm.synced_folder("./puppet/modules", "//tmp/vagrant-puppet/modules-0", :nfs => true, :nfs_version => 4)

  config.vm.provision :puppet do |puppet|
      puppet.module_path = "puppet/modules"
      puppet.manifests_path = "puppet/manifests"
      puppet.manifest_file = "default.pp"
      puppet.options="--verbose"
  end

end
