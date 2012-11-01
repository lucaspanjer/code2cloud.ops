#require 'mysql'

#for service[ssh]
include_recipe "openssh"

#cookbook_file "/etc/ssh/sshd_config" do
#  owner "root"
#  group "root"
#  mode 0644
#  notifies :restart, "service[ssh]"
#end

node.override[:etchosts][:hub_entry] = false

# This is only needed when we deploy the hub on the same VM as other services
if node.c2c.hub.has_internal_services
  node.override["c2c"]["tomcat"]["instance_name"] = "hub-tomcat"  
  node.override["c2c"]["tomcat"]["instance_base"] =  "/var/lib/#{node.c2c.tomcat.instance_name}"
  node.override["c2c"]["tomcat"]["instance_webapps"] =  "#{node.c2c.tomcat.instance_base}/webapps"

  include_recipe "c2c_server::tc-instance"

  link "#{node.c2c.server.opt}/hub_webapps" do
    to "#{node.c2c.tomcat.instance_base}/webapps"
    owner node.c2c.user
    group node.tomcat.group
  end
  
  link "#{node.c2c.server.opt}/hub_tc_logs" do
    to "#{node.c2c.tomcat.instance_base}/logs"
    owner node.c2c.user
    group node.c2c.group
  end
end

include_recipe "c2c_server"

%w(profile cloud).each do |name|
  template "#{node.c2c.server.opt}/etc/#{name}.properties" do
    source "#{name}.properties.erb"
    owner node.c2c.user
    group node.tomcat.group
    mode 0660
    notifies :restart, "service[tomcat]" #fixme should be hub tomcat in some cases
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
  serviceName="#{node.c2c.tomcat.instance_name}"
else
  serviceName="tomcat"
end

c2c_server_deployment "hub" do 
  artifacts [ { "name" => name,  "package" => "profile.web", "webapp_dir" => "#{node.c2c.tomcat.instance_webapps}",
              "service" => serviceName} ]
  action :deploy
  provider "c2c_server_#{node.c2c.server.deploy_type}"
end                                      

=begin
table = "SERVICEHOST"
database = "profile"
#XXX this could be more dynamic using search()
ruby_block "update #{database} #{table}" do
  block do
    db = Mysql.new node.c2c.hosts.db.ipaddress, database, node.c2c.mysql_pw.profile, "profile"
    begin
      if db.list_tables(table).first
        db.query("select TYPE,INTERNALNETWORKADDRESS from #{table} where INTERNALNETWORKADDRESS = '127.0.0.1'").each do |row|
          type, ip = row
          next unless host = node.c2c.hosts[type.downcase]
          next if ip == host[:ipaddress]
          query = "UPDATE #{table} SET INTERNALNETWORKADDRESS = '#{host[:ipaddress]}' WHERE TYPE = '#{type}'"
          Chef::Log.info(query)
          db.query(query)
        end
      else
        Chef::Log.warn("#{table} table does not exist yet, unable to update.")
      end
    ensure
      db.close
    end
  end
end
=end