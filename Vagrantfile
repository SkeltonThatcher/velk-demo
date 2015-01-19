# -*- mode: ruby -*- # vi: set ft=ruby :
# Vagrantfile API/syntax version. Don't touch unless you know what you're doing!

VAGRANTFILE_API_VERSION = "2" 

Vagrant.configure(VAGRANTFILE_API_VERSION) do |config| 

config.ssh.shell = "bash -c 'BASH_ENV=/etc/profile exec bash'"

config.vm.box = "ubuntu/trusty64"

config.vm.network :forwarded_port, guest: 9200, host: 9200 

config.vm.network :forwarded_port, guest: 2200, host: 2020

config.vm.network "private_network", ip: "172.28.128.3" 

config.ssh.forward_agent = true # If true, then any SSH connections made will enable agent forwarding. # Default value: false #

config.vm.provider "virtualbox" do |vb| 

        vb.name = "velk-demo_vm" # Name of the virtualbox machine 
        vb.gui = true # Don't boot in headless mode
        vb.memory = 3048 # Amount of memory in MB to allocate the VM
        vb.cpus = 2 # Number of CPUs in the VirtualBox
end 

config.vm.provision :shell, :path => "bootstrap.sh"

end
