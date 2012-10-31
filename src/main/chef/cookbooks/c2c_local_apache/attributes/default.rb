include_attribute "c2c_server"
include_attribute "apache2"

default[:c2c][:local_apache][:user] = node[:apache][:user]
