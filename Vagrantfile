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
  # config.vm.box = 'centos7.2'
  # config.vm.box_url = 'https://github.com/CommanderK5/packer-centos-template/releases/download/0.7.2/vagrant-centos-7.2.box'
  config.vm.box = "bento/centos-7.2"
  config.vm.box_download_insecure = true
  config.vm.network 'forwarded_port', guest: 3000, host: 3000, auto_correct: true
  config.vm.network :public_network
  config.vm.synced_folder '.', '/vagrant/capibara', create: true, owner: 'vagrant', group: 'vagrant'

  config.omnibus.chef_version=:latest
  config.berkshelf.berksfile_path = './chef-repo/Berksfile'
  config.berkshelf.enabled = true
  config.vm.provision :chef_solo do |chef|
    chef.cookbooks_path = ['./chef-repo/cookbooks']
    chef.json = {
      nginx: {
        repo_source: 'epel'
      },
      redisio: {
        servers: [
          { name: 'master', port: '6379', unixsocket: '/tmp/redis.sock', unixsocketperm: '755'},
        ]
      },
      rbenv: {
        user_installs: [
          {
            user: 'vagrant',
            rubies: ['2.4.2'],
            global: '2.4.2',
            gems: {
              '2.4.2' => [ { name: 'bundler' } ]
            }
          }
        ]
      },
      mariadb: {
        use_default_repository: true,
        server_root_password: 'vagrant',
        mysqld: {
          options:{
            :'collation-server' => 'utf8mb4_bin',
            :'init-connect' => '\'SET NAMES utf8mb4\'',
            :'character-set-server' => 'utf8mb4'
          }
        },
      },
      capibara: {
        application_root: '/vagrant/capibara',
        application_user: 'vagrant',
        application_ruby_version: '2.4.2',
        mariadb: {
          databases: [
            { name: 'capibara_development', encoding: 'utf8mb4' },
            { name: 'capibara_test'       , encoding: 'utf8mb4' },
          ],
          users: [
            {
              name: 'capibara_dev',
              password: 'password',
              grants: [
                { host: 'localhost', database: 'capibara_development', privileges: [ :all ] }
              ]
            },
            {
              name: 'capibara_test',
              password: 'password',
              grants: [
                { host: 'localhost', database: 'capibara_test', privileges: [ :all ] }
              ]
            },
          ],
        }
      }
    }
    chef.run_list = [
      'selinux-policy::upgrade',
      'lang-ja',
      'git',
      'nginx',
      'rbenv',
      'redisio',
      'redisio::enable',
      'imagemagick::rmagick',
      'mariadb::server',
      'mariadb::client',
      'capibara'
    ]
  end
end
