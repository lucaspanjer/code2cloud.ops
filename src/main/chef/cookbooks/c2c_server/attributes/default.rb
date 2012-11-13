default[:c2c][:server][:home] = "/home/code2cloud"
default[:c2c][:server][:opt] = "/opt/code2cloud"
default[:c2c][:server][:job] = "Server"
default[:c2c][:server][:build] = nil #artifacts are not deployed unless build# is configured
default[:c2c][:server][:version] = "1.1.0-SNAPSHOT"
default[:c2c][:server][:root_dir] = "com.tasktop.c2c.server"
default[:c2c][:server][:root_package] = "com.tasktop.c2c.server"
default[:c2c][:server][:artifacts] = []
default[:c2c][:server][:deploy] = true
default[:c2c][:server][:deploy_type] = "dist"
default[:c2c][:user] = "vcloud"
default[:c2c][:group] = "vcloud"
default[:c2c][:user_home_prefix] = "/home"
default[:c2c][:user_home] = "/home/#{node.c2c.user}"
default[:c2c][:server][:backup][:enabled] = true
#NOTE to get dirs added you should override in the roles (not cookbooks) so that all are merged when multiple roles on the same machine
default[:c2c][:server][:backup][:directories] = []
default[:c2c][:server][:backup][:key_name] = "Code2Cloud"
default[:c2c][:server][:s3][:access_key_id] = ""
default[:c2c][:server][:s3][:access_key_secret] = ""
default[:c2c][:server][:email_log_errors_to_admin] = false
default[:c2c][:server][:opt_sym_links] = []
default[:c2c][:server][:jdbc_type] = "mysql\\:"
default[:c2c][:server][:jdbc_port] = "3306"
default[:c2c][:server][:jdbc_path] = ""
  
override[:tomcat][:java_options] = "-Xmx2048M -Xss192K -XX:MaxPermSize=512M -Dlog4j.configuration=file://#{node.c2c.server.opt}/etc/log4j.xml"

default[:c2c][:server][:tomcat][:jmx_config] = ""
default[:c2c][:server][:tomcat][:catalina][:jmx_remote] = ""
default[:c2c][:server][:tomcat][:catalina][:jmx_remote_authenticate] = ""
default[:c2c][:server][:tomcat][:catalina][:jmx_remote_ssl] = "" 