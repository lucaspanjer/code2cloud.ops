directory "#{node.ant.root_dir}" do
  action :create
  mode 0755
end


remote_file "/opt/code2cloud/chef/#{node.ant.package}" do
  source node.ant.url
  action :create_if_missing
  mode 0644
end

execute "tar xzvf /opt/code2cloud/chef/#{node.ant.package}" do
  cwd node.ant.root_dir
  not_if { File.exists?(node.ant.install_dir)}
end

execute "ln -s #{node.ant.root_dir}/#{node.ant.install_dir}/bin/ant #{node.ant.bin}" do
  not_if { File.exists?(node.ant.bin)}
end
