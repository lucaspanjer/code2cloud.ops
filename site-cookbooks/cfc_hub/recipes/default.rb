#require 'mysql'

#for service[ssh]
include_recipe "openssh"

#cookbook_file "/etc/ssh/sshd_config" do
#  owner "root"
#  group "root"
#  mode 0644
#  notifies :restart, "service[ssh]"
#end


# This is only needed when we deploy the hub on the same VM as other services
if node.cfc.hub.has_internal_services
  node.override["cfc"]["tomcat"]["instance_name"] = "hub-tomcat"  
  node.override["cfc"]["tomcat"]["instance_base"] =  "/var/lib/#{node.cfc.tomcat.instance_name}"
  node.override["cfc"]["tomcat"]["instance_webapps"] =  "#{node.cfc.tomcat.instance_base}/webapps"

  include_recipe "cfc_server::tc-instance"

  link "#{node.cfc.server.opt}/hub_webapps" do
    to "#{node.cfc.tomcat.instance_base}/webapps"
    owner node.cfc.user
    group node.tomcat.group
  end
  
  link "#{node.cfc.server.opt}/hub_tc_logs" do
    to "#{node.cfc.tomcat.instance_base}/logs"
    owner node.cfc.user
    group node.cfc.group
  end
end

include_recipe "cfc_server"

%w(profile cloud).each do |name|
  template "#{node.cfc.server.opt}/etc/#{name}.properties" do
    source "#{name}.properties.erb"
    owner node.cfc.user
    group node.tomcat.group
    mode 0660
    notifies :restart, "service[tomcat]" #fixme should be hub tomcat in some cases
  end
end

#XXX cookbook_file for prod?
cfc_ssh_key "#{node.cfc.server.opt}/etc/ssh-key.pem" do
  mkdir false
  bits 4096
  owner node.tomcat.user
  group node.tomcat.group
end

execute "chown #{node.tomcat.user}:#{node.tomcat.user} #{node.cfc.server.opt}/etc/ssh-key.pem #{node.cfc.server.opt}/etc/ssh-key.pem.pub " do
end

cfc_ssh_key "#{node.cfc.user_home}/.ssh/id_rsa"
build_key_file = "#{node.cfc.server.opt}/etc/builder_id_rsa"
execute "cp #{node.cfc.user_home}/.ssh/id_rsa #{build_key_file}; chown #{node.tomcat.user}:#{node.tomcat.user} #{build_key_file}" do
  creates "#{build_key_file}"
end

directory "#{node.cfc.server.opt}/activeMQ" do
  owner node.tomcat.user
  group node.tomcat.group
end

# Deployment
if node.cfc.hub.prefix_path.empty?
  name = "ROOT"
else
  name = ::File.basename(node.cfc.hub.prefix_path)
end


if node.cfc.hub.has_internal_services
  serviceName="#{node.cfc.tomcat.instance_name}"
else
  serviceName="tomcat"
end

cfc_server_deployment "hub" do 
  artifacts [ { "name" => name,  "package" => "profile.web", "webapp_dir" => "#{node.cfc.tomcat.instance_webapps}",
              "service" => serviceName} ]
  action :deploy
  provider "cfc_server_#{node.cfc.server.deploy_type}"
end                                      

=begin
table = "SERVICEHOST"
database = "profile"
#XXX this could be more dynamic using search()
ruby_block "update #{database} #{table}" do
  block do
    db = Mysql.new node.cfc.hosts.db.ipaddress, database, node.cfc.mysql_pw.profile, "profile"
    begin
      if db.list_tables(table).first
        db.query("select TYPE,INTERNALNETWORKADDRESS from #{table} where INTERNALNETWORKADDRESS = '127.0.0.1'").each do |row|
          type, ip = row
          next unless host = node.cfc.hosts[type.downcase]
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
