#c2c_disk node.c2c.server.home #fdisk,etc /dev/sdb & mount

node.override[:tomcat][:http_connection_timeout] = "3600000"

include_recipe "c2c_server"

template "#{node.c2c.server.opt}/etc/scm.properties" do
  source "scm.properties.erb"
  owner node.c2c.user
  group node.tomcat.group
  mode 0660
  notifies :restart, "service[tomcat]"
end

directory "#{node.c2c.server.home}/git-root" do
  owner node.tomcat.user
  group node.tomcat.group
end

directory "#{node.c2c.server.home}/maven-repo" do
  owner node.tomcat.user
  group node.tomcat.group
end

c2c_server_deployment "scm" do 
  artifacts [ { "name" => "services", "package" => "services.web" } ]
  action :deploy
  provider "c2c_server_#{node.c2c.server.deploy_type}"
end