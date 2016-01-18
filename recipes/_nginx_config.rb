template File.join(node['nginx']['dir'], 'conf.d', 'ssl.conf') do
  source 'ssl.conf.erb'
  notifies :reload, 'service[nginx]'
end