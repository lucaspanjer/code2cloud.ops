#for service[ssh]
include_recipe "openssh"
#include_recipe "maven"
include_recipe "etchosts::default"


c2c_user node.c2c.hslave.build_user

package "git"

cookbook_file "#{node.c2c.user_home_prefix}/#{node.c2c.hslave.build_user}/.gitconfig" do
  source "gitconfig"
end

cookbook_file "/etc/ssh/sshd_config" do
  owner "root"
  group "root"
  mode 0644
  # Restart sshd right away to avoid state where chef gets killed before end of run and sshd is not restarted
  notifies :restart, resources(:service => "ssh"), :immediately 
end

m2 = "#{node.c2c.user_home_prefix}/#{node.c2c.hslave.build_user}/.m2"

directory m2 do
  owner node.c2c.hslave.build_user
  group node.c2c.hslave.build_user
end

link "#{node.c2c.user_home_prefix}/c2c" do
  to "#{node.c2c.user_home_prefix}/#{node.c2c.hslave.build_user}"
end

template "#{m2}/settings.xml" do
  source "m2_settings.xml.erb"
  mode 0600
  owner node.c2c.hslave.build_user
  group node.c2c.hslave.build_user
end

directory "/opt/c2c" do
  owner node.c2c.hslave.build_user
  group node.c2c.hslave.build_user
end

execute "copy slave.jar to /opt/c2c/slave.jar" do
  command "cp /opt/code2cloud/chef/slave-jar-#{node.c2c.server.version}.jar /opt/c2c/slave.jar"
  not_if {File.exists?("/opt/c2c/slave.jar")}
end

# Maven (TODO, move to opscode cookbooks maven package for oracle platform?)
remote_file "/opt/code2cloud/chef/#{node.c2c.hslave.maven.package}" do
  source node.c2c.hslave.maven.url
  action :create_if_missing
  mode 0644
  action :create_if_missing
  not_if { File.exists?(node.c2c.hslave.maven.bin) }
end

directory node.c2c.hslave.maven.root_dir do
  action :create
  owner node.c2c.user
  mode 0755
end

execute "tar -zxf /opt/code2cloud/chef/#{node.c2c.hslave.maven.package}" do
  cwd node.c2c.hslave.maven.root_dir
  user node.c2c.user
  not_if { File.exists?(node.c2c.hslave.maven.bin) }
end 

link "/usr/local/bin/mvn" do
  to "#{node.c2c.hslave.maven.bin}"
end
