#require 'mysql'

#for service[ssh]
include_recipe "openssh"

#cookbook_file "/etc/ssh/sshd_config" do
#  owner "root"
#  group "root"
#  mode 0644
#  notifies :restart, "service[ssh]"
#end

node.override[:etchosts][:hub_entry] = node.c2c.hub.etc_hosts_entry
node.override[:c2c][:server][:jdbc_host] = "//" + node.c2c.hosts.db.ipaddress + "\\:" + node.c2c.server.jdbc_port + node.c2c.hub.jdbc_path
  
# This is only needed when we deploy the hub on the same VM as other services
if node.c2c.hub.has_internal_services
  link "#{node.c2c.server.opt}/hub_webapps" do
    to "#{node.tomcat.second_webapp_dir}"
    owner node.c2c.user
    group node.tomcat.group
  end
end

include_recipe "c2c_server"

c2c_log4j_config "hub"

profilePwd=data_bag_item("secrets", "passwords")["profile"]
node.set[:c2c][:hub][:profile_password] = profilePwd
github_consumer_secret=data_bag_item("secrets", "passwords")["github_consumer_secret"]
c2c_mail_sender_password=data_bag_item("secrets", "passwords")["c2c_mail_sender_password"]
  
%w(profile cloud).each do |name|
  template "#{node.c2c.server.opt}/etc/#{name}.properties" do
    source "#{name}.properties.erb"
    variables :github_consumer_secret => github_consumer_secret, :c2c_mail_sender_password => c2c_mail_sender_password
    owner node.c2c.user
    group node.tomcat.group
    mode 0660
    notifies :restart, "service[tomcat]" 
  end
end

#XXX cookbook_file for prod?
c2c_ssh_key "#{node.c2c.server.opt}/etc/ssh-key.pem" do
  mkdir false
  bits 4096
  owner node.tomcat.user
  group node.tomcat.group
end

execute "chown #{node.tomcat.user}:#{node.tomcat.user} #{node.c2c.server.opt}/etc/ssh-key.pem #{node.c2c.server.opt}/etc/ssh-key.pem.pub " do
end

c2c_ssh_key "#{node.c2c.user_home}/.ssh/id_rsa"
build_key_file = "#{node.c2c.server.opt}/etc/builder_id_rsa"
execute "cp #{node.c2c.user_home}/.ssh/id_rsa #{build_key_file}; chown #{node.tomcat.user}:#{node.tomcat.user} #{build_key_file}" do
  creates "#{build_key_file}"
end

template "#{node.c2c.server.opt}/etc/applicationContext-serviceHosts.xml" do
  path "#{node.c2c.server.opt}/etc/applicationContext-serviceHosts.xml"
  owner node.c2c.user
  group node.tomcat.group
  mode 0660
  source "applicationContext-serviceHosts.xml.erb"
  notifies :restart, "service[tomcat]"
end

directory "#{node.c2c.server.opt}/activeMQ" do
  owner node.tomcat.user
  group node.tomcat.group
end

# Deployment
if node.c2c.hub.prefix_path.empty?
  name = "ROOT"
else
  name = ::File.basename(node.c2c.hub.prefix_path)
end


if node.c2c.hub.has_internal_services
  webappDir="#{node.tomcat.second_webapp_dir}"
else
  webappDir="#{node.tomcat.webapp_dir}"
end

c2c_server_deployment "hub" do 
  artifacts [ { "name" => name,  "package" => "profile.web", "webapp_dir" => webappDir} ]
  action :deploy
  provider "c2c_server_#{node.c2c.server.deploy_type}"
end                                      

