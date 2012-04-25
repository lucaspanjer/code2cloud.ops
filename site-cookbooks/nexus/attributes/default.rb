include_attribute "cfc_server"

#http://nexus.sonatype.org/downloads/older/nexus-oss-webapp-1.9.1.1-bundle.tar.gz
default[:nexus][:port] = "7070"# FIXME "#{node[:cfc][:nexus][:port]}"
default[:nexus][:host] = "0.0.0.0"
default[:nexus][:work] = "#{node.cfc.server.home}/m2-repo"
default[:nexus][:root_dir] = "#{node.cfc.server.opt}"
default[:nexus][:user] = "vcloud" #XXX >> role
default[:nexus][:jsw_arch] = "linux-x86-64" #XXX
default[:nexus][:mirror] = "http://nexus.sonatype.org/downloads/older"
default[:nexus][:version] = "1.9.1.1"
default[:nexus][:wrapper][:ping][:timeout] = 180
default[:nexus][:wrapper][:startup][:timeout] = 180
default[:nexus][:subdir] = "nexus-oss-webapp-#{node[:nexus][:version]}"
default[:nexus][:path] = "#{node[:nexus][:root_dir]}/#{node[:nexus][:subdir]}"
default[:nexus][:bin] = "#{node[:nexus][:path]}/bin"
default[:nexus][:package] = "#{node[:nexus][:subdir]}-bundle.tar.gz"
default[:nexus][:url] = "#{node[:nexus][:mirror]}/#{node[:nexus][:package]}"
default[:nexus][:wrapper_cmd] = "#{node[:nexus][:bin]}/jsw/#{node[:nexus][:jsw_arch]}/wrapper"
default[:nexus][:wrapper_conf] = "#{node[:nexus][:bin]}/jsw/conf/wrapper.conf"
default[:nexus][:piddir] = "/var/run"
