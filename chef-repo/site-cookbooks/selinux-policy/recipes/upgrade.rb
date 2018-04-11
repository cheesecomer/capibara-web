#
# Cookbook Name:: selinux-policy
# Recipe:: upgrade
#
# Copyright 2015, YOUR_COMPANY_NAME
#
# All rights reserved - Do Not Redistribute
#
package 'selinux-policy-targeted' do
  action :upgrade
end