#convenience variables. need to be here rather than attributes/ due to the way were are included
node[:tcs][:bundle] = "springsource-tc-server-#{node[:tcs][:flavor]}-#{node[:tcs][:version]}"
node[:tcs][:package] = "#{node[:tcs][:bundle]}.tar.gz"
node[:tcs][:home] = "#{node[:tcs][:root_dir]}/springsource-tc-server-#{node[:tcs][:flavor]}"
node[:tcs][:instance_dir] = "#{node[:tcs][:home]}/#{node[:tcs][:instance]}"
node[:tcs][:webapps] = "#{node[:tcs][:instance_dir]}/webapps"
node[:tcs][:pidfile] = "#{node[:tcs][:instance_dir]}/logs/tcserver.pid"

directory node.tcs.root_dir do
  mode 0700
  owner node.tcs.user
  group node.tcs.group
end

execute "unpack-tcs" do
  command "tar -zxf #{node.tcs.package}"
  user node.tcs.user
  group node.tcs.group
  cwd node.tcs.root_dir
  action :nothing
end

remote_file "#{node.tcs.root_dir}/#{node.tcs.package}" do
  action :create_if_missing
  source "#{node.tcs.mirror}/#{node.tcs.package}"
  owner node.tcs.user
  group node.tcs.group
  backup false
  notifies :run, "execute[unpack-tcs]", :immediately
end

file "#{node.tcs.instance_dir}.properties" do
  owner node.tcs.user
  group node.tcs.group
  content node.tcs.config.sort_by {|k,v| k }.map { |key,val|
    "#{key} = #{val}"
  }.join("\n")
  notifies :run, "execute[create instance]", :immediately
  notifies :restart, "service[#{node.tcs.service}]"
end

execute "create instance" do
  command "#{node.tcs.home}/tcruntime-instance.sh" +
          " create #{node.tcs.instance} --force" +
          " --properties-file #{node.tcs.instance_dir}.properties"
  user node.tcs.user
  group node.tcs.group
  cwd node.tcs.home
  environment "JAVA_HOME" => node.java.java_home
  action :nothing
end

#optionally link $instance/webapps elsewhere
if node.tcs[:webapps_home] and !File.symlink?(node.tcs.webapps)
  directory node.tcs.webapps do
    recursive true
    action :delete
  end

  link node.tcs.webapps do
    to node.tcs.webapps_home
    notifies :restart, "service[#{node.tcs.service}]"
  end
end

template "#{node.tcs.instance_dir}/bin/setenv.sh" do
  source "setenv.sh.erb"
  owner node.tcs.user
  group node.tcs.group
  notifies :restart, "service[#{node.tcs.service}]"
end

template "/etc/init.d/#{node.tcs.service}" do
  source "tcserver.erb"
  mode "0755"
  notifies :restart, "service[#{node.tcs.service}]"
end

service node.tcs.service do
  supports :status => true, :restart => true
  action :enable
end
