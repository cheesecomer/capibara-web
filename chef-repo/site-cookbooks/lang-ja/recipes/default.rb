#
# Cookbook Name:: lang-ja
# Recipe:: default
#
# Copyright 2015, YOUR_COMPANY_NAME
#
# All rights reserved - Do Not Redistribute
#
execute "yum-groupinstall 'Japanese Support'" do
  user "root"
  command "yum -y groupinstall 'Japanese Support'"
  action :run
end

package "man-pages-ja" do
  action :install
end

execute "localedef" do
  user "root"
  command "localedef -f UTF-8 -i ja_JP ja_JP.utf8"
  action :run
end

bash 'locale' do
  user 'root'
  code <<-EOC
cp -p /etc/sysconfig/i18n /etc/sysconfig/i18n.old
cat /etc/sysconfig/i18n.old | sed 's/LANG.*$/LANG="ja_JP.utf8"/' > /etc/sysconfig/i18n
  EOC
  not_if "grep -q ja_JP /etc/sysconfig/i18n"
end

# bash "/etc/locale.conf" do
#   code "source /etc/locale.conf"
# end

bash 'timezone' do
  user 'root'
  code <<-EOC
cp -p /etc/localtime /etc/localtime.old
cp /usr/share/zoneinfo/Asia/Tokyo /etc/localtime
  EOC
  not_if "strings /etc/localtime | grep -q 'JST'"
end

