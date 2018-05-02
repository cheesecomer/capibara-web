# -*- mode: ruby -*-
# vi: set ft=ruby :

# All Vagrant configuration is done below. The '2' in Vagrant.configure
# configures the configuration version (we support older styles for
# backwards compatibility). Please don't change it unless you know what
# you're doing.
Vagrant.configure('2') do |config|
  # The most common configuration options are documented and commented below.
  # For a complete reference, please see the online documentation at
  # https://docs.vagrantup.com.

  # Every Vagrant development environment requires a box. You can search for
  # boxes at https://atlas.hashicorp.com/search.
  config.vm.box = "centos/7"
  config.vm.box_download_insecure = true
  config.vm.network 'forwarded_port', guest: 80, host: 3000, auto_correct: true
  config.vm.synced_folder '.', '/vagrant/capibara', create: true, owner: 'vagrant', group: 'vagrant'
  config.vm.provision "shell", inline: <<-SHELL
  if [ ! -e '/usr/bin/docker' ]; then
    echo '################################################################################'
    echo '#  Install Docker'
    echo '################################################################################'
    if [ ! -e '/etc/yum.repos.d/docker-ce.repo' ]; then
      yum-config-manager --add-repo https://download.docker.com/linux/centos/docker-ce.repo && yum makecache fast
    fi

    yum install -y yum-utils device-mapper-persistent-data lvm2
    yum install -y docker-ce-18.03.0.ce-1.el7.centos

    usermod -aG docker vagrant

    systemctl enable docker
    systemctl start docker
  fi

  if [ ! -e '/usr/local/bin/docker-compose' ]; then
    echo '################################################################################'
    echo '#  Install Docker-Compose'
    echo '################################################################################'
    curl -L https://github.com/docker/compose/releases/download/1.20.1/docker-compose-`uname -s`-`uname -m` -o /usr/local/bin/docker-compose && chmod +x /usr/local/bin/docker-compose
  fi
SHELL
end
