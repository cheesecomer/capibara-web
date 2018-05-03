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
  config.vm.provision "shell", privileged: false, inline: <<-SHELL
  if [ ! -e '/usr/bin/docker' ]; then
    echo '################################################################################'
    echo '#  Install Docker'
    echo '################################################################################'
    echo ' '
    echo ' '
    echo ' '
    if [ ! -e '/etc/yum.repos.d/docker-ce.repo' ]; then
      sudo yum-config-manager --add-repo https://download.docker.com/linux/centos/docker-ce.repo && yum makecache fast
    fi

    sudo yum install -y yum-utils device-mapper-persistent-data lvm2 && \
    sudo yum install -y docker-ce-18.03.0.ce-1.el7.centos && \
    sudo usermod -aG docker vagrant && \
    sudo systemctl enable docker && \
    sudo systemctl start docker
  fi

  if [ ! -e '/usr/bin/docker-compose' ]; then
    echo '################################################################################'
    echo '#  Install Docker-Compose'
    echo '################################################################################'
    echo ' '
    echo ' '
    echo ' '
    sudo curl -L https://github.com/docker/compose/releases/download/1.20.1/docker-compose-`uname -s`-`uname -m` -s -o /usr/bin/docker-compose && \
    sudo chmod +x /usr/bin/docker-compose
  fi

  if [ ! -e '/usr/bin/aws' ]; then
    echo '################################################################################'
    echo '#  Install AWS CLI'
    echo '################################################################################'
    echo ' '
    echo ' '
    echo ' '
    curl https://bootstrap.pypa.io/get-pip.py -s -o get-pip.py && \
    sudo python get-pip.py && \
    suco pip install awscli && \
    sudo rm get-pip.py
  fi

  cd /vagrant/capibara
  docker-compose --version
  if [ $(docker-compose images |tail -n +3|wc -l) = 0 ]; then docker-compose build; fi
  docker-compose images
  docker-compose run workspace bundle install -j4
SHELL
end
