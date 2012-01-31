#knife bootstrap --template-file .chef/cfc-template.erb --sudo -x vcloud -P passwurd -r 'role[cfc-base]'

cfc_env                  'tt'
#used for chef_server_url in bootstrap'd nodes
cfc_chef_servers         'tt' => '192.168.0.152'
cfc_chef_address          Chef::Config[:cfc_chef_servers][ Chef::Config[:cfc_env] ]

log_level                :info
log_location             STDOUT
node_name                'cmorgan'
client_key               "#{Chef::Config[:cfc_env]}/vcloud.pem"
validation_client_name   'chef-validator'
validation_key           ".chef/#{Chef::Config[:cfc_env]}/validation.pem"
#chef_server_url is set to localhost, assuming an ssh tunnel into mozy's env:
#ssh -2 -N -C vcloud@172.31.33.176 -L 4000:127.0.0.1:4000
chef_server_url          'http://localhost:4000'
cache_type               'BasicFile'
cache_options( :path => '.chef/checksums' )
