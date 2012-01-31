default[:cfc][:service] = "db"
default[:cfc][:db][:mount] = "/home/code2cloud"
default[:cfc][:db][:datadir] = "#{node[:cfc][:db][:mount]}/mysql"
default[:cfc][:db][:database] = "profile"
