include_attribute "cfc_server"

default[:cfc][:service] = "dmz"

override[:apache][:worker][:startservers] = 2
override[:apache][:worker][:maxclients] = 150
override[:apache][:worker][:minsparethreads] = 25
override[:apache][:worker][:maxsparethreads] = 75
override[:apache][:worker][:threadsperchild] = 25
override[:apache][:worker][:maxrequestsperchild] = 0

default[:cfc][:dmz][:servername] = "c2c.tasktop.com"
default[:cfc][:dmz][:mode] = "normal"
default[:cfc][:dmz][:home] = "#{node.cfc.server.home}"
default[:cfc][:dmz][:git_repo] = "#{cfc.artifacts.base_url}/scm/code2cloud.static.git"
