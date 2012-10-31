default[:c2c][:service] = "db"
default[:c2c][:db][:mount] = "/home/code2cloud"
default[:c2c][:db][:datadir] = "#{node[:c2c][:db][:mount]}/mysql"
default[:c2c][:db][:database] = "profile"
