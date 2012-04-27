#for service[ssh]
include_recipe "openssh"
#include_recipe "maven"
include_recipe "etchosts::default"


cfc_user node.cfc.hslave.build_user

## FIXME this does not work with chef solo (the search)
#add hmaster and hub to authorized_keys
#pubkeys = []
#search(:node, "role:cfc-hmaster OR role:cfc-hub").each do |host|
#  next unless host[:cfc][:ssh_pubkey]
#  if key = host[:cfc][:ssh_pubkey]["/home/vcloud/.ssh/id_rsa"]
#    pubkeys << key
#  end
#end
#
#cfc_authorized_keys "builder" do
#  keys pubkeys
#  dir "/etc/ssh"
#end

cookbook_file "#{node.cfc.user_home_prefix}/#{node.cfc.hslave.build_user}/.gitconfig" do
  source "gitconfig"
end

unless platform?("oracle")
  cookbook_file "/etc/ssh/sshd_config" do
    owner "root"
    group "root"
    mode 0644
    notifies :restart, "service[ssh]"
  end
end

m2 = "/#{node.cfc.user_home_prefix}/#{node.cfc.hslave.build_user}/.m2"

directory m2 do
  owner node.cfc.hslave.build_user
  group node.cfc.hslave.build_user
end

link "#{node.cfc.user_home_prefix}/c2c" do
  to "#{node.cfc.user_home_prefix}/builder"
end

template "#{m2}/settings.xml" do
  source "m2_settings.xml.erb"
  mode 0600
  owner "builder"
  group "builder"
end

template "/etc/environment" do
  source "environment.erb"
  mode 0644
end

directory "/opt/c2c" do
  owner node.cfc.hslave.build_user
  group node.cfc.hslave.build_user
end

remote_file "/opt/c2c/slave.jar" do
  source "#{cfc_hudson_url}/jnlpJars/slave.jar"
  owner node.cfc.hslave.build_user
  group node.cfc.hslave.build_user
  mode 0644
  backup false
end
