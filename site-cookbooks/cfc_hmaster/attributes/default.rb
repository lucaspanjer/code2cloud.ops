include_attribute "cfc_server"

default[:cfc][:service] = "hmaster"
default[:cfc][:hmaster][:builds_dir] = "#{node.cfc.server.home}/hudson-homes"
  
override[:tomcat][:java_options] = "-Xmx2048M -Xss192K -XX:MaxPermSize=1024M -Dlog4j.configuration=file://#{node.cfc.server.opt}/etc/log4j.xml"

