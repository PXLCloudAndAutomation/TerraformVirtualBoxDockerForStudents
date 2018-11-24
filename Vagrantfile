# -*- mode: ruby -*-
# # vi: set ft=ruby :

Vagrant.configure("2") do |config|
  config.vm.box = "centos/7"

  # Add an extra NIC to bypass all the port related issues.
  # Instead of using 127.0.0.1, just connect to the IP assigned to this NIC.
  # The get_vm_info.sh script will help to discover all the necessary info.
  config.vm.network "private_network", type: "dhcp"
  
  config.vm.provider "virtualbox" do |vm|
    vm.name = "CnACentOSWithDockerTCP"
    vm.memory = 1024
    vm.cpus = 2
  end

  # Set the LANG correct (Otherwise ssh sessions could be flooded with warnings.)
  # Install docker and let its daemon listen to ALL IPs (0.0.0.0) on port 2375.
  # It's relative safe to do this here, the first NIC is behind a NAT router.
  # So the only direct TCP conections are possible via the private_network.
  # Don't do this on publicly available server, dockerd does not require authentication!
  config.vm.provision "shell", inline: <<-EOF
    echo 'LANG=en_US.utf-8' >> /etc/environment
    echo 'LC_ALL=en_US.utf-8' >> /etc/environment
    mkdir /etc/systemd/system/docker.service.d
    echo '[Service]' >> /etc/systemd/system/docker.service.d/docker.conf
    echo 'ExecStart=' >> /etc/systemd/system/docker.service.d/docker.conf
    echo 'ExecStart=/usr/bin/dockerd -H tcp://0.0.0.0:2375 -H unix://var/run/docker.sock' >> /etc/systemd/system/docker.service.d/docker.conf
    yum install -y yum-utils device-mapper-persistent-data lvm2
    yum-config-manager --add-repo https://download.docker.com/linux/centos/docker-ce.repo
    yum install -y docker-ce
    yum install -y git
    systemctl start docker
    systemctl daemon-reload
    systemctl restart docker.service
    systemctl enable docker
  EOF
end
