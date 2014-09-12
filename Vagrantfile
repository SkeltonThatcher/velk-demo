# -*- mode: ruby -*- # vi: set ft=ruby :
# Vagrantfile API/syntax version. Don't touch unless you know what you're doing!
VAGRANTFILE_API_VERSION = "2" 

Vagrant.configure(VAGRANTFILE_API_VERSION) do |config| 

config.vm.box = "ubuntu/trusty64"

config.vm.network :forwarded_port, guest: 9200, host: 9200 

config.vm.network :forwarded_port, guest: 2200, host: 22 

config.vm.network "private_network", type: "dhcp" # If true, then any SSH connections made will enable agent forwarding. # Default value: false # 

config.ssh.forward_agent = true 

config.vm.provider "virtualbox" do |vb| 

        vb.name = "elasticsearch_vm" # Don't boot with headless mode 
        vb.gui = true # Tweak the below value to adjust RAM 
        vb.memory = 4096 # Tweak the number of processors below 
        vb.cpus = 2 # Use VBoxManage to customize the VM. For example to change memory: #vb.customize ["modifyvm", :id, "--memory", "1024"]
end 

config.vm.provision :shell, :path => "bootstrap.sh"

end
