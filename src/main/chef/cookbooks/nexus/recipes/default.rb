user node.nexus.user

directory node.nexus.root_dir do
  action :create
  owner node.nexus.user
  mode 0755
end

remote_file "#{node.nexus.root_dir}/#{node.nexus.package}" do
  source node.nexus.url
  action :create_if_missing
  mode 0644
end

execute "tar -zxf #{node.nexus.package}" do
  cwd node.nexus.root_dir
  user node.nexus.user
  not_if { File.exists?(node.nexus.bin) }
end

link "#{node.nexus.root_dir}/nexus" do
  to node.nexus.path
end

directory node.nexus.work do
  owner node.nexus.user
  recursive true
end

template "#{node.nexus.path}/bin/jsw/conf/wrapper.conf" do
  source "wrapper.conf.erb"
  owner node.nexus.user
  notifies :restart, "service[nexus]"
end

template "#{node.nexus.path}/conf/plexus.properties" do
  source "plexus.properties.erb"
  owner node.nexus.user
  notifies :restart, "service[nexus]"
end

template "/etc/init.d/nexus" do
  source "nexus.erb"
  mode 0755
  notifies :restart, "service[nexus]"
end

service "nexus" do
  action [:enable, :start]
end
