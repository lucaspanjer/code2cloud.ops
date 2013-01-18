
node.override[:tomcat][:java_options] = node[:c2c][:hudson][:tomcat][:jvm_options]
  
include_recipe "c2c_server"

c2c_log4j_config "hudson"

hudson_war = "#{node.c2c.server.opt}/configuration/template/hudson-war"
slave_options = node[:c2c][:hudson][:slave][:jvm_options]
      
if node.c2c.proxy_environment.http_proxy != false 
  slave_options = slave_options + " -Dhttp.proxyHost=#{node.c2c.proxy_environment.http_proxy}"
end

if node.c2c.proxy_environment.http_proxy_port != false
  slave_options = slave_options + " -Dhttp.proxyPort=#{node.c2c.proxy_environment.http_proxy_port}"
end

if node.c2c.proxy_environment.https_proxy != false
  slave_options = slave_options + " -Dhttps.proxyHost=#{node.c2c.proxy_environment.https_proxy}"
end

if node.c2c.proxy_environment.https_proxy_port != false
  slave_options = slave_options + " -Dhttps.proxyPort=#{node.c2c.proxy_environment.https_proxy_port}"
end

if node.c2c.proxy_environment.no_proxy_prefix != false
  slave_options = slave_options + " -Dhttp.nonProxyHosts=#{node.c2c.proxy_environment.no_proxy_prefix}" + c2c_role_address("profile") + "|" + c2c_role_address("profile")
end

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

template "#{node.c2c.server.opt}/bin/updateHudsonWars.rb" do
  source "updateHudsonWars.rb.erb"
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

c2c_mail_sender_password=  data_bag_item("secrets", "passwords")["c2c_mail_sender_password"]

template "#{hudson_home}/hudson.tasks.Mailer.xml" do
  source "hudson.tasks.Mailer.xml.erb"
  variables :c2c_mail_sender_password => c2c_mail_sender_password
  owner node.c2c.user
  group node.tomcat.group
  mode 0660
end

template "#{hudson_home}/config.xml" do
  source "config.xml.erb"
  owner node.c2c.user
  group node.tomcat.group
  variables :slave_options => slave_options
  mode 0660
end

c2c_ssh_key "#{node.c2c.user_home}/.ssh/id_rsa"
build_key_file = "#{node.c2c.server.opt}/etc/builder_id_rsa"
execute "cp #{node.c2c.user_home}/.ssh/id_rsa #{build_key_file}; chown #{node.tomcat.user}:#{node.tomcat.user} #{build_key_file}" do
  creates "#{build_key_file}"
end


package "zip"

if node.c2c.hudson.update_hudson_wars
  hudson_war_artifact = { "name" => "hudson-war",  "package" => "hudson.web", "war" => "hudson-war",
  "location" => "#{hudson_war}/hudson.war", "script" => "#{node.c2c.server.opt}/bin/updateHudsonWars.rb" } 
  else
  hudson_war_artifact = { "name" => "hudson-war",  "package" => "hudson.web", "war" => "hudson-war",
  "location" => "#{hudson_war}/hudson.war" } 
end

c2c_server_deployment "hmaster" do 
  artifacts [ { "name" => "hudson-config",  "package" => "hudson.configuration.web" }, hudson_war_artifact]
  action :deploy
  provider "c2c_server_#{node.c2c.server.deploy_type}"
end 
