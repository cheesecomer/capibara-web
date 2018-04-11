#
# Cookbook:: capibara
# Recipe:: default
#
# Copyright:: 2017, The Authors, All Rights Reserved.

root_password = node['mariadb']['server_root_password']

node[:capibara][:mariadb][:databases].each do |database|
  execute "CREATE DATABASE #{database[:name]} CHARACTER SET #{database[:encoding]}" do
    command "mysql -u root -p#{root_password} -e 'CREATE DATABASE #{database[:name]} CHARACTER SET #{database[:encoding]};'"
    not_if "mysql -u root -p#{root_password} -e 'SHOW DATABASES' -N | grep #{database[:name]}"
  end
end

node[:capibara][:mariadb][:users].each do |user|
  execute "CREATE USER #{user[:name]} IDENTIFIED BY *****" do
    command "mysql -u root -p#{root_password} -e 'CREATE USER #{user[:name]} IDENTIFIED BY \"#{user[:password]}\";'"
    not_if "mysql -u root -p#{root_password} -e 'select distinct user from mysql.user;' -N | grep #{user[:name]}"
  end
  user[:grants].each do |grant|
    execute "GRANT #{grant[:privileges].join(', ')} ON #{grant[:database]}.* TO #{user[:name]}" do
      command "mysql -u root -p#{root_password} -e 'GRANT #{grant[:'privileges'].join(', ')} ON #{grant[:database]}.* TO #{user[:name]};'"
    end
  end
end

user = node[:capibara][:application_user]
ruby = node[:capibara][:application_ruby_version]
rbenv_script "chown /home/#{user}/.rbenv/" do
  rbenv_version ruby
  user          'root'
  group         'root'
  code          "chown -R #{user} /home/#{user}/.rbenv/"
end

rbenv_script "bundle install" do
  rbenv_version ruby
  user          user
  group         user
  cwd           node[:capibara][:application_root]
  code          "/home/#{user}/.rbenv/versions/#{ruby}/bin/bundle install"
  not_if        "/home/#{user}/.rbenv/versions/#{ruby}/bin/bundle check"
end

rbenv_script "rake db:migrate" do
  rbenv_version ruby
  user          user
  group         user
  cwd           node[:capibara][:application_root]
  code          "/home/#{user}/.rbenv/versions/#{ruby}/bin/rake db:migrate"
  not_if        "/home/#{user}/.rbenv/versions/#{ruby}/bin/bundle check"
end

