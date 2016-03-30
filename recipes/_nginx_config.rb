template File.join(node['nginx']['dir'], 'conf.d', 'ssl.conf') do
  source 'ssl.conf.erb'
  notifies :reload, 'service[nginx]'
end

openssl_dhparam "/etc/ssl/private/dhparam.pem" do
  key_length 2048
  generator 2
  notifies :reload, 'service[nginx]'
end