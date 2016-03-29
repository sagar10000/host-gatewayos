#
# Cookbook Name:: host-gateway
# Recipe:: default
#
# Copyright (C) 2014 YOUR_NAME
#
# All rights reserved - Do Not Redistribute
#

include_recipe "ls3-defaults"

include_recipe "#{cookbook_name}::_nginx"

route "172.16.0.0/12" do
  gateway "172.16.200.1"
end
