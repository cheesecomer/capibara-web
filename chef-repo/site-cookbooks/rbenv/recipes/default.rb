#
# Cookbook:: rbenv
# Recipe:: default
#
# Copyright:: 2017, The Authors, All Rights Reserved.

# rbenv_system_install 'system'

# # Install rbenv and makes it avilable to the selected user
# version = '2.4.2'

node[:rbenv][:user_installs].each do |user_install|
  install_user = user_install[:user]
  # Keeps the rbenv install upto date
  rbenv_user_install install_user do
    user install_user
  end

  rbenv_plugin 'ruby-build' do
    git_url 'https://github.com/rbenv/ruby-build.git'
    user install_user
  end

  user_install[:rubies].each do |ruby|
    rbenv_ruby ruby do
      user install_user
    end
  end

  rbenv_global user_install[:global] do
    user install_user
  end

  user_install[:gems].each do |ruby, gems|
    gems.each do |gem|
      rbenv_gem gem[:name] do
        user install_user
        rbenv_version ruby
      end
    end
  end

  rbenv_rehash 'rehash' do
    user install_user
  end
end