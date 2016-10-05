# -*- mode: ruby -*-
# # vi: set ft=ruby :

# blatantly inspired from https://github.com/coreos/coreos-vagrant/blob/master/Vagrantfile

ENV['VAGRANT_DEFAULT_PROVIDER'] = 'virtualbox'

vm_memory = 512
vm_cpus = 1

$update_channel = "alpha"
$image_version = "current"

Vagrant.configure("2") do |config|

  config.vm.box = "coreos-%s" % $update_channel
  config.vm.box_url = "https://storage.googleapis.com/%s.release.core-os.net/amd64-usr/%s/coreos_production_vagrant.json" % [$update_channel, $image_version]
  config.ssh.insert_key = false
  config.vm.box_check_update = false

  config.vm.provider :virtualbox do |vb|
    vb.memory = vm_memory
    vb.cpus = vm_cpus
    vb.linked_clone = true
    vb.check_guest_additions = false
    vb.functional_vboxsf = false
  end

  if Vagrant.has_plugin?("vagrant-vbguest") then
    config.vbguest.auto_update = false
  end

  (1..3).each do |n|
    lan_ip = "10.30.0.#{n+100}"
    config.vm.define "dc1-#{n}" do |config|
      config.vm.hostname = "dc1-#{n}"
      config.vm.network "private_network", ip: lan_ip
    end
  end
  
  (1..3).each do |n|
    lan_ip = "10.40.0.#{n+100}"
    config.vm.define "dc2-#{n}" do |config|
      config.vm.hostname = "dc2-#{n}"
      config.vm.network "private_network", ip: lan_ip
    end
  end

end
