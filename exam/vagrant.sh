#!/bin/bash

#Start the process by initialising vagrant  in your chosen directory
   vagrant init ubuntu/focal64

   cat <<EOF  >  Vagrantfile
Vagrant.configure("2") do |config|

  config.vm.define "slave" do |subconfig|

    subconfig.vm.hostname = "slave"
    subconfig.vm.box = "ubuntu/focal64"
    subconfig.vm.network "private_network", ip: "192.168.33.11"

    subconfig.vm.provision "shell", inline: <<-SHELL
    sudo apt-get update && sudo apt-get upgrade -y
    sudo apt install sshpass -y
    sudo sed -i 's/PasswordAuthentication no/PasswordAuthentication yes/' /etc/ssh/sshd_config
    sudo systemctl restart sshd
    sudo apt-get install -y avahi-daemon libnss-mdns
    SHELL
  end

  config.vm.define "master" do |subconfig|

    subconfig.vm.hostname = "master"
    subconfig.vm.box = "ubuntu/focal64"
    subconfig.vm.network "private_network", ip: "192.168.33.10"

    subconfig.vm.provision "shell", inline: <<-SHELL
    sudo apt-get update && sudo apt-get upgrade -y
    sudo apt-get install -y avahi-daemon libnss-mdns
    sudo apt install sshpass -y
   # sudo sed -i 's/PasswordAuthentication no/PasswordAuthentication yes/' /etc/ssh/sshd_config
   # sudo systemctl restart sshd
    SHELL
  end

    config.vm.provider "virtualbox" do |vb|
      vb.memory = "1024"
      vb.cpus = "2"
    end
end
EOF

#Spin up the slave and  master machine up
      vagrant up slave
      vagrant up  master

#SSH into the Master Machine
       vagrant ssh master
