include_attribute "c2c_server"

default[:c2c][:service] = "hmaster"
default[:c2c][:hmaster][:builds_dir] = "#{node.c2c.server.home}/hudson"
default[:c2c][:hudson][:path] = "s"
default[:c2c][:hudson][:multi_tenant] = true 
default[:c2c][:hudson][:perOrg] = false 
default[:c2c][:hudson][:tomcat][:jvm_options] = "-Xmx2048M -Xss192K -XX:MaxPermSize=1024M"
default[:c2c][:hudson][:slave][:jvm_options] = ""
default[:c2c][:hudson][:update_hudson_wars] = true
default[:c2c][:hudson][:update_plugins] = true
default[:c2c][:hudson][:update_config] = true
default[:c2c][:hudson][:additional_properties] = []

    


