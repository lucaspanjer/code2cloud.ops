include_recipe "cfc_server"

hudson_war = "#{node.cfc.server.opt}/configuration/template/hudson-war"

directory hudson_war do
  owner node.tomcat.user
  group node.tomcat.group
  recursive true
end

template "#{node.cfc.server.opt}/etc/hmaster.properties" do
  source "hmaster.properties.erb"
  owner node.cfc.user
  group node.tomcat.group
  mode 0660
  notifies :restart, "service[tomcat]"
end

template "#{node.cfc.server.opt}/bin/updateHudsonWars.sh" do
  source "updateHudsonWars.sh.erb"
  owner node.cfc.user
  group node.tomcat.group
  mode 0770
end

directory node.cfc.hmaster.builds_dir do
  owner node.tomcat.user
  group node.tomcat.group
  recursive true
end

directory "#{node.cfc.server.home}/temp" do
  owner node.tomcat.user
  group node.tomcat.group
end

hudson_home = "#{node.cfc.server.opt}/configuration/template/hudson-home"

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
  owner node.cfc.user
  group node.tomcat.group
  mode 0660
end

template "#{hudson_home}/config.xml" do
  source "config.xml.erb"
  owner node.cfc.user
  group node.tomcat.group
  mode 0660
end

cfc_ssh_key "#{node.cfc.user_home}/.ssh/id_rsa"
build_key_file = "#{node.cfc.server.opt}/etc/builder_id_rsa"
execute "cp #{node.cfc.user_home}/.ssh/id_rsa #{build_key_file}; chown #{node.tomcat.user}:#{node.tomcat.user} #{build_key_file}" do
  creates "#{build_key_file}"
end


package "zip"

cfc_server_deployment "hmaster" do 
  artifacts [ { "name" => "hudson-config",  "package" => "hudson.configuration.web" },
  { "name" => "hudson",  "package" => "hudson.web", "war" => "hudson",
    "versioned" => false, "location" => "#{hudson_war}/hudson.war" } ]
  action :deploy
  provider "cfc_server_#{node.cfc.server.deploy_type}"
end 
