default[:cfc][:server][:home] = "/home/code2cloud"
default[:cfc][:server][:opt] = "/opt/code2cloud"
default[:cfc][:server][:job] = "Server"
default[:cfc][:server][:build] = nil #artifacts are not deployed unless build# is configured
default[:cfc][:server][:version] = "0.1.0-SNAPSHOT"
default[:cfc][:server][:root_dir] = "com.tasktop.c2c.server"
default[:cfc][:server][:root_package] = "com.tasktop.c2c.server"
default[:cfc][:server][:artifacts] = []
default[:cfc][:server][:deploy] = false
default[:cfc][:artifacts][:base_url] = "fixme"
default[:cfc][:user] = "vcloud"
default[:cfc][:group] = "vcloud"
default[:cfc][:user_home_prefix] = "/home"
default[:cfc][:user_home] = "/home/#{node.cfc.user}"
default[:cfc][:server][:backup][:enabled] = true
#NOTE to get dirs added you should override in the roles (not cookbooks) so that all are merged when multiple roles on the same machine
default[:cfc][:server][:backup][:directories] = []
default[:cfc][:server][:backup][:key_name] = "Code2Cloud"
default[:cfc][:server][:s3][:access_key_id] = ""
default[:cfc][:server][:s3][:access_key_secret] = ""
default[:cfc][:server][:email_log_errors_to_admin] = false
default[:cfc][:server][:opt_sym_links] = []
default[:cfc][:server][:jdbc_type] = "mysql\\:"
default[:cfc][:server][:jdbc_port] = "3306"
default[:cfc][:server][:jdbc_path] = ""
  
override[:tomcat][:java_options] = "-Xmx2048M -Xss192K -XX:MaxPermSize=512M -Dlog4j.configuration=file://#{node.cfc.server.opt}/etc/log4j.xml"

default[:cfc][:server][:tomcat][:jmx_config] = ""
default[:cfc][:server][:tomcat][:catalina][:jmx_remote] = ""
default[:cfc][:server][:tomcat][:catalina][:jmx_remote_authenticate] = ""
default[:cfc][:server][:tomcat][:catalina][:jmx_remote_ssl] = "" 