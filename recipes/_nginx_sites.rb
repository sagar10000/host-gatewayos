#
# Cookbook Name:: host-gateway
# Recipe:: default
#
# Copyright (C) 2014 YOUR_NAME
#
# All rights reserved - Do Not Redistribute
#

environment = node.environment
app_host_name = "summerschool2015-app"

app_host = db_host = search(:node, "name:#{ app_host_name } AND chef_environment:#{environment}").sort.first
if not app_host.nil?
	nginx_conf_file "summerschool2015.informatik.uni-wuerzburg.de" do
	  socket "http://#{ app_host[:ipaddress] }:3000"
	end
end

nginx_site 'default' do
  enable false
end

%w(itc28.org www.itc28.org i-teletraffic.org i-teletraffic.org).each do |external_domain|
	nginx_conf_file external_domain do
	  socket "http://132.187.12.29:8080"
  end
end

nginx_conf_file "crowdios.informatik.uni-wuerzburg.de" do
  socket "http://172.16.200.90"
end

nginx_conf_file "taskios.informatik.uni-wuerzburg.de" do
  socket "http://172.16.200.92"
end

nginx_conf_file "zae-nutzerumfrage.informatik.uni-wuerzburg.de" do
  socket "http://172.16.200.89"
end

nginx_conf_file "streamsurveyos.informatik.uni-wuerzburg.de" do
  socket "http://172.16.200.91:8080"
end

nginx_conf_file "whatsanalyzer.informatik.uni-wuerzburg.de" do
  socket "http://132.187.12.136:8080"
end

nginx_conf_file "whatsanalyser.informatik.uni-wuerzburg.de" do
  socket "http://132.187.12.136:8080"
end

nginx_conf_file "youtubedb.informatik.uni-wuerzburg.de" do
  socket "http://172.17.4.14:5601"
end

# nginx_conf_file "vallos.informatik.uni-wuerzburg.de" do
#   socket "http://172.16.48.210:8080"
# end

nginx_conf_file "videotensiontest.informatik.uni-wuerzburg.de" do
  socket "http://172.16.36.10:8080"
end

nginx_conf_file "yomoappos.informatik.uni-wuerzburg.de" do
  socket "http://172.17.2.87"
end



sites = search(:proxy, "nginx:*")
sites.each do |site|
  log "Processing nginx proxy site #{site}"

  options = site['nginx']['options'] || {}

  acls = case site['nginx']['access']
               when "internet"
                 {}
               when "ls3"
                 {:allow => "132.187.12.0/24", :deny => "all"}
               else
                 {:allow => "132.187.0.0/16", :deny => "all"}
             end

  options.merge!(acls)

  begin
    cert_databag = chef_vault_item('certificates', site['name'])
  rescue
    cert_databag = nil
  end


  if cert_databag # we have SSL

    cert_bundle = cert_databag['crt']
    if cert_databag.has_key?('ca_bundle')
      cert_bundle << "\n"
      cert_bundle << cert_databag['ca_bundle']
    end

    nginx_conf_file site['name'] do
      listen "443"
      socket site['nginx']['backend']
      ssl(
        "public" => cert_bundle,
        "private" => cert_databag['key']
      )
      options options
    end


    nginx_conf_file site['name'] + "-redirect" do
      server_name site['name']
      site_type :static
      options(
          "return" => "301 https://$server_name$request_uri"
      )
    end

  else # no SSL
    log "no-certificate-for-#{site['name']}" do
      level :warn
      message "Missing SSL certificate for #{site['name']}. Setting up HTTP only."
    end

    nginx_conf_file site['name'] do
      server_name site['name']
      socket site['nginx']['backend']
      options options
    end

  end

end
