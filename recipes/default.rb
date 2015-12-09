#
# Cookbook Name:: host-gateway
# Recipe:: default
#
# Copyright (C) 2014 YOUR_NAME
#
# All rights reserved - Do Not Redistribute
#

include_recipe "ls3-defaults"
include_recipe "nginx"
include_recipe "nginx_conf"

route "172.0.0.0/8" do
	gateway "172.16.200.1"
end


node.default[:nginx_conf][:pre_socket] = 'http://'

environment = node.environment
app_host_name = "summerschool2015-app"

app_host = db_host = search(:node, "name:#{ app_host_name } AND chef_environment:#{environment}").sort.first
if not app_host.nil?
	nginx_conf_file "summerschool2015.informatik.uni-wuerzburg.de" do
	  socket "#{ app_host[:ipaddress] }:3000"
	end
end

nginx_site 'default' do
  enable false
end

%w(itc28.org www.itc28.org beta.i-teletraffic.org itc25.com www.itc25.com).each do |external_domain|
	nginx_conf_file external_domain do
	  socket "132.187.12.29:8080"
	end
end

nginx_conf_file "crowdios.informatik.uni-wuerzburg.de" do
  socket "172.16.200.90"
end

nginx_conf_file "taskios.informatik.uni-wuerzburg.de" do
  socket "172.16.200.92"
end

nginx_conf_file "zae-nutzerumfrage.informatik.uni-wuerzburg.de" do
  socket "172.16.200.89"
end

nginx_conf_file "streamsurveyos.informatik.uni-wuerzburg.de" do
  socket "172.16.200.91:8080"
end

nginx_conf_file "whatsanalyzer.informatik.uni-wuerzburg.de" do
  socket "132.187.12.136:8080"
end

nginx_conf_file "whatsanalyser.informatik.uni-wuerzburg.de" do
  socket "132.187.12.136:8080"
end

nginx_conf_file "youtubedb.informatik.uni-wuerzburg.de" do
  socket "172.17.4.14:5601"
end

nginx_conf_file "ls3cloud1.informatik.uni-wuerzburg.de" do
  socket "132.187.12.10"
end

nginx_conf_file "vallos.informatik.uni-wuerzburg.de" do
  socket "172.16.48.210:8080"
end



