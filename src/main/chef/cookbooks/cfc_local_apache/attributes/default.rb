include_attribute "cfc_server"
include_attribute "apache2"

default[:cfc][:local_apache][:user] = node[:apache][:user]
