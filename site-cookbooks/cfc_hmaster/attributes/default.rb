include_attribute "cfc_server"

default[:cfc][:service] = "hmaster"
default[:cfc][:hmaster][:builds_dir] = "#{node.cfc.server.home}/hudson-homes"

