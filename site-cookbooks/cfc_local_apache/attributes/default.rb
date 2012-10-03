include_attribute "cfc_server"
include_attribute "apache"

default[:cfc][:local_apache][:user] = node[:apache][:user]
