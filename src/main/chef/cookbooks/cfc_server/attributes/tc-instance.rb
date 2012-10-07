default[:cfc][:tomcat][:instance_name] = "tomcat6"
default[:cfc][:tomcat][:instance_base] =  "/var/lib/#{node.cfc.tomcat.instance_name}"
default[:cfc][:tomcat][:instance_webapps] =  "#{node.cfc.tomcat.instance_base}/webapps"
default[:cfc][:tomcat][:port] = "8081"
default[:cfc][:tomcat][:ajp_port] = "8010"
default[:cfc][:tomcat][:ssl_port] = "8444"
default[:cfc][:tomcat][:shutdown_port] = "8006"
default[:cfc][:tomcat][:connection_timeout] = "20000"
default[:cfc][:tomcat][:authbind] = "no"