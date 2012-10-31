include_attribute "c2c_server"

default[:c2c][:service] = "dmz"

override[:apache][:worker][:startservers] = 2
override[:apache][:worker][:maxclients] = 150
override[:apache][:worker][:minsparethreads] = 25
override[:apache][:worker][:maxsparethreads] = 75
override[:apache][:worker][:threadsperchild] = 25
override[:apache][:worker][:maxrequestsperchild] = 0

default[:c2c][:dmz][:user] = "apache"
default[:c2c][:dmz][:servername] = "c2c.tasktop.com"
default[:c2c][:dmz][:mode] = "normal"
default[:c2c][:dmz][:home] = "#{node.c2c.server.home}"
default[:c2c][:dmz][:git_repo] = "#{c2c.artifacts.base_url}/scm/code2cloud.static.git"
default[:c2c][:dmz][:ssl] = false