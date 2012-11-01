include_attribute "c2c_server"

default[:c2c][:service] = "hmaster"
default[:c2c][:hmaster][:builds_dir] = "#{node.c2c.server.home}/hudson-homes"
default[:c2c][:hudson][:path] = "/s/"
default[:c2c][:hudson][:tomcat][:jvm_options] = "-Xmx2048M -Xss192K -XX:MaxPermSize=1024M"
    

