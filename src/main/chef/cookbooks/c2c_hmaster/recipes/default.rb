
node.override[:tomcat][:java_options] = node[:c2c][:hudson][:tomcat][:jvm_options] + " -Dlog4j.configuration=file://#{node.c2c.server.opt}/etc/log4j.xml"
  
include_recipe "c2c_server"

hudson_war = "#{node.c2c.server.opt}/configuration/template/hudson-war"

directory hudson_war do
  owner node.tomcat.user
  group node.tomcat.group
  recursive true
end

template "#{node.c2c.server.opt}/etc/hmaster.properties" do
  source "hmaster.properties.erb"
  owner node.c2c.user
  group node.tomcat.group
  mode 0660
  notifies :restart, "service[tomcat]"
end

template "#{node.c2c.server.opt}/bin/updateHudsonWars.sh" do
  source "updateHudsonWars.sh.erb"
  owner node.c2c.user
  group node.tomcat.group
  mode 0770
end

directory node.c2c.hmaster.builds_dir do
  owner node.tomcat.user
  group node.tomcat.group
  recursive true
end

directory "#{node.c2c.server.home}/temp" do
  owner node.tomcat.user
  group node.tomcat.group
end

hudson_home = "#{node.c2c.server.opt}/configuration/template/hudson-home"

remote_directory hudson_home do
  source "hudson-home"
  files_owner node.tomcat.user
  files_group node.tomcat.user
  files_mode  0644
  owner node.tomcat.user
  group node.tomcat.user
  mode 0755
end

template "#{hudson_home}/hudson.tasks.Mailer.xml" do
  source "hudson.tasks.Mailer.xml.erb"
  owner node.c2c.user
  group node.tomcat.group
  mode 0660
end

template "#{hudson_home}/config.xml" do
  source "config.xml.erb"
  owner node.c2c.user
  group node.tomcat.group
  mode 0660
end

c2c_ssh_key "#{node.c2c.user_home}/.ssh/id_rsa"
build_key_file = "#{node.c2c.server.opt}/etc/builder_id_rsa"
execute "cp #{node.c2c.user_home}/.ssh/id_rsa #{build_key_file}; chown #{node.tomcat.user}:#{node.tomcat.user} #{build_key_file}" do
  creates "#{build_key_file}"
end


package "zip"

c2c_server_deployment "hmaster" do 
  artifacts [ { "name" => "hudson-config",  "package" => "hudson.configuration.web" },
  { "name" => "hudson-war",  "package" => "hudson.web", "war" => "hudson-war",
    "location" => "#{hudson_war}/hudson.war" } ]
  action :deploy
  provider "c2c_server_#{node.c2c.server.deploy_type}"
end 
