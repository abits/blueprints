Vagrant.configure("2") do |config|
  config.vm.box = "wheezy64"

  config.vm.box_url = "http://files.codeways.org/wheezy64.box"

  config.vm.network :private_network, ip: "33.33.33.10"

  config.vm.synced_folder(".", "/vagrant", id: "vagrant-root", :nfs => true, :nfs_version => 4)

  config.vm.provision :puppet do |puppet|
      puppet.module_path = "puppet/modules"
      puppet.manifests_path = "puppet/manifests"
      puppet.manifest_file = "default.pp"
      puppet.options="--verbose"
  end
end
