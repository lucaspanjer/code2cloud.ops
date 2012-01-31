#for service[ssh]
include_recipe "openssh"
include_recipe "maven"
include_recipe "etchosts::default"


cfc_user "builder"

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

cookbook_file "/home/builder/.gitconfig" do
  source "gitconfig"
end

cookbook_file "/etc/ssh/sshd_config" do
  owner "root"
  group "root"
  mode 0644
  notifies :restart, "service[ssh]"
end

m2 = "/home/builder/.m2"

directory m2 do
  owner "builder"
  group "builder"
end

link "/home/c2c" do
  to "/home/builder"
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
  owner "builder"
  group "builder"
end

remote_file "/opt/c2c/slave.jar" do
  source "#{cfc_hudson_url}/jnlpJars/slave.jar"
  owner "builder"
  group "builder"
  mode 0644
  backup false
end
