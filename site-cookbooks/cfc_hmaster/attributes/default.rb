include_attribute "cfc_server"

default[:cfc][:service] = "hmaster"
default[:cfc][:hmaster][:builds_dir] = "#{node.cfc.server.home}/hudson-homes"
default[:cfc][:hudson][:path] = "/s/"
default[:cfc][:hudson][:tomcat][:jvm_options] = "-Xmx2048M -Xss192K -XX:MaxPermSize=1024M"
    


