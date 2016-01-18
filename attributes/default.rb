#node.default['elkstack']['config']['custom_logstash']['name'].push('nginx')
#default['elkstack']['config']['custom_logstash']["nginx"]['name'] = 'nginx'
#default['elkstack']['config']['custom_logstash']["nginx"]['source'] = 'input_nginx.conf.erb'
#default['elkstack']['config']['custom_logstash']["nginx"]['cookbook'] = 'host-gatewayos'
#default['elkstack']['config']['custom_logstash']["nginx"]['variables'] = {}

default['nginx']['client_max_body_size']= '15m'
default['nginx_conf']['pre_socket'] = ''
default['nginx_conf']['options'] = {}