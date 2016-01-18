include_recipe "nginx"
include_recipe "nginx_conf"

include_recipe "#{cookbook_name}::_nginx_config"
include_recipe "#{cookbook_name}::_nginx_sites"