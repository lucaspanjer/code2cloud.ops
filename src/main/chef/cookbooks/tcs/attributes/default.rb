default[:tcs][:root_dir] = "/opt/code2cloud"
default[:tcs][:instance] = "alm-services" #tcs instance $name
default[:tcs][:service] = "alm-services" #/etc/init.d/$name
default[:tcs][:user] = "vcloud"
default[:tcs][:group] = node[:tcs][:user]

default[:tcs][:version] = "2.1.2.RELEASE"
default[:tcs][:flavor] = "developer"

default[:tcs][:config]["base.shutdown.port"] = 8005
default[:tcs][:config]["bio.http.port"] = 8080
default[:tcs][:config]["bio.https.port"] = 8443
default[:tcs][:config]["ajp.port"] = 8009
default[:tcs][:config]["base.jmx.port"] = 6969

default[:tcs][:env][:agent_paths] = ""
default[:tcs][:env][:java_agents] = ""
default[:tcs][:env][:java_library_path] = ""
default[:tcs][:env][:jvm_opts] = ""

#base url where we can download tc-server.tar.gz
default[:tcs][:mirror] = "http://#{URI.parse(Chef::Config[:chef_server_url]).host}/c2c"
